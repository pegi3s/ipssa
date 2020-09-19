#!/bin/sh

#[parameters] [1] hyphy configuration file [2] fna input file path

echo "1" > $1
echo "4" >> $1
echo "1" >> $1
echo $2 >> $1
echo "Y" >> $1
echo "20" >> $1
echo "3" >> $1
echo "0.5" >> $1
