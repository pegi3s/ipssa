#!/bin/bash

# Example:
#
# check_ambiguous_positions.sh file.fasta
# if [ $? -eq 0 ]; then
#   echo "File is valid"
# else
#   echo "File is not valid"
#   exit 1
# fi

function printHelp {
  echo "Usage: `basename $0` </path/to/input_fasta>"
}

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  printHelp
  exit 0
fi

if [ ! $# -eq 1 ]; then
  echo "Error: one argument is required."
  printHelp
  exit 1
fi

count=$(grep -v '>' $1 | grep -v '^[ACTGactg]*$' | wc -l)

if [ $count -eq 0 ]; then
  exit 0;
else
  exit 1;
fi
