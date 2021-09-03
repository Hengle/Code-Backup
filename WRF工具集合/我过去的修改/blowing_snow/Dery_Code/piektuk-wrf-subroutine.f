      program main
      implicit none
      real:: u = 15, ti = -0.4, rhi=80.0,p=1000.0, time=1800.0
      real Qtts,qttt, date, u10t
      real suma, sumb
      integer i
      open(1,file='forcing.dat')

      suma = 0.0
      sumb = 0.0

      do i=1,10000
      read(1,75) date,u,U10t,Ti,RHi,P
      call piektukd(u,ti,rhi,p,time,qtts,qttt)
      suma = suma+qtts
      sumb = sumb+qttt
      !print*, i, qtts,qttt
      end do
      print*, suma,sumb

   75  format(f8.4,2f6.2,3f10.4)
      end 
      
      
      SUBROUTINE PIEKTUKD(U10, Ti, RHi, P, time, QTTs, QTTt)
      implicit none
      integer, parameter::ni=64,nk=24
          
      REAL Ti    
      REAL RHi
      REAL Tk  
      
      REAL QTTs
      REAL QTTt
      
      REAL zlb
      REAL zub
      REAL z0
      REAL zeta
      REAL zetam
      REAL time
      REAL zetalb
      REAL zetaub
      REAL dzeta
      REAL alpha
      REAL ar
      REAL deltar
      REAL rhow
      REAL cp
      REAL D
      REAL dice
      REAL g
      REAL pi
      REAL Rd
      REAL Rv
      REAL t
      REAL T0
      REAL visc
      REAL zi
      REAL Qt
      REAL Qs
      REAL QTs
      REAL QTt
      REAL U10t
      REAL qstar
      REAL rho
      REAL ustar
      REAL qbsalt
      REAL usthr
      REAL zr
      REAL zsalt
      REAL Qsalt
      REAL beta
      REAL rhop
      REAL usalt
      REAL ri
      REAL fi
      REAL dz
      REAL add
      REAL sum
      REAL tot
      REAL vot
      REAL weigh
      REAL Fr
      REAL ei
      REAL Fk
      REAL Fd
      REAL Re
      REAL xi
      REAL ueff
      REAL Qext
      REAL vis

      INTEGER k
      INTEGER i
      
      real cb(0:nk),cd(0:nk),cl(0:nk),cr(0:nk),dzedz(nk),dzedzm(nk)
      real E(nk),F(ni),kappa,Km(nk),Kt,l,lmax,Ls,m,Ns(nk),Nu,Q(nk)
      real qb(0:nk),qis(nk),rm(nk),s(nk),Sb(0:nk),u(nk),vt(ni),w(nk)
      real z(0:nk),zm(nk),dt,P,qv(0:nk),Ta(0:nk),U10,N(0:nk),dN(nk)
      real rn(nk)
      real cbt(0:nk),cdt(0:nk),clt(0:nk),crt(0:nk),m2,ww(nk)
      real cbq(0:nk),cdq(0:nk),clq(0:nk),crq(0:nk)
      real cbn(0:nk),cdn(0:nk),cln(0:nk),crn(0:nk)
      
      data alpha,ar,deltar,dt,rhow/2.0,1.0e-4,4.0e-6,5.0,1000.0/
      data cp,D,dice,g,kappa,Kt/1004.6,2.25e-5,900.0,9.8,0.40,2.4e-2/
      data lmax,Ls,pi,Rd,Rv/40.0,2.835e6,3.1415926,287.0,461.5/
      data m,m2,t,T0,visc/4.1,1.1,0.0,273.16,1.53e-5/
      data zi/1.24/
      
      QTTs=0.0
      QTTt=0.0
      
      zlb=0.1
      zub=1000.0
      z0=0.001
      z(0)=z0
      zetalb=alog((zlb+z0)/z0)
      zetaub=alog((zub+z0)/z0)
      dzeta=(zetaub-zetalb)/(nk-1)
       
      do 5 k=1,nk
          zeta=(k-1)*dzeta+zetalb ! equidistant points on log scale
          zetam=zeta-0.5*dzeta
          z(k)=(exp(zeta)-1.0)*z0
          zm(k)=(exp(zetam)-1.0)*z0
          dzedz(k)=1.0/(z(k)+z0)
          dzedzm(k)=1.0/(zm(k)+z0)
          qb(k)=0.0
          Q(k)=0.0
          E(k)=0.0
          Sb(k)=0.0
          dN(k)=0.0
          N(k)=0.0
   5    continue
      
      
      Qt =0.0    ! transport rate (kg/m/s)
      Qs =0.0    ! sublimation rate (kg/m2/s or mm/h)
      QTs=0.0    ! cumulative value of sublimation rate (mm)
      QTt=0.0    ! cumulative value of transport rate (kg/m)
      
      !     Compute saltation layer parameters.
       
      U10t=9.43+0.18*Ti+0.0033*Ti**2! threshold 10-m wind speed (m/s)
      Tk = Ti + T0                  ! conversion from Celsius to Kelvin
      P = P*100.0                   ! conversion from hPa to Pa
      RHi = RHi/100.0               ! conversion from % to fraction
      Ta(0)=Tk
      do k=1,nk
          Ta(k)=Tk
          qis(k)=(3.80e2/p)*exp(21.87*(Ta(k)-T0)/(Ta(k)-7.66))
          qstar=kappa*qis(1)*(RHi-1.0)/alog((zi+z0)/z0)
          qv(k)=qis(1)+qstar/kappa*alog((z(k)+z0)/z0)
          if(z(k).gt.2.0) qv(k)=qis(k)*RHi
      enddo
          qv(0)=qis(1)
          rho=p/(Rd*Tk)                 ! constant atmospheric density (kg/m3)
          rhop=-8.64e7*rho/rhow         ! conversion factor from m/s to mm/d swe
        
      if((U10.gt.U10t).and.(Ti.lt.0.0)) then
          ustar=0.02264*U10**1.295      ! friction velocity (m/s)
          qbsalt=0.3846154*(1.0-(U10t/U10)**2.59)/ustar !saltation mixing ratio
          usthr=0.02264*U10t**1.295     ! threshold friction velocity (m/s)
          usalt=2.3*usthr               ! saltating particle velocity (m/s)
          zr=0.05628*ustar
          zsalt=(zr**(-0.544)+alog(qbsalt*rho/0.8)/1.55)**(-1.838)
          Qsalt=qbsalt*rho*usalt*(zsalt-z0)
          Qt=Qsalt
       
      !     Compute the lower boundary particle distribution.
      beta=ar/alpha
      N(0)=3.0*qbsalt*rho/(4.0*pi*dice*alpha*(alpha+1.)*(alpha+2.) 
     +        *beta**3)
      do 10 i=1,ni
          ri=((i-1)+0.5)*deltar
          vt(i)=(-12.0*visc+(144.0*visc**2+20.6336*ri**3*g*dice/rho)
     +        **0.5)/(3.8688*ri)
          fi=ri**(alpha-1)*exp(-ri/beta)/(beta**alpha)
          F(i)=N(0)*fi
   10 continue
      
      !     Loop from z=zlb to z=zub and initialise vertical profiles.
       
      do 30 k=1,nk
          l=(1.0/(kappa*(zm(k)+z0))+1.0/lmax)**(-1.0)
          Km(k)=ustar*l
          Ta(k)=Tk
          dz=z(k)-z(k-1)
          add=0.0
          sum=0.0
          tot=0.0
          vot=0.0
          weigh=0.0
          Q(k)=0.0
          E(k)=0.0
          Sb(k)=0.0
          dN(k)=0.0
          Ns(k)=0.0
          s(k)=0.0
          do 20 i=1,ni
              ri=((i-1)+0.5)*deltar
              Fr=F(i)*((z(k)+z0)/(zsalt+z0))**(-vt(i)*l/(kappa*Km(k)))
              Ns(k)=Ns(k)+Fr*deltar
              s(k)=s(k)+(4./3.)*pi*dice*ri**3*Fr*deltar/rho
              weigh=weigh+vt(i)*ri**m*Fr*deltar
              sum=sum+ri**m*Fr*deltar
              add=add+ri*Fr*deltar
              tot=tot+vt(i)*ri**m2*Fr*deltar
              vot=vot+ri**m2*Fr*deltar
   20    continue
          w(k)=weigh/sum
          rn(k)=add/Ns(k)
          ww(k)=tot/vot
   30 continue
       
      Ta(0)=Tk
      qv(0)=qis(1)
      qb(1)=s(1)
      qb(0)=qbsalt
      N(1)=Ns(1)
       
      !     Integrate forward in time.
       
      do 60 t=dt,time,dt
       
      !     Calculate coefficients for the interior points of the matrix.
      
      do 40 k=1,nk-1
          clt(k)= dzedz(k)*Km(k)*dzedzm(k)/dzeta**2
          cdt(k)=-dzedz(k)*(Km(k+1)*dzedzm(k+1)+Km(k)*dzedzm(k))
     +        /dzeta**2-1.0/dt
          crt(k)= dzedz(k)*Km(k+1)*dzedzm(k+1)/dzeta**2
          cbt(k)=-(Ta(k)/dt+Q(k))
      
          clq(k)= clt(k)
          cdq(k)= cdt(k)
          crq(k)= crt(k)
          cbq(k)=-(qv(k)/dt+E(k))
                  
          cl(k)= dzedz(k)*(-0.5*w(k)/dzeta)+clt(k)
          cd(k)= cdt(k)
          cr(k)= dzedz(k)*(0.5*w(k)/dzeta)+crt(k)
          cb(k)=-(qb(k)/dt+Sb(k))
      
          cln(k)=dzedz(k)*(-0.5*ww(k)/dzeta+Km(k)*dzedzm(k)/dzeta**2)
          cdn(k)=-dzedz(k)*(Km(k+1)*dzedzm(k+1)+Km(k)*dzedzm(k))
     +        /dzeta**2-1.0/dt
          crn(k)=dzedz(k)*(0.5*ww(k)/dzeta+Km(k+1)*dzedzm(k+1)/dzeta**2)
          cbn(k)=-(N(k)/dt+dN(k))
   40      continue
       
      !     Lower ice mixing ratio boundary condition.
      
          cl(1)=0.0
          cd(1)=1.0
          cr(1)=0.0
          cb(1)=qb(1)
          cl(0)=0.0
          cd(0)=1.0
          cr(0)=0.0
          cb(0)=qbsalt
       
      !     Upper ice mixing ratio boundary condition.
          cl(nk)= 1.0
          cd(nk)=-1.0
          cr(nk)= 0.0
          cb(nk)= 0.0
          CALL TRID(qb,cl,cd,cr,cb,nk+1)

       
      !     Lower particle number boundary condition.
          cln(1)=0.0
          cdn(1)=1.0
          crn(1)=0.0
          cbn(1)=N(1)
          cln(0)=0.0
          cdn(0)=1.0
          crn(0)=0.0
          cbn(0)=N(0)
      
      !     Upper ice mixing ratio boundary condition.
          cln(nk)= 1.0
          cdn(nk)=-1.0
          crn(nk)= 0.0
          cbn(nk)= 0.0
      
          CALL TRID(N,cln,cdn,crn,cbn,nk+1)
      
      !     Lower temperature boundary condition.
          clt(0)= 0.0
          cdt(0)= 1.0
          crt(0)=-1.0
          cbt(0)= 0.0
       
          clt(1)= 0.0
          cdt(1)= 1.0
          crt(1)=-1.0
          cbt(1)= 0.0
      
      !     Upper temperature boundary condition.
          clt(nk)= 1.0
          cdt(nk)=-1.0
          crt(nk)= 0.0
          cbt(nk)= 0.0
       
          CALL TRID(Ta,clt,cdt,crt,cbt,nk+1)
       
      !     Lower mixing ratio boundary condition.
          clq(0)=0.0
          cdq(0)=1.0
          crq(0)=0.0
          cbq(0)=(3.80e2/p)*exp(21.87*(Ta(0)-T0)/(Ta(0)-7.66))
       
          clq(1)=0.0
          cdq(1)=1.0
          crq(1)=0.0
          cbq(1)=(3.80e2/p)*exp(21.87*(Ta(1)-T0)/(Ta(1)-7.66))
      
      !     Upper mixing ratio boundary condition.
          clq(nk)= 1.0
          cdq(nk)=-1.0
          crq(nk)= 0.0
          cbq(nk)= 0.0
       
          CALL TRID(qv,clq,cdq,crq,cbq,nk+1)
      
          Qs=0.0
          Qt=Qsalt
       
      !     Compute sublimation in suspension layer.
       
          do 50 k=1,nk
              if((N(k).gt.0.0).and.(qb(k).gt.0.0)) then
              rm(k)=(rho*qb(k)/(4.*pi*dice*N(k)))**(1./3.)
              dz=z(k)-z(k-1)
              qis(k)=(3.80e2/p)*exp(21.87*(Ta(k)-T0)/(Ta(k)-7.66))
              if(qv(k).gt.qis(k)) qv(k)=qis(k)
                  ei=1.608421*qis(k)*p
                  Fk=(Ls/(Rv*Ta(k))-1.0)*Ls/(Kt*Ta(k))
                  Fd=Rv*Ta(k)/(ei*D)
                  Re=2.0*rm(k)*w(k)/visc
                  Nu=1.79+0.606*Re**0.5
                  xi=(qv(k)/qis(k)-1.)/(2.0*dice*(Fk+Fd))
                  Sb(k)=max(qb(k)*Nu*xi/rm(k)**2,-qb(k)/dt)
                  if(Sb(k).gt.0.0) Sb(k)=0.0
                  dN(k)=max(Sb(k)*N(k)/qb(k),-N(k)/dt)
                  E(k)=-Sb(k)
                  Q(k)=Sb(k)*Ls/cp
                  Qs=Qs+0.5*rhop*(Sb(k)+Sb(k-1))*dz
                  ueff=ustar*(1.0/(1.0+qb(k)))**0.5
                  u(k)=ueff/kappa*alog((z(k)+z0)/z0)
                  if(k.eq.1) then
                    Qt=Qt+0.5*(qb(k)+qbsalt)*rho*u(k)*(z(1)-zsalt)
                  else
                    Qt=Qt+0.5*(qb(k)+qb(k-1))*rho*u(k)*dz
                  endif
              else
                  N(k)=0.0
                  dN(k)=0.0
                  Sb(k)=0.0
                  E(k)=0.0
                  Q(k)=0.0
              endif
   50    continue
      
          QTs=QTs+Qs/8.64e4*dt
          QTt=QTt+Qt*dt
   60  continue
      
      !     Compute visibility at level 9 (z = 2.5 m) following 
      !     Pomeroy and Male (1988) valid at end of timestep.
      
          beta=rm(9)/alpha
          Qext=1.82*rm(9)**(-0.011)
          vis=min(3.912/(6.0*pi*Qext*beta**2*N(9)),25000.0)
          QTTs=QTTs+QTs
          QTTt=QTTt+QTt
      else
          do k=1,nk
              qb(k)=0.0
              N(k)=0.0
              rm(k)=0.0
          enddo
          vis=25000.0  ! maximum visibility = 25 km.
      endif
      
      ! QTTs, mm, total sublimation
      ! QTTt, kg/m, total mass transport
      print*, QTt/1800.0
      
      end subroutine
      
      SUBROUTINE TRID(X,DD,D,RD,B,N)
      IMPLICIT NONE
      INTEGER I, J, N
      real X(N),DD(N),D(N),RD(N),B(N),RSF
      DO 15 I=2,N
          J=N+1-I
          RSF=RD(J)/D(J+1)
          D(J)=D(J)-DD(J+1)*RSF
          B(J)=B(J)- B(J+1)*RSF
   15    continue
          X(1)=B(1)/D(1)
      DO 25 J=2,N
          X(J)=(B(J)-DD(J)*X(J-1))/D(J)
   25    continue
      RETURN
      END subroutine
