!! Must compile manually
!! ifort -FR get_rda_data.f -o get_rda_data.exe

!! This program reads data in little_r format and write data in little_r format,
!! BUT with a different interval in the data files.
!! This be because the files on the archive system is in 6 hourly intervals, 
!! which is not typically an interval time we use.

!! This program will read the OBSGRID namelist.oa file to find the start and end
!! time needed for your run.
!! Output is currently hardcoded to be in 3hourly intervals. 



program get_rda_data

   IMPLICIT NONE

   INTEGER :: funit, ios, start_unit, itimes, iunit
   INTEGER :: start_year, start_month, start_day, start_hour, start_minute, start_second
   INTEGER ::   end_year,   end_month,   end_day,   end_hour,   end_minute, end_second
   INTEGER :: interval, idiff, n_times
   INTEGER, DIMENSION(501) :: iunits
   CHARACTER (LEN=14), DIMENSION(502) :: search_times
   CHARACTER (LEN=19) :: start_date, end_date, rdate, sdate
   CHARACTER (LEN=17) :: obs_file
   CHARACTER (len=600) :: header
   CHARACTER (len=200) :: observations
   CHARACTER (len=21)  :: end_line
   LOGICAL :: is_used


   namelist  /record1/ start_year, start_month, start_day, start_hour, start_minute, start_second, &
                         end_year,   end_month,   end_day,   end_hour,   end_minute,   end_second, &
                       interval

   start_minute = 0
   start_second = 0
   end_minute = 0
   end_second = 0


! Read parameters from Fortran namelist
   DO funit=15,100
      inquire(unit=funit, opened=is_used)
      IF (.not. is_used) EXIT
   END DO
   OPEN(funit,file='namelist.oa',status='old',form='formatted')
   READ(funit,record1)
   CLOSE(funit)

! We want to over write the interval to 3 hours
   interval = 10800

! Build starting date string
   WRITE(start_date, '(i4.4,a1,i2.2,a1,i2.2,a1,i2.2,a1,i2.2,a1,i2.2)') &
         start_year,'-',start_month,'-',start_day,'_',start_hour,':',start_minute,':',start_second

! Build ending date string
   WRITE(end_date, '(i4.4,a1,i2.2,a1,i2.2,a1,i2.2,a1,i2.2,a1,i2.2)') &
         end_year,'-',end_month,'-',end_day,'_',end_hour,':',end_minute,':',end_second

! See which times we are interested in
   CALL geth_idts(end_date, start_date, idiff)
   IF ( idiff < 0 ) idiff = 1
   n_times = idiff / interval

   IF (n_times > 500) THEN
     PRINT*,"Cannot deal with more that 500 times"
     PRINT*,"   Please set time range smaller OR "
     PRINT*,"   change dimensions"
     PRINT*," "
     STOP
   ENDIF 


! Open the input and junk (other_obs) files as well as the OBS files - cannot be
! bigger that 500 for now
   OPEN(10,FILE="rda_obs")
   !!OPEN(11,FILE="other_obs")

   start_unit = 12
   rdate = start_date
   CALL geth_newdate(sdate, trim(rdate), -5400)
   READ(sdate,FMT='(    I4.4)') start_year
   READ(sdate,FMT='( 5X,I2.2)') start_month
   READ(sdate,FMT='( 8X,I2.2)') start_day
   READ(sdate,FMT='(11X,I2.2)') start_hour
   READ(sdate,FMT='(14X,I2.2)') start_minute
   READ(sdate,FMT='(17X,I2.2)') start_second
   WRITE(search_times(1),'(i4.4,i2.2,i2.2,i2.2,i2.2,i2.2)') &
         start_year,start_month,start_day,start_hour,start_minute,start_second
   
   LOOP_TIMES : DO itimes = 1, n_times+1

     iunits(itimes) = start_unit + itimes
     WRITE(obs_file,'("OBS:",A13)') rdate(:13)
     OPEN(iunits(itimes),FILE=obs_file)

     CALL geth_newdate(sdate, trim(rdate), 5400)
     READ(sdate,FMT='(    I4.4)') start_year
     READ(sdate,FMT='( 5X,I2.2)') start_month
     READ(sdate,FMT='( 8X,I2.2)') start_day
     READ(sdate,FMT='(11X,I2.2)') start_hour
     READ(sdate,FMT='(14X,I2.2)') start_minute
     READ(sdate,FMT='(17X,I2.2)') start_second
     WRITE(search_times(itimes+1),'(i4.4,i2.2,i2.2,i2.2,i2.2,i2.2)') &
           start_year,start_month,start_day,start_hour,start_minute,start_second

     CALL geth_newdate(rdate, trim(start_date), itimes*interval)
     
     print*,"Creating : ", obs_file
     !!print*,"                 ", search_times(itimes), "   ", search_times(itimes+1)

   END DO LOOP_TIMES
 
   print*," "
   print*," Sorting Data"
   print*," "

     read_data : DO

       READ(10,"(A600)",IOSTAT=ios) header

       IF ( ios < 0 ) EXIT read_data

       iunit = 11
       SEARCH_UNIT : DO itimes = 1, n_times+1
         IF ( header(327:340) >= search_times(itimes) .AND. &
              header(327:340) < search_times(itimes+1) ) iunit = iunits(itimes)
       END DO SEARCH_UNIT
       !!print*,"Data and file unit ", header(327:340), iunit

       IF ( iunit > 11 ) THEN
         WRITE(iunit, "(A)") header
       
         read_obs : DO
           READ(10,"(A200)") observations
           WRITE(iunit, "(A)") observations
           if (observations(1:7) == "-777777" ) EXIT read_obs
         ENDDO read_obs
  
         READ(10,"(A21)") end_line
         WRITE(iunit, "(A)") end_line
       END IF  
       
    ENDDO read_data 

    print*,"My work is done"

end program get_rda_data


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

   SUBROUTINE geth_idts (ndate, odate, idts)
   
      !!IMPLICIT NONE
      
      !  From 2 input mdates ('YYYY-MM-DD HH:MM:SS.ffff'), 
      !  compute the time difference.
      
      !  on entry     -  ndate  -  the new hdate.
      !                  odate  -  the old hdate.
      
      !  on exit      -  idts    -  the change in time in seconds.
      
      CHARACTER (LEN=*) , INTENT(INOUT) :: ndate, odate
      INTEGER           , INTENT(OUT)   :: idts
      
      !  Local Variables
      
      !  yrnew    -  indicates the year associated with "ndate"
      !  yrold    -  indicates the year associated with "odate"
      !  monew    -  indicates the month associated with "ndate"
      !  moold    -  indicates the month associated with "odate"
      !  dynew    -  indicates the day associated with "ndate"
      !  dyold    -  indicates the day associated with "odate"
      !  hrnew    -  indicates the hour associated with "ndate"
      !  hrold    -  indicates the hour associated with "odate"
      !  minew    -  indicates the minute associated with "ndate"
      !  miold    -  indicates the minute associated with "odate"
      !  scnew    -  indicates the second associated with "ndate"
      !  scold    -  indicates the second associated with "odate"
      !  i        -  loop counter
      !  mday     -  a list assigning the number of days in each month
      
      CHARACTER (LEN=24) :: tdate
      INTEGER :: olen, nlen
      INTEGER :: yrnew, monew, dynew, hrnew, minew, scnew
      INTEGER :: yrold, moold, dyold, hrold, miold, scold
      INTEGER :: mday(12), i, newdys, olddys
      LOGICAL :: npass, opass
      INTEGER :: isign
      
      IF (odate.GT.ndate) THEN
         isign = -1
         tdate=ndate
         ndate=odate
         odate=tdate
      ELSE
         isign = 1
      END IF
      
      !  Assign the number of days in a months
      
      mday( 1) = 31
      mday( 2) = 28
      mday( 3) = 31
      mday( 4) = 30
      mday( 5) = 31
      mday( 6) = 30
      mday( 7) = 31
      mday( 8) = 31
      mday( 9) = 30
      mday(10) = 31
      mday(11) = 30
      mday(12) = 31
      
      !  Break down old hdate into parts
      
      hrold = 0
      miold = 0
      scold = 0
      olen = LEN(odate)
      
      READ(odate(1:4),  '(I4)') yrold
      READ(odate(6:7),  '(I2)') moold
      READ(odate(9:10), '(I2)') dyold
      IF (olen.GE.13) THEN
         READ(odate(12:13),'(I2)') hrold
         IF (olen.GE.16) THEN
            READ(odate(15:16),'(I2)') miold
            IF (olen.GE.19) THEN
               READ(odate(18:19),'(I2)') scold
            END IF
         END IF
      END IF
      
      !  Break down new hdate into parts
      
      hrnew = 0
      minew = 0
      scnew = 0
      nlen = LEN(ndate)
      
      READ(ndate(1:4),  '(I4)') yrnew
      READ(ndate(6:7),  '(I2)') monew
      READ(ndate(9:10), '(I2)') dynew
      IF (nlen.GE.13) THEN
         READ(ndate(12:13),'(I2)') hrnew
         IF (nlen.GE.16) THEN
            READ(ndate(15:16),'(I2)') minew
            IF (nlen.GE.19) THEN
               READ(ndate(18:19),'(I2)') scnew
            END IF
         END IF
      END IF
      
      !  Check that the dates make sense.
      
      npass = .true.
      opass = .true.
      
      !  Check that the month of NDATE makes sense.
      
      IF ((monew.GT.12).or.(monew.LT.1)) THEN
         PRINT*, 'GETH_IDTS:  Month of NDATE = ', monew
         npass = .false.
      END IF
      
      !  Check that the month of ODATE makes sense.
      
      IF ((moold.GT.12).or.(moold.LT.1)) THEN
         PRINT*, 'GETH_IDTS:  Month of ODATE = ', moold
         opass = .false.
      END IF
      
      !  Check that the day of NDATE makes sense.
      
      IF (monew.ne.2) THEN
      ! ...... For all months but February
         IF ((dynew.GT.mday(monew)).or.(dynew.LT.1)) THEN
            PRINT*, 'GETH_IDTS:  Day of NDATE = ', dynew
            npass = .false.
         END IF
      ELSE IF (monew.eq.2) THEN
      ! ...... For February
         IF ((dynew.GT.nfeb(yrnew)).or.(dynew.LT.1)) THEN
            PRINT*, 'GETH_IDTS:  Day of NDATE = ', dynew
            npass = .false.
         END IF
      END IF
      
      !  Check that the day of ODATE makes sense.
      
      IF (moold.ne.2) THEN
      ! ...... For all months but February
         IF ((dyold.GT.mday(moold)).OR.(dyold.LT.1)) THEN
            PRINT*, 'GETH_IDTS:  Day of ODATE = ', dyold
            opass = .false.
         END IF
      ELSE IF (moold.eq.2) THEN
      ! ....... For February
         IF ((dyold.GT.nfeb(yrold)).OR.(dyold.LT.1)) THEN
            PRINT*, 'GETH_IDTS:  Day of ODATE = ', dyold
            opass = .false.
         END IF
      END IF
      
      !  Check that the hour of NDATE makes sense.
      
      IF ((hrnew.GT.23).or.(hrnew.LT.0)) THEN
         PRINT*, 'GETH_IDTS:  Hour of NDATE = ', hrnew
         npass = .false.
      END IF
      
      !  Check that the hour of ODATE makes sense.
      
      IF ((hrold.GT.23).or.(hrold.LT.0)) THEN
         PRINT*, 'GETH_IDTS:  Hour of ODATE = ', hrold
         opass = .false.
      END IF
      
      !  Check that the minute of NDATE makes sense.
      
      IF ((minew.GT.59).or.(minew.LT.0)) THEN
         PRINT*, 'GETH_IDTS:  Minute of NDATE = ', minew
         npass = .false.
      END IF
      
      !  Check that the minute of ODATE makes sense.
      
      IF ((miold.GT.59).or.(miold.LT.0)) THEN
         PRINT*, 'GETH_IDTS:  Minute of ODATE = ', miold
         opass = .false.
      END IF
      
      !  Check that the second of NDATE makes sense.
      
      IF ((scnew.GT.59).or.(scnew.LT.0)) THEN
         PRINT*, 'GETH_IDTS:  SECOND of NDATE = ', scnew
         npass = .false.
      END IF
      
      !  Check that the second of ODATE makes sense.
      
      IF ((scold.GT.59).or.(scold.LT.0)) THEN
         PRINT*, 'GETH_IDTS:  Second of ODATE = ', scold
         opass = .false.
      END IF
      
      IF (.not. npass) THEN
         PRINT*, 'Screwy NDATE: ', ndate(1:nlen)
         STOP 'ndate_2'
      END IF
      
      IF (.not. opass) THEN
         PRINT*, 'Screwy ODATE: ', odate(1:olen)
         STOP 'odate_1'
      END IF
      
      !  Date Checks are completed.  Continue.
      
      !  Compute number of days from 1 January ODATE, 00:00:00 until ndate
      !  Compute number of hours from 1 January ODATE, 00:00:00 until ndate
      !  Compute number of minutes from 1 January ODATE, 00:00:00 until ndate
      
      newdys = 0
      DO i = yrold, yrnew - 1
         newdys = newdys + 365 + (nfeb(i)-28)
      END DO
      
      IF (monew .GT. 1) THEN
         mday(2) = nfeb(yrnew)
         DO i = 1, monew - 1
            newdys = newdys + mday(i)
         END DO
         mday(2) = 28
      END IF
      
      newdys = newdys + dynew-1
      
      !  Compute number of hours from 1 January ODATE, 00:00:00 until odate
      !  Compute number of minutes from 1 January ODATE, 00:00:00 until odate
      
      olddys = 0
      
      IF (moold .GT. 1) THEN
         mday(2) = nfeb(yrold)
         DO i = 1, moold - 1
            olddys = olddys + mday(i)
         END DO
         mday(2) = 28
      END IF
      
      olddys = olddys + dyold-1
      
      !  Determine the time difference in seconds
      
      idts = (newdys - olddys) * 86400
      idts = idts + (hrnew - hrold) * 3600
      idts = idts + (minew - miold) * 60
      idts = idts + (scnew - scold)
      
      IF (isign .eq. -1) THEN
         tdate=ndate
         ndate=odate
         odate=tdate
         idts = idts * isign
      END IF
   
   END SUBROUTINE geth_idts

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

   SUBROUTINE geth_newdate (ndate, odate, idt)
   
      !!IMPLICIT NONE
      
      !  From old date ('YYYY-MM-DD HH:MM:SS.ffff') and 
      !  delta-time, compute the new date.
   
      !  on entry     -  odate  -  the old hdate.
      !                  idt    -  the change in time
   
      !  on exit      -  ndate  -  the new hdate.
      
      INTEGER , INTENT(IN)           :: idt
      CHARACTER (LEN=*) , INTENT(OUT) :: ndate
      CHARACTER (LEN=*) , INTENT(IN)  :: odate
      
       
      !  Local Variables
       
      !  yrold    -  indicates the year associated with "odate"
      !  moold    -  indicates the month associated with "odate"
      !  dyold    -  indicates the day associated with "odate"
      !  hrold    -  indicates the hour associated with "odate"
      !  miold    -  indicates the minute associated with "odate"
      !  scold    -  indicates the second associated with "odate"
       
      !  yrnew    -  indicates the year associated with "ndate"
      !  monew    -  indicates the month associated with "ndate"
      !  dynew    -  indicates the day associated with "ndate"
      !  hrnew    -  indicates the hour associated with "ndate"
      !  minew    -  indicates the minute associated with "ndate"
      !  scnew    -  indicates the second associated with "ndate"
       
      !  mday     -  a list assigning the number of days in each month
      
      !  i        -  loop counter
      !  nday     -  the integer number of days represented by "idt"
      !  nhour    -  the integer number of hours in "idt" after taking out
      !              all the whole days
      !  nmin     -  the integer number of minutes in "idt" after taking out
      !              all the whole days and whole hours.
      !  nsec     -  the integer number of minutes in "idt" after taking out
      !              all the whole days, whole hours, and whole minutes.
       
      INTEGER :: nlen, olen
      INTEGER :: yrnew, monew, dynew, hrnew, minew, scnew, frnew
      INTEGER :: yrold, moold, dyold, hrold, miold, scold, frold
      INTEGER :: mday(12), nday, nhour, nmin, nsec, nfrac, i, ifrc
      LOGICAL :: opass
      CHARACTER (LEN=10) :: hfrc
      CHARACTER (LEN=1) :: sp
      
      !  Assign the number of days in a months
      
      mday( 1) = 31
      mday( 2) = 28
      mday( 3) = 31
      mday( 4) = 30
      mday( 5) = 31
      mday( 6) = 30
      mday( 7) = 31
      mday( 8) = 31
      mday( 9) = 30
      mday(10) = 31
      mday(11) = 30
      mday(12) = 31
      
      !  Break down old hdate into parts
      
      hrold = 0
      miold = 0
      scold = 0
      frold = 0
      olen = LEN(odate)
      IF (olen.GE.11) THEN
         sp = odate(11:11)
      else
         sp = ' '
      END IF
      
      !  Use internal READ statements to convert the CHARACTER string
      !  date into INTEGER components.
   
      READ(odate(1:4),  '(I4)') yrold
      READ(odate(6:7),  '(I2)') moold
      READ(odate(9:10), '(I2)') dyold
      IF (olen.GE.13) THEN
         READ(odate(12:13),'(I2)') hrold
         IF (olen.GE.16) THEN
            READ(odate(15:16),'(I2)') miold
            IF (olen.GE.19) THEN
               READ(odate(18:19),'(I2)') scold
               IF (olen.GT.20) THEN
                  READ(odate(21:olen),'(I2)') frold
               END IF
            END IF
         END IF
      END IF
      
      !  Set the number of days in February for that year.
      
      mday(2) = nfeb(yrold)
      
      !  Check that ODATE makes sense.
      
      opass = .TRUE.
      
      !  Check that the month of ODATE makes sense.
      
      IF ((moold.GT.12).or.(moold.LT.1)) THEN
         WRITE(*,*) 'GETH_NEWDATE:  Month of ODATE = ', moold
         opass = .FALSE.
      END IF
      
      !  Check that the day of ODATE makes sense.
      
      IF ((dyold.GT.mday(moold)).or.(dyold.LT.1)) THEN
         WRITE(*,*) 'GETH_NEWDATE:  Day of ODATE = ', dyold
         opass = .FALSE.
      END IF
      
      !  Check that the hour of ODATE makes sense.
      
      IF ((hrold.GT.23).or.(hrold.LT.0)) THEN
         WRITE(*,*) 'GETH_NEWDATE:  Hour of ODATE = ', hrold
         opass = .FALSE.
      END IF
      
      !  Check that the minute of ODATE makes sense.
      
      IF ((miold.GT.59).or.(miold.LT.0)) THEN
         WRITE(*,*) 'GETH_NEWDATE:  Minute of ODATE = ', miold
         opass = .FALSE.
      END IF
      
      !  Check that the second of ODATE makes sense.
      
      IF ((scold.GT.59).or.(scold.LT.0)) THEN
         WRITE(*,*) 'GETH_NEWDATE:  Second of ODATE = ', scold
         opass = .FALSE.
      END IF
      
      !  Check that the fractional part  of ODATE makes sense.
      
      !KWM      IF ((scold.GT.59).or.(scold.LT.0)) THEN
      !KWM         WRITE(*,*) 'GETH_NEWDATE:  Second of ODATE = ', scold
      !KWM         opass = .FALSE.
      !KWM      END IF
      
      IF (.not.opass) THEN
         WRITE(*,*) 'GETH_NEWDATE: Crazy ODATE: ', odate(1:olen), olen
         STOP 'odate_3'
      END IF
      
      !  Date Checks are completed.  Continue.
      
      
      !  Compute the number of days, hours, minutes, and seconds in idt
      
      IF (olen.GT.20) THEN !idt should be in fractions of seconds
         ifrc = olen-20
         ifrc = 10**ifrc
         nday   = ABS(idt)/(86400*ifrc)
         nhour  = MOD(ABS(idt),86400*ifrc)/(3600*ifrc)
         nmin   = MOD(ABS(idt),3600*ifrc)/(60*ifrc)
         nsec   = MOD(ABS(idt),60*ifrc)/(ifrc)
         nfrac = MOD(ABS(idt), ifrc)
      ELSE IF (olen.eq.19) THEN  !idt should be in seconds
         ifrc = 1
         nday   = ABS(idt)/86400 ! Integer number of days in delta-time
         nhour  = MOD(ABS(idt),86400)/3600
         nmin   = MOD(ABS(idt),3600)/60
         nsec   = MOD(ABS(idt),60)
         nfrac  = 0
      ELSE IF (olen.eq.16) THEN !idt should be in minutes
         ifrc = 1
         nday   = ABS(idt)/1440 ! Integer number of days in delta-time
         nhour  = MOD(ABS(idt),1440)/60
         nmin   = MOD(ABS(idt),60)
         nsec   = 0
         nfrac  = 0
      ELSE IF (olen.eq.13) THEN !idt should be in hours
         ifrc = 1
         nday   = ABS(idt)/24 ! Integer number of days in delta-time
         nhour  = MOD(ABS(idt),24)
         nmin   = 0
         nsec   = 0
         nfrac  = 0
      ELSE IF (olen.eq.10) THEN !idt should be in days
         ifrc = 1
         nday   = ABS(idt)/24 ! Integer number of days in delta-time
         nhour  = 0
         nmin   = 0
         nsec   = 0
         nfrac  = 0
      ELSE
         WRITE(*,'(''GETH_NEWDATE: Strange length for ODATE: '', i3)') &
              olen
         WRITE(*,*) odate(1:olen)
         STOP 'odate_4'
      END IF
      
      IF (idt.GE.0) THEN
      
         frnew = frold + nfrac
         IF (frnew.GE.ifrc) THEN
            frnew = frnew - ifrc
            nsec = nsec + 1
         END IF
      
         scnew = scold + nsec
         IF (scnew .GE. 60) THEN
            scnew = scnew - 60
            nmin  = nmin + 1
         END IF
      
         minew = miold + nmin
         IF (minew .GE. 60) THEN
            minew = minew - 60
            nhour  = nhour + 1
         END IF
      
         hrnew = hrold + nhour
         IF (hrnew .GE. 24) THEN
            hrnew = hrnew - 24
            nday  = nday + 1
         END IF
      
         dynew = dyold
         monew = moold
         yrnew = yrold
         DO i = 1, nday
            dynew = dynew + 1
            IF (dynew.GT.mday(monew)) THEN
               dynew = dynew - mday(monew)
               monew = monew + 1
               IF (monew .GT. 12) THEN
                  monew = 1
                  yrnew = yrnew + 1
                  ! If the year changes, recompute the number of days in February
                  mday(2) = nfeb(yrnew)
               END IF
            END IF
         END DO
      
      ELSE IF (idt.LT.0) THEN
      
         frnew = frold - nfrac
         IF (frnew .LT. 0) THEN
            frnew = frnew + ifrc
            nsec = nsec - 1
         END IF
      
         scnew = scold - nsec
         IF (scnew .LT. 00) THEN
            scnew = scnew + 60
            nmin  = nmin + 1
         END IF
      
         minew = miold - nmin
         IF (minew .LT. 00) THEN
            minew = minew + 60
            nhour  = nhour + 1
         END IF
      
         hrnew = hrold - nhour
         IF (hrnew .LT. 00) THEN
            hrnew = hrnew + 24
            nday  = nday + 1
         END IF
      
         dynew = dyold
         monew = moold
         yrnew = yrold
         DO i = 1, nday
            dynew = dynew - 1
            IF (dynew.eq.0) THEN
               monew = monew - 1
               IF (monew.eq.0) THEN
                  monew = 12
                  yrnew = yrnew - 1
                  ! If the year changes, recompute the number of days in February
                  mday(2) = nfeb(yrnew)
               END IF
               dynew = mday(monew)
            END IF
         END DO
      END IF
      
      !  Now construct the new mdate
      
      nlen = LEN(ndate)
      
      IF (nlen.GT.20) THEN
         WRITE(ndate(1:19),19) yrnew, monew, dynew, hrnew, minew, scnew
         WRITE(hfrc,'(I10)') frnew+1000000000
         ndate = ndate(1:19)//'.'//hfrc(31-nlen:10)
      
      ELSE IF (nlen.eq.19.or.nlen.eq.20) THEN
         WRITE(ndate(1:19),19) yrnew, monew, dynew, hrnew, minew, scnew
      19   format(I4,'-',I2.2,'-',I2.2,'_',I2.2,':',I2.2,':',I2.2)
         IF (nlen.eq.20) ndate = ndate(1:19)//'.'
      
      ELSE IF (nlen.eq.16) THEN
         WRITE(ndate,16) yrnew, monew, dynew, hrnew, minew
      16   format(I4,'-',I2.2,'-',I2.2,'_',I2.2,':',I2.2)
      
      ELSE IF (nlen.eq.13) THEN
         WRITE(ndate,13) yrnew, monew, dynew, hrnew
      13   format(I4,'-',I2.2,'-',I2.2,'_',I2.2)
      
      ELSE IF (nlen.eq.10) THEN
         WRITE(ndate,10) yrnew, monew, dynew
      10   format(I4,'-',I2.2,'-',I2.2)
      
      END IF
      
      IF (olen.GE.11) ndate(11:11) = sp
   
   END SUBROUTINE geth_newdate

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

   FUNCTION nfeb ( year ) RESULT (num_days)
   
      ! Compute the number of days in February for the given year
   
      IMPLICIT NONE
   
      INTEGER :: year
      INTEGER :: num_days
   
      num_days = 28 ! By default, February has 28 days ...
      IF (MOD(year,4).eq.0) THEN  
         num_days = 29  ! But every four years, it has 29 days ...
         IF (MOD(year,100).eq.0) THEN
            num_days = 28  ! Except every 100 years, when it has 28 days ...
            IF (MOD(year,400).eq.0) THEN
               num_days = 29  ! Except every 400 years, when it has 29 days.
            END IF
         END IF
      END IF
   
   END FUNCTION nfeb


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

   FUNCTION nfeb_ch ( year_ch ) RESULT (num_days_ch)
   
      ! Compute the number of days in February for the given year
   
      IMPLICIT NONE
   
      INTEGER :: year , num_days
      CHARACTER(LEN=4) :: year_ch
      CHARACTER(LEN=2) :: num_days_ch

      READ ( year_ch , '(I4.4)' ) year
   
      num_days = 28 ! By default, February has 28 days ...
      IF (MOD(year,4).eq.0) THEN  
         num_days = 29  ! But every four years, it has 29 days ...
         IF (MOD(year,100).eq.0) THEN
            num_days = 28  ! Except every 100 years, when it has 28 days ...
            IF (MOD(year,400).eq.0) THEN
               num_days = 29  ! Except every 400 years, when it has 29 days.
            END IF
         END IF
      END IF

      WRITE ( num_days_ch , '(I2.2)' ) num_days
   
   END FUNCTION nfeb_ch

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

   SUBROUTINE split_date_char ( date , century_year , month , day , hour , minute , second )
     
      IMPLICIT NONE
   
      !  Input data.
   
      CHARACTER(LEN=19) , INTENT(IN) :: date 
   
      !  Output data.
   
      INTEGER , INTENT(OUT) :: century_year , month , day , hour , minute , second

      READ(date,FMT='(    I4.4)') century_year
      READ(date,FMT='( 5X,I2.2)') month
      READ(date,FMT='( 8X,I2.2)') day
      READ(date,FMT='(11X,I2.2)') hour
      READ(date,FMT='(14X,I2.2)') minute
      READ(date,FMT='(17X,I2.2)') second
   
   END SUBROUTINE split_date_char
   
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
