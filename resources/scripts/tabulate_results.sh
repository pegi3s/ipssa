#!/bin/sh

#Tabulates PSS results
#Runs only when all other tasks for a given gene are finished, i.e, all replicas using all methods.

# [1] search directory [2] file prefix [3] output file

SEARCH_DIRECTORY=$1
FILE=$2
OUTPUT_FILE=$3

TMP_DIR=$(mktemp -d /tmp/pss-tabulate-results.XXXXXX)

find ${SEARCH_DIRECTORY} -name "${FILE}.*.results_PSS.list" > ${TMP_DIR}/list # finds all .list files

touch ${TMP_DIR}/tmp1 ${TMP_DIR}/tmp2

while read line
do
echo $line >> ${TMP_DIR}/tmp1
content=$(cat $line)
echo $content >> ${TMP_DIR}/tmp2

done < ${TMP_DIR}/list

paste ${TMP_DIR}/tmp1 ${TMP_DIR}/tmp2 > ${OUTPUT_FILE}
