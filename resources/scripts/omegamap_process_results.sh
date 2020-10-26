#!/bin/bash

# [parameters] [1] directory containing the omegamap results [2] base file name

OMEGAMAP_RESULTS=$1
BASE_FILE_NAME=$2

sed '1,3d' ${OMEGAMAP_RESULTS}/${BASE_FILE_NAME}.summary > ${OMEGAMAP_RESULTS}/${BASE_FILE_NAME}.tmp1

cut -f1,5 ${OMEGAMAP_RESULTS}/${BASE_FILE_NAME}.tmp1 > ${OMEGAMAP_RESULTS}/${BASE_FILE_NAME}.tmp2

awk '$2 > 1.000000' ${OMEGAMAP_RESULTS}/${BASE_FILE_NAME}.tmp2 > ${OMEGAMAP_RESULTS}/${BASE_FILE_NAME}.tmp3

cut -f1 ${OMEGAMAP_RESULTS}/${BASE_FILE_NAME}.tmp3 > ${OMEGAMAP_RESULTS}/${BASE_FILE_NAME}.tmp4

touch ${OMEGAMAP_RESULTS}/${BASE_FILE_NAME}.results_PSS.list

while read site
do
	corrected_site=$(($site + 1))
	echo $corrected_site >> ${OMEGAMAP_RESULTS}/${BASE_FILE_NAME}.results_PSS.list
done < ${OMEGAMAP_RESULTS}/${BASE_FILE_NAME}.tmp4

rm ${OMEGAMAP_RESULTS}/${BASE_FILE_NAME}.tmp1 ${OMEGAMAP_RESULTS}/${BASE_FILE_NAME}.tmp2 ${OMEGAMAP_RESULTS}/${BASE_FILE_NAME}.tmp3 ${OMEGAMAP_RESULTS}/${BASE_FILE_NAME}.tmp4
