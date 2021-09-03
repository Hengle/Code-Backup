      SUBROUTINE PIEKTUKD(BSMASK,DT,NROW,KOUNT,PS,QV0,TA0,
     +UU,VV,RL,QG,QB0,QN,QN0,QTs,QTx,QTy,WC,DQD,RI,DQV,
     +DTA,UL,VL,TS,DTS,DQS,DTD,SIGMA,H0)
*     Last modified 1 Nov. 2000 by Stephen Dery
      PARAMETER(NJ=99,NZ=45)
      integer NROW,BSMASK(NJ),KOUNT
      real DT,PS(NJ),QB0(NJ,NZ),QG(NJ,NZ),QN0(NJ,NZ),QTS(NJ),
     +QTx(NJ),QTy(NJ),QV0(NJ,NZ),RL(NJ),TA0(NJ,NZ),UU(NJ,NZ),
     +VV(NJ,NZ),DQV(NJ,NZ),DTA(NJ,NZ),RI(NJ),WC(NJ),
     +QN(NJ,NZ),UL(NJ,NZ),VL(NJ,NZ),TS(NJ),DTS(NJ),DTD(NJ),
     +SIGMA(NJ,NZ),DQS(NJ),DQD(NJ),H0(NJ)
*
*Authors
*       S.J. Dery, M.K. Yau (McGill University)  August 1998
*
*Revisions
* 001   S.J. Dery, P.A. Taylor, J. Xiao (Jun 1996)  Development of
*       the original spectral PIEKTUK model (Ref:  BLM, 1998)
* 002   S.J. Dery and M. K. Yau (Aug 1998) Development of PIEKTUKB
*       with the bulk parametrization of blowing snow (Ref:  BLM, 1999)
* 003   S.J. Dery (Sep 1998) Adaptation to MC2 as a subroutine.
* 004   S.J. Dery (May 1999) Modify b.c.'s and sublimation computation
* 005   S.J. Dery (Nov 1999) Extension to double-moment scheme (Ref: BLM, 2001)
* 006   S.J. Dery (May 2000) Directional wind & wind transport
* 007   S.J. Dery (Jun 2000) Modifications to MC2 code (search for
*                            "ADVECT", "SNOW" & "STEPH")
* 008   S.J. Dery (Aug 2000) Semi-Lagrangian advection of blowing snow by MC2.
* 009   S.J. Dery (Oct 2000) Apply diffusion for heat & moisture perturbations.
* 010   S.J. Dery (Nov 2000) Variable # of MC2 vertical levels.
*
*Object
*       To compute the blowing snow sublimation heat/moisture tendencies
*       & the vertically-integrated transport/sublimation rates.
*       Also outputs the blowing snow mixing ratio & particle numbers for
*       initialization at the following timestep.
*
*Comments
*       1) PIEKTUK is active only when the blowing snow criteria are met
*          at a grid point (Ref:  S. J. Dery and M. K. Yau, JGR, 1999).
*       2) Generally, capitalized variables are input/output from/to MC2,
*          with the remainder local to PIEKTUK.
*       3) The vertical index (k) is reversed from the MC2, thus here k=1
*          is near the surface and k=nk is in the upper atmosphere.
*       4) Note:  The i and j indices are also not same as those in MC2.
*       5) This subroutine calls "TRID" which solves a 3-D matrix.
*
*Arguments
*
*       -Input-
* BSMASK switch to activate PIEKTUK at one grid point (1=YES, 0=NO)
* DT    timestep for the MC2 integration (s)
* H0    topography (m)
* KOUNT MC2 timestep #
* PS    surface pressure from MC2 (Pa)
* QV0   specific humidity from MC2 (kg/kg)
* RL    roughness length from MC2 (m)
* SIGMA MC2 sigma levels
* TA0   air temperature from MC2 (K)
* TS    surface temperature from MC2 (K)
* UU    zonal wind for MC2 levels (m/s)
* VV    meridional wind for MC2 levels (m/s)
*
*       -Input/Output-
* DQD   cumulative change in moisture due to diffusion (z=18 m)
* DQS   cumulative change in moisture due to sublimation (z=18 m)
* DTD   cumulative change in temperature due to diffusion (z=18 m)
* DTS   cumulative change in temperature due to sublimation (z=18 m)
* QB0   blowing snow mixing ratio at PIEKTUK levels (kg/kg)
* QG    blowing snow mixing ratio at MC2 levels (kg/kg)
* QN0   particle number concentration at PIEKTUK levels (/m3)
* QN    particle number concentration at MC2 levels (/m3)
* QTs   cumulative sublimation rate of blowing snow (m swe)
* QTx   cumulative transport rate in x-direction (kg/m)
* QTy   cumulative transport rate in y-direction (kg/m)
*
*       -Output-
* DQV   water vapour tendency due to blowing snow sublimation/diffusion (/s)
* DTA   temperature tendency due to blowing snow sublimation/diffusion (K/s)
* RI    surface Richardson #
* UL    zonal wind for PIEKTUK levels (m/s)
* VL    meridional wind for PIEKTUK levels (m/s)
*
*       -Indices-
* i     index for particle sizes (24 bins in PIEKTUK)
* j     index for location of the vertical slab (MC2)
* k     index for vertical coordinate (24 levels in PIEKTUK, 45 in MC2)
* t     index for time (PIEKTUK)
*
*       Local variables used by the subroutine
 
      parameter(ni=24,nk=24)
      real cb(nk),cd(nk),cl(nk),cr(nk),dzedz(nk),ww(nk),Sn(nk),
     +dzedzm(nk),F(ni),kappa,Kt,l,lmax,Ls,st(nk),n2,n5,
     +N(nk),Nt(nk),Nu,qb(nk),qis(nk),qv(nk),rho,rm(nk),Sb(nk),
     +Ta(nk),vt(ni),w(nk),z(0:nk),zm(nk),dz(nk),theta
      real chi,dzeta,Nsalt,Rd,uv,ux,uy,U10(nj),U10t,y,zeta,zetalb,
     +zetam,zetaub,dtau,thermo,qsz(nk),u(nk),v(nk),p(nk),
     +Kh(nk),rhoz(nk),Ke(nk),r,Kb(nk),qp(nk),Tp(nk),H
      real cbt(nk),cdt(nk),clt(nk),crt(nk)
      real cbq(nk),cdq(nk),clq(nk),crq(nk)
      real cbn(nk),cdn(nk),cln(nk),crn(nk)
 
*     Initialize constants and variables.
 
      data alpha,ar,deltar,dtau,n2/2.0,1.0e-4,16.0e-6,5.0,1.0/
      data cp,D,dice,g,kappa,Kt/1004.6,2.25e-5,900.0,9.8,0.40,2.4e-2/
      data lmax,Ls,pi,Rd,Rv/40.0,2.835e6,3.1415926,287.0,461.5/
      data n5,rhow,T0,visc,z10/4.1,1000.0,273.16,1.53e-5,10.0/
      data thermo,H/18.23348,18500.0/
      nw=35
      nx=nk/2
      ny=NZ+nx+2
 
*     Assign lower (zlb) and upper (zub) boundaries of suspension layer.
 
      zlb=0.1
      zub=1000.0
      zetalb=alog(zlb)
      zetaub=alog(zub)
      dzeta=(zetaub-zetalb)/float(nk-1)
      z(0)=0.0
 
      do k=1,nk
         zeta=(float(k)-1.)*dzeta+zetalb
         zetam=zeta-0.5*dzeta
         z(k)=exp(zeta)
         zm(k)=exp(zetam)
         dzedz(k)=1.0/z(k)
         dzedzm(k)=1.0/zm(k)
         dz(k)=z(k)-z(k-1)
      enddo
 
      do 140 j=1,nj
 
         dHdz=H/(H-H0(j))
         uv=(UU(j,NZ)**2+VV(j,NZ)**2)**0.5
         U10(j)=uv*alog(z10/RL(j))/(alog(thermo/RL(j)))
         if((z10.lt.RL(j)).or.(U10(j).lt.0.0)) U10(j)=0.0
         z0=RL(j)
         ustar=U10(j)*kappa/alog(z10/z0)
         ux=UU(j,NZ)/uv
         uy=VV(j,NZ)/uv
         do k=1,nx+1
            UL(j,k)=ustar*ux/kappa*(alog(z(k)/z0))
            VL(j,k)=ustar*uy/kappa*(alog(z(k)/z0))
         enddo
         do k=nx+2,nk
            UL(j,k)=UU(j,ny-k)
            VL(j,k)=VV(j,ny-k)
         enddo
         do k=nk+1,NZ
            UL(j,k)=0.0
            VL(j,k)=0.0
         enddo
 
*     Compute the surface layer Richardson #.

         theta=TA0(j,37)*(SIGMA(j,37))**(-0.286)
         Ri(j)=g*(theta-TS(j))*(z(22)-RL(j))/(T0*
     +        (UL(j,22))**2+(VL(j,22)**2))

         U10t=206.5-1.623*TS(j)+0.0033*TS(j)**2
 
         if((BSMASK(j).eq.1).and.(U10(j).gt.U10t+0.1).and. 
     +   (RL(j).lt.z10))then
 
         BSMASK(j)=1
         rho=PS(j)/(Rd*TA0(j,NZ))
         chi=4.*pi*dice/(3.*rho)
         z0=RL(j)
         z(0)=z0
         qbsalt=0.3846154*(1.0-(U10t/U10(j))**2.59)/ustar
         zr=0.05628*ustar
         zsalt=(zr**(-0.544)+alog(qbsalt*rho/0.8)/1.55)**(-1.838)
         if(zsalt.lt.z(0)) zsalt=z(0)
         usthr=0.02264*U10t**1.295
         uxsalt=2.3*usthr*ux
         uysalt=2.3*usthr*uy
         Qxsalt=qbsalt*rho*uxsalt*(zsalt-z0)
         Qysalt=qbsalt*rho*uysalt*(zsalt-z0)
 
*     Compute the lower boundary particle distribution.
 
         beta=ar/alpha
         Nsalt=qbsalt/(chi*alpha*(alpha+1.)*(alpha+2.)*beta**3)
         do 10 i=1,ni
            r=(float(i-1)+0.5)*deltar
            vt(i)=(-12.0*visc+(144.0*visc**2+20.6336*r**3*g*dice/rho)
     +      **0.5)/(3.8688*r)
            F(i)=Nsalt*r**(alpha-1.)*exp(-r/beta)/(beta**alpha)
   10    continue
 
*     Assign initial thermodynamic profiles for PIEKTUK model heights.
 
*     Start with the lower boundary conditions.
 
         qice=(3.80e2/PS(j))*exp(21.87*(TA0(j,NZ)-T0)/(TA0(j,NZ) -7.66))
 
         RHi=QV0(j,NZ)/qice
         qstar=kappa*qice*(RHi-1.0)/alog(thermo/zlb)
         tstar=kappa*(TA0(j,NZ)-TS(j))/alog(thermo/zlb)
         qv(1)=qice
         Ta(1)=TS(j)
         P(1)=PS(j)
         rhoz(1)=rho
 
*     Then do levels that are below MC2 levels.
 
         do 20 k=2,nx+1
            qb(k)=max(QB0(j,k),0.0)
            N(k) =max(QN0(j,k),0.0)
            qv(k)=qice +qstar/kappa*alog(z(k)/zlb)
            Ta(k)=TS(j)+tstar/kappa*alog(z(k)/zlb)
            P(k)=PS(j)*exp(-z(k)*g/(Rd*TS(j)))
            rhoz(k)=P(k)/(Rd*Ta(k))
   20    continue
 
*     Now do PIEKTUK levels that match those of the MC2.
 
         do 30 k=nx+2,nk
            qb(k)=max(QG(j,ny-k),0.0)
            N(k)=max(QN(j,k-13),0.0)
            Ta(k)=TA0(j,ny-k)
            qv(k)=QV0(j,ny-k)
            P(k)=PS(j)*SIGMA(j,ny-k)
            rhoz(k)=P(k)/(Rd*Ta(k))
   30    continue

*     Loop from z=zlb to z=zub and initialise vertical profiles.
 
         do 60 k=1,nk
            Ttp=0.0
            Tp(k)=0.0
            Tqp=0.0
            qp(k)=0.0
            u(k)=UL(j,k)
            v(k)=VL(j,k)
            l=(1.0/(kappa*zm(k))+1.0/lmax)**(-1.0)
            Kb(k)=ustar*l
            Ke(k)=ustar*l
            Kh(k)=ustar*l
            Sb(k)=0.0
            Sn(k)=0.0
            sum=0.0
            weigh=0.0
            qsz(k)=0.0
            Nt(k)=0.0
            st(k)=0.0
            ww(k)=0.0
            w(k)=0.0
            tot=0.0
            vot=0.0
            do 50 i=1,ni
              r=(float(i-1)+0.5)*deltar
              y=max(-vt(i)*l/(kappa*Kb(k)),-10.0)
              Fr=F(i)*(z(k)/zsalt)**y
              Nt(k)=Nt(k)+Fr*deltar
              st(k)=st(k)+chi*r**3*Fr*deltar
              weigh=weigh+vt(i)*r**n5*Fr*deltar
              sum=sum+r**n5*Fr*deltar
              tot=tot+vt(i)*r**n2*Fr*deltar
              vot=vot+r**n2*Fr*deltar
   50       continue
            w(k)=weigh/sum
            ww(k)=tot/vot
   60    continue
 
         qb(1)=st(1)
         N(1)=Nt(1)
 
*     Loop over time and compute diffusion & sublimation.
*
         do 100 t=dtau,DT,dtau
 
*     Lower ice mixing ratio boundary condition.
            cl(1)=0.0
            cd(1)=1.0
            cr(1)=0.0
            cb(1)=qb(1)
 
*     Upper ice mixing ratio boundary condition.
            cl(nk)= 1.0
            cd(nk)=-1.0
            cr(nk)= 0.0
            cb(nk)= 0.0
 
*     Lower particle number boundary condition.
            cln(1)=0.0
            cdn(1)=1.0
            crn(1)=0.0
            cbn(1)=N(1)
 
*     Upper particle number boundary condition.
            cln(nk)= 1.0
            cdn(nk)=-1.0
            crn(nk)= 0.0
            cbn(nk)= 0.0
 
*     Lower temperature boundary condition.
            clt(1)= 0.0
            cdt(1)= 1.0
            crt(1)=-1.0
            cbt(1)= 0.0
 
*     Upper temperature boundary condition.
            clt(nk)= 0.0
            cdt(nk)= 1.0
            crt(nk)= 0.0
            cbt(nk)= 0.0
 
*     Lower mixing ratio boundary condition.
            clq(1)= 0.0
            cdq(1)= 1.0
            crq(1)=-1.0
            cbq(1)= 0.0
 
*     Upper mixing ratio boundary condition.
            clq(nk)= 0.0
            cdq(nk)= 1.0
            crq(nk)= 0.0
            cbq(nk)= 0.0
 
*     Calculate ice mixing ratio coefficients for the interior points.
 
            do 70 k=2,nk-1
               clt(k)= dzedz(k)*Kh(k)*dzedzm(k)/dzeta**2
               cdt(k)=-dzedz(k)*(Kh(k+1)*dzedzm(k+1)+Kh(k)*dzedzm(k))
     +         /dzeta**2-1.0/dtau
               crt(k)= dzedz(k)*Kh(k+1)*dzedzm(k+1)/dzeta**2
               cbt(k)=-(Tp(k)/dtau+Sb(k)*Ls/cp)
 
               clq(k)= dzedz(k)*Ke(k)*dzedzm(k)/dzeta**2
               cdq(k)=-dzedz(k)*(Ke(k+1)*dzedzm(k+1)+Ke(k)*dzedzm(k))
     +         /dzeta**2-1.0/dtau
               crq(k)= dzedz(k)*Ke(k+1)*dzedzm(k+1)/dzeta**2
               cbq(k)=-(qp(k)/dtau-Sb(k))
 
               cl(k)=dzedz(k)*Kb(k)*dzedzm(k)/dzeta**2
     +         +dzedz(k)*(-0.5*w(k)/dzeta)
               cd(k)=-dzedz(k)*(Kb(k+1)*dzedzm(k+1)+Kb(k)*dzedzm(k))
     +         /dzeta**2-1.0/dtau
               cr(k)= dzedz(k)*Kb(k+1)*dzedzm(k+1)/dzeta**2
     +         +dzedz(k)*(0.5*w(k)/dzeta)
               cb(k)=-(qb(k)/dtau+Sb(k))
 
               cln(k)=dzedz(k)*Kb(k)*dzedzm(k)/dzeta**2
     +         +dzedz(k)*(-0.5*ww(k)/dzeta)
               cdn(k)=-dzedz(k)*(Kb(k+1)*dzedzm(k+1)+Kb(k)*dzedzm(k))
     +         /dzeta**2-1.0/dtau
               crn(k)=dzedz(k)*Kb(k+1)*dzedzm(k+1)/dzeta**2
     +         +dzedz(k)*(0.5*ww(k)/dzeta)
               cbn(k)=-(N(k)/dtau+Sn(k))
 
   70       continue
 
            CALL TRID(qb,cl,cd,cr,cb,nk)
 
            CALL TRID(N,cln,cdn,crn,cbn,nk)
 
            CALL TRID(Tp,clt,cdt,crt,cbt,nk)
 
            CALL TRID(qp,clq,cdq,crq,cbq,nk)
 
   80       continue
 
            Ta(1)=Ta(1)+Tp(1)
            qv(1)=(3.8e2/P(1))*exp(21.87*(Ta(1)-T0)/(Ta(1)-7.66))
            Tp(1)=0.0
            qp(1)=0.0
            Tqp=Tqp+qp(nx+2)
            Ttp=Ttp+Tp(nx+2)

            Qs=0.0
            Qx=Qxsalt+0.5*(qb(1)+qbsalt)*rho*u(1)*(z(1)-zsalt)
            Qy=Qysalt+0.5*(qb(1)+qbsalt)*rho*v(1)*(z(1)-zsalt)
            do 90 k=2,nk
               qv(k)=qv(k)+qp(k)
               Ta(k)=Ta(k)+Tp(k)
               qp(k)=0.0
               Tp(k)=0.0
               if((N(k).gt.0.0).and.(qb(k).gt.0.0)) then
                  rm(k)=(rhoz(k)*qb(k)/(4.0*pi*dice*N(k)))**(1./3.)
                  qis(k)=(3.8e2/P(k))*exp(21.87*(Ta(k)-T0)/ (Ta(k)
     +            -7.66))
                  qv(k)=min(qis(k),qv(k))
                  ei=1.608421*qis(k)*P(k)
                  Fk=(Ls/(Rv*Ta(k))-1.0)*Ls/(Kt*Ta(k))
                  Fd=Rv*Ta(k)/(ei*D)
                  Re=2.0*rm(k)*w(k)/visc
                  Nu=1.79+0.606*Re**0.5
                  xi=(qv(k)/qis(k)-1.)/(2.0*dice*(Fk+Fd))
                  Sb(k)=max(qb(k)*Nu*xi/rm(k)**2,-qb(k)/dtau)
                  Sn(k)=max(Sb(k)*N(k)/qb(k),-N(k)/dtau)
                  Qs=Qs-0.5*rhoz(k)/rhow*(Sb(k)+Sb(k-1))*dz(k)
                  Qx=Qx+0.5*rhoz(k)*u(k)*(qb(k)+qb(k-1))*dz(k)
                  Qy=Qy+0.5*rhoz(k)*v(k)*(qb(k)+qb(k-1))*dz(k)
                  qsz(k)=qsz(k)+Sb(k)*dtau
               else
                  qb(k)=0.0
                  N(k)=0.0
                  Sn(k)=0.0
                  Sb(k)=0.0
               endif
   90       continue
            QTs(j)=QTs(j)+Qs*dtau
            QTx(j)=QTx(j)+Qx*dtau
            QTy(j)=QTy(j)+Qy*dtau
  100    continue
 
         do 105 k=1,nw
           DQV(j,k)=0.0 
           DTA(j,k)=0.0
           QG(j,k)=0.0
  105    continue

         do 110 k=1,nx+1
            QB0(j,k)=max(qb(k),0.0)
            QN0(j,k)=max(N(k),0.0)
            QN(j,nk+1-k)=0.0
  110    continue
 
         do 120 k=nx+2,nk
           DQV(j,ny-k)=(qv(k)-QV0(j,ny-k))/DT
           DTA(j,ny-k)=(Ta(k)-TA0(j,ny-k))/DT
           QB0(j,k)=max(qb(k),0.0)
           QG(j,ny-k)=max(qb(k),0.0)
           QN0(j,k)=max(N(k),0.0)
           QN(j,k-13)=max(N(k),0.0)
  120    continue
         DTS(j)=DTS(j)+qsz(nx+2)*Ls/cp
         DTD(j)=DTD(j)+Ttp-qsz(nx+2)*Ls/cp
         DQS(j)=DQS(j)-qsz(nx+2)
         DQD(j)=DQD(j)+Tqp-qsz(nx+2)
      else
         do 130 k=1,NZ
            DQV(j,k)=0.0
            DTA(j,k)=0.0
            QB0(j,k)=0.0
            QG(j,k)=0.0
            QN0(j,k)=0.0
            QN(j,k)=0.0
  130    continue
      endif
  140 continue
  150 return
      end
