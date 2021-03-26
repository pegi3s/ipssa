#!/bin/bash

# This scripts removes sequences with ambiguous positions from the input file
# and writes the result into the output file. Line breaks should have been 
# removed from the input FASTA file before using this script.

function printHelp {
  echo "Usage: `basename $0` </path/to/input_fasta> </path/to/output_fasta>"
}

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  printHelp
  exit 0
fi

if [ ! $# -eq 2 ]; then
  echo "Error: two arguments are required."
  printHelp
  exit 1
fi

touch $2

while read -r first;
    do read second;

    count=$(echo $second | grep -v '^[ACTGactg]*$' | wc -l)
    
    if [ $count -eq 0 ]; then
        echo "$first" >> $2
        echo "$second" >> $2
    fi
done < $1
