#!/bin/sh

# [parameters] [1] path to ".results" file

sed -n '/Tabulating site\-level results/,$p' $1 > $1.tmp1
grep "Pos. posterior ="  $1.tmp1 > $1.tmp2
sed -i 's/ //g' $1.tmp2
sed -i 's/|/\t/g' $1.tmp2
cut -f2 $1.tmp2 > $1_PSS.list
rm $1.tmp1 $1.tmp2
