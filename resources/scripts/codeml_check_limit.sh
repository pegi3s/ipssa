#!/bin/bash

# check for codeML 270000 limit

#[1] file [2] file dir [3] output

# 90000 = codon number
limit=270000 # must be a multiple of 3. You can change it for testing purposes but should be 270000
# ^90000*3 = 270000

TMP_DIR=$(mktemp -d /tmp/pss-codeML-limit-$1.XXXXXX)
grep -v '>' $2/$1 > ${TMP_DIR}/$1
tr "\n" " " < ${TMP_DIR}/$1 > ${TMP_DIR}/$1.count
tr "\r" " " < ${TMP_DIR}/$1.count > ${TMP_DIR}/$1
sed -i 's/ //g' ${TMP_DIR}/$1
tl="$(wc -c < "${TMP_DIR}/$1")"
tn="$(grep -c '>' $2/$1)"
rt=$(echo "$tl / $tn" | bc)

# with an estimated frequency of 1 in 1000 the alignment of a subset of sequences can be 
# longer than the alignment of the full set thus we remove one sequence 
# from the maximum allowed

# maximum sequences allowed
tna=$(echo "($limit / $rt) -1" | bc)

echo "Maximum number of sequences allowed for" $1 "is" $tna

lines=$(( 2*tna ))
head -$lines $2/$1 > ${TMP_DIR}/$1

cp ${TMP_DIR}/$1 $3

rm -rf TMP_DIR
