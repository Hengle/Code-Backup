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

variables='Volumetric soil water layer 2'
out_name='SQ2'
mon_name=['01','02','03','04','05','06','07','08','09','10','11','12']
ord_mon=['31','28','31','30','31','30','31','31','30','31','30','31']
leap_mon=['31','29','31','30','31','30','31','31','30','31','30','31']

for year in range(2014,2015):
  for mon in range(1,6):
   # if (year<2008 and mon<10):
    #  continue
    leap=leap_year(year)
    if (leap==1):
      time=str(year)+mon_name[mon-1]+"01"+"/to/"+str(year)+mon_name[mon-1]+leap_mon[mon-1]
      print time
    else:
      time=str(year)+mon_name[mon-1]+"01"+"/to/"+str(year)+mon_name[mon-1]+ord_mon[mon-1]
      print time
    target_name="./"+"SQ2"+"/"+"SQ2"+str(year)+mon_name[mon-1]+".grib"
    print target_name
    server.retrieve({
      'dataset' : "interim",
      'levtype' : "sfc",
      'date'    : time,
      'time'    : "ALL",
      'type'    : "an",
      'param'   : "Volumetric soil water layer 2",
      'grid'    : "0.75/0.75",
      'target'  : target_name,
      'format'  : "grib",
       })


