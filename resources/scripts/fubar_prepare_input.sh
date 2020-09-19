#!/bin/sh

#Prepare files and run FUBAR

#[parameters] [1] file (aligned.fasta) [2] file dir [3] file tree path [4] fubar files dir

#Prepare FUBAR input files

TMP_DIR=$(mktemp -d /tmp/fubar_tmp_$1.XXXXXX)

cp $2/$1 ${TMP_DIR}/temp1.$1
echo "" >> ${TMP_DIR}/temp1.$1
cat $3 | sed 's/:/\n:/g; s/,/\n,/g; s/)/\n)/g; s/)/)\n/g' > ${TMP_DIR}/temp2.$1
sed -i '/\./d' ${TMP_DIR}/temp2.$1
tr '\n' ' ' < ${TMP_DIR}/temp2.$1 > ${TMP_DIR}/temp3.$1
sed -i 's/ //g' ${TMP_DIR}/temp3.$1
cat ${TMP_DIR}/temp1.$1 ${TMP_DIR}/temp3.$1 > $4/$1.fubar

#Change to format .fna otherwise the docker image won't recognize it
mv $4/$1.fubar $4/$1.fna

rm -rf ${TMP_DIR}
