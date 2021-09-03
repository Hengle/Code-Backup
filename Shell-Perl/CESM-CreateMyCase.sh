#!/bin/sh

ROOT=`pwd`
CESM_ROOT=/THL6/home/renguang/CESM/cesm1_1_1

# what is your case name?
case="snow"

# which compset? FC5 is only cam5
compset="FC5"

# what resolution? usually I use f19_g16
res="f19_g16"

# which machine? In Tianhe, the account is Prof.Wu, thus, mach is wu
# This param can be changed if necessary
mach="wu"

# create a new case
$CESM_ROOT/scripts/create_newcase -case $case -res $res -compset $compset -mach $mach

# build the model and modify the output dirctory
cd $case
./xmlchange -file env_build.xml -id EXEROOT -val "$ROOT/$case/output"
./xmlchange -file env_run.xml -id RUNDIR -val "$ROOT/$case/output"
cd ..
