#!/bin/bash

INPUT_FILE=$1

if [ -f "${INPUT_FILE}" ]; then
	TMP_DIR=$(mktemp -d /tmp/pss-dp-execution-time.XXXXXXXX)
	OUTPUT_FILE=$2

	mkdir -p ${TMP_DIR}
	grep 'Compi running with' ${INPUT_FILE} | cut -f1,2 -d' ' | sed 's/\[//g; s/\]//g' > ${TMP_DIR}/get_time_results.total
	tail -1 ${INPUT_FILE} | cut -f1,2 -d' ' | sed 's/\[//g; s/\]//g' >> ${TMP_DIR}/get_time_results.total
	grep 'Started task pull-docker-images' ${INPUT_FILE} | cut -f1,2 -d' ' | sed 's/\[//g; s/\]//g' > ${TMP_DIR}/get_time_results.pull_docker
	grep 'Finished task pull-docker-images' ${INPUT_FILE} | cut -f1,2 -d' ' | sed 's/\[//g; s/\]//g' >> ${TMP_DIR}/get_time_results.pull_docker
	grep 'Started loop task align-protein-sequences' ${INPUT_FILE} | cut -f1,2 -d' ' | sed 's/\[//g; s/\]//g' > ${TMP_DIR}/get_time_results.align
	grep 'Finished loop task align-protein-sequences' ${INPUT_FILE} | cut -f1,2 -d' ' | sed 's/\[//g; s/\]//g' >> ${TMP_DIR}/get_time_results.align
	grep 'Started loop task run-mrbayes' ${INPUT_FILE} | cut -f1,2 -d' ' | sed 's/\[//g; s/\]//g' > ${TMP_DIR}/get_time_results.mrbayes
	grep 'Finished loop task run-mrbayes' ${INPUT_FILE} | cut -f1,2 -d' ' | sed 's/\[//g; s/\]//g' >> ${TMP_DIR}/get_time_results.mrbayes
	grep 'Started loop task run-fubar' ${INPUT_FILE} | cut -f1,2 -d' ' | sed 's/\[//g; s/\]//g' > ${TMP_DIR}/get_time_results.fubar
	grep 'Finished loop task run-fubar' ${INPUT_FILE} | cut -f1,2 -d' ' | sed 's/\[//g; s/\]//g' >> ${TMP_DIR}/get_time_results.fubar
	grep 'Started loop task run-codeml' ${INPUT_FILE} | cut -f1,2 -d' ' | sed 's/\[//g; s/\]//g' > ${TMP_DIR}/get_time_results.codeml
	grep 'Finished loop task run-codeml' ${INPUT_FILE} | cut -f1,2 -d' ' | sed 's/\[//g; s/\]//g' >> ${TMP_DIR}/get_time_results.codeml
	grep 'Started loop task run-omegamap' ${INPUT_FILE} | cut -f1,2 -d' ' | sed 's/\[//g; s/\]//g' > ${TMP_DIR}/get_time_results.omegamap
	grep 'Finished loop task run-omegamap' ${INPUT_FILE} | cut -f1,2 -d' ' | sed 's/\[//g; s/\]//g' >> ${TMP_DIR}/get_time_results.omegamap

	touch ${OUTPUT_FILE}

	line1=$(head -1 ${TMP_DIR}/get_time_results.total) && value1=$(date --date="$line1" +%s)
	line2=$(tail -1 ${TMP_DIR}/get_time_results.total) && value2=$(date --date="$line2" +%s)
	dif=$(($value2 - $value1))
	echo "It took" $dif "seconds to execute the project" | tee -a ${OUTPUT_FILE}
	value1=0 && value2=0

	line1=$(head -1 ${TMP_DIR}/get_time_results.pull_docker) && value1=$(date --date="$line1" +%s)
	line2=$(tail -1 ${TMP_DIR}/get_time_results.pull_docker) && value2=$(date --date="$line2" +%s)
	dif=$(($value2 - $value1))
	echo "It took" $dif "seconds to pull the needed Docker images" | tee -a ${OUTPUT_FILE}
	value1=0 && value2=0

	line1=$(head -1 ${TMP_DIR}/get_time_results.align) && value1=$(date --date="$line1" +%s)
	line2=$(tail -1 ${TMP_DIR}/get_time_results.align) && value2=$(date --date="$line2" +%s)
	dif=$(($value2 - $value1))
	echo "It took" $dif "seconds to align the protein sequences" | tee -a ${OUTPUT_FILE}
	value1=0 && value2=0

	line1=$(head -1 ${TMP_DIR}/get_time_results.mrbayes) && value1=$(date --date="$line1" +%s)
	line2=$(tail -1 ${TMP_DIR}/get_time_results.mrbayes) && value2=$(date --date="$line2" +%s)
	dif=$(($value2 - $value1))
	echo "It took" $dif "seconds to run all MrBayes instances" | tee -a ${OUTPUT_FILE}
	value1=0 && value2=0

	line1=$(head -1 ${TMP_DIR}/get_time_results.fubar) && value1=$(date --date="$line1" +%s)
	line2=$(tail -1 ${TMP_DIR}/get_time_results.fubar) && value2=$(date --date="$line2" +%s)
	dif=$(($value2 - $value1))
	echo "It took" $dif "seconds to execute all FUBAR instances" | tee -a ${OUTPUT_FILE}
	value1=0 && value2=0

	line1=$(head -1 ${TMP_DIR}/get_time_results.codeml) && value1=$(date --date="$line1" +%s)
	line2=$(tail -1 ${TMP_DIR}/get_time_results.codeml) && value2=$(date --date="$line2" +%s)
	dif=$(($value2 - $value1))
	echo "It took" $dif "seconds to execute all codeML instances" | tee -a ${OUTPUT_FILE}
	value1=0 && value2=0

	line1=$(head -1 ${TMP_DIR}/get_time_results.omegamap) && value1=$(date --date="$line1" +%s)
	line2=$(tail -1 ${TMP_DIR}/get_time_results.omegamap) && value2=$(date --date="$line2" +%s)
	dif=$(($value2 - $value1))
	echo "It took" $dif "seconds to execute all omegamap instances" | tee -a ${OUTPUT_FILE}
	value1=0 && value2=0
else
	echo "The input file does not exist"
fi
