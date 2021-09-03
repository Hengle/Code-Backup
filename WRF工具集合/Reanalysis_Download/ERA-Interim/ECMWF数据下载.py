#!/usr/bin/env python26
from ecmwfapi import ECMWFDataServer
import os

def leap_year(year):
  if (year%400==0):
    x=1
  elif (year%4==0):
    x=1
  else:
    x=0
  return x

server = ECMWFDataServer()

variables=['Geopotential','Relative humidity','Specific humidity','U WIND COMPONENT','V WIND COMPONENT']
out_name=['GEO','RH','SH','U','V']
mon_name=['01','02','03','04','05','06','07','08','09','10','11','12']
ord_mon=['31','28','31','30','31','30','31','31','30','31','30','31']
leap_mon=['31','29','31','30','31','30','31','31','30','31','30','31']

for i,varname in enumerate(variables):
  mkdir='mkdir '+out_name[i]
  os.system(mkdir)
  for year in range(1979,2014):
    for mon in range(1,13):
      leap=leap_year(year)
      if (leap==1):
        time=str(year)+mon_name[mon-1]+"01"+"/to/"+str(year)+mon_name[mon-1]+leap_mon[mon-1]
        print time
      else:
	      time=str(year)+mon_name[mon-1]+"01"+"/to/"+str(year)+mon_name[mon-1]+ord_mon[mon-1]
	      print time
      target_name="./"+out_name[i]+"/"+out_name[i]+str(year)+mon_name[mon-1]+".nc"
      print target_name
      server.retrieve({
        'dataset' : "interim",
        'levelist' : "ALL",
        'date'    : time,
        'time'    : "ALL",
        'type'    : "an",
        'param'   : varname,
        'grid'    : "0.75/0.75",
        'target'  : target_name,
        'format'  : "netcdf"
         })


