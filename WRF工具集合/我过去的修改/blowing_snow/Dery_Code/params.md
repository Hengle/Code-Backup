| 变量名 | 含义                                                         |
| ------ | ------------------------------------------------------------ |
| BSMASK | switch to activate PIEKTUK at one grid point (1=YES, 0=NO)   |
| DT     | timestep for the MC2 integration (s)                         |
| NROW   |                                                              |
| KOUNT  | MC2 timestep                                                 |
| PS     | surface pressure from MC2 (Pa)                               |
| QV0    | specific humidity from MC2 (kg/kg)                           |
| TA0    | air temperature from MC2 (K)                                 |
| UU     | zonal wind for MC2 levels (m/s)                              |
| VV     | meridional wind for MC2 levels (m/s)                         |
| RL     | roughness length from MC2 (m)                                |
| QG     | blowing snow mixing ratio at MC2 levels (kg/kg)              |
| QB0    | blowing snow mixing ratio at PIEKTUK levels (kg/kg)          |
| QN     | particle number concentration at MC2 levels (/m3)            |
| QN0    | particle number concentration at PIEKTUK levels (/m3)        |
| QTs    | cumulative sublimation rate of blowing snow (m swe)          |
| QTx    | cumulative transport rate in x-direction (kg/m)              |
| QTy    | cumulative transport rate in y-direction (kg/m)              |
| WC     |                                                              |
| DQD    | cumulative change in moisture due to diffusion (z=18 m)      |
| RI     | surface Richardson                                           |
| DQV    | water vapour tendency due to blowing snow sublimation/diffusion (/s) |
| DTA    | temperature tendency due to blowing snow sublimation/diffusion (K/s) |
| UL     | zonal wind for PIEKTUK levels (m/s)                          |
| VL     | meridional wind for PIEKTUK levels (m/s)                     |
| TS     | surface temperature from MC2 (K)                             |
| DTS    | cumulative change in temperature due to sublimation (z=18 m) |
| DQS    | cumulative change in moisture due to sublimation (z=18 m)    |
| DTD    | cumulative change in temperature due to diffusion (z=18 m)   |
| SIGMA  | MC2 sigma levels                                             |
| H0     | topography (m)                                               |

| 内部变量 | 含义                                                         |
| -------- | ------------------------------------------------------------ |
| i        | index for particle sizes (24 bins in PIEKTUK)                |
| j        | index for location of the vertical slab (MC2)                |
| k        | index for vertical coordinate (24 levels in PIEKTUK, 45 in MC2) |
| t        | index for time (PIEKTUK)                                     |
|          |                                                              |
|          |                                                              |
|          |                                                              |
|          |                                                              |
|          |                                                              |

