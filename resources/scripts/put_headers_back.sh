#!/bin/bash

function printHelp {
  echo "Usage: `basename $0` </path/to/input_fasta> </path/to/headers_map_file> </path/to/outut/fasta>"
}

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  printHelp
  exit 0
fi

if [ ! $# -eq 3 ]; then
  echo "Error: three arguments are required."
  printHelp
  exit 1
fi

rm -f $3

while IFS= read -r line || [ -n "$line" ]; do
  if [[ $line = \>* ]] ; then
    original_header=$(cat $2 | grep -P "^${line}\t" | cut -f2)
    if [ -z "$original_header" ]
    then
      echo "$line" >> $3
    else
      echo $original_header >> $3
    fi
  else
    echo "$line" >> $3
  fi
done < "$1"
