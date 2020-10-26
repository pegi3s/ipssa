#!/bin/bash

#Look for evidence for recombination judging from Phi permutation test
# [parameters] [1] directory [2] phipack.log file

a=$(grep 'PHI (Permutation):   ' $1/$2 | cut -d':' -f 2 | cut -d'(' -f 1 | sed 's/ //g' | sed -E 's/([+-]?[0-9.]+)[eE]\+?(-?)([0-9]+)/(\1*10^\2\3)/g')
# last sed transforms scientific notation to decimal because bc doesn't recognize this format

cutoff=0.05
b=$(echo "$a < $cutoff" | bc -l)

if [ -z $b ]
then
    echo "No evidence for recombination" > $1/$2.summary
else
    if [ "$b" -eq "1" ]
    then
        echo "Evidence for recombination" > $1/$2.summary
    else
        echo "No evidence for recombination" > $1/$2.summary
    fi
fi
