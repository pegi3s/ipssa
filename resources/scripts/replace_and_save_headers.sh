#/!bin/bash

function printHelp {
  echo "Usage: `basename $0` </path/to/input_fasta> </path/to/outut/dir>"
}

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  printHelp
  exit 0
fi

if [ ! $# -eq 2 ]; then
  echo "Error: three arguments are required."
  printHelp
  exit 1
fi

if [ ! -d $2 ]; then
  echo "Error: the output directory does not exist."
  exit 1
fi

FILENAME=$(basename -- "$1")

cat $1 | awk '
  BEGIN {
    count = 1
  }
  {
  if (match($0,"^>")){
    printf ">C%s\n", count, $0
    count = count +1
  } else {
    print $0
  }
}' > $2/$FILENAME.renamed

cat $1 | awk '
  BEGIN {
    count = 1
  }
  {
  if (match($0,"^>")){
    printf ">C%s\t%s\n", count, $0
    count = count +1
  }
}' > $2/$FILENAME.headers_map
