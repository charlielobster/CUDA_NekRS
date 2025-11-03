#!/bin/bash

if [ $# -ne 1 ]; then
    echo "nek_clean <path> - remove object files associated with nek build"
fi

cd $1
rm -rf .cache
rm -rf obj
rm *.f*
rm *.nek5000
rm *log*
rm -rf .state
rm nek5000
rm SESSION.NAME 
rm makefile
