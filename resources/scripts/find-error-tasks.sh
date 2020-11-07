#!/bin/bash

LOGS_DIR=$1
FILES_DIR=$2
RUN_LISTS_DIR=$3

INDEX=0

for file in $(ls -A ${FILES_DIR}); do
	ERRORS=$(cat ${LOGS_DIR}/*_${INDEX}*log | grep -i 'error' | wc -l)

	if [ ! ${ERRORS} -eq 0 ]; then
		for log in $(ls -1A ${LOGS_DIR}/*_${INDEX}*log | grep -v 'run-omegamap\|prepare-mrbayes-files\|run-mrbayes\|run-fubar\|check-codeml-limit\|run-codeml\|run-phipack' | grep -e "_${INDEX}.err.log" -e "_${INDEX}.out.log" | sort); do
			LOG_FILENAME=$(basename -- "${log}")
			ERROR=$(cat ${log} | grep -i 'error' | wc -l);
			if [ ! $ERROR -eq 0 ]; then
				echo -e "${file}\t${LOG_FILENAME}"
			fi
		done
	fi

	INDEX=$((INDEX + 1))
done

function process_run_list_logs {
	INDEX=0
	TASK=$1
	RUN_LIST=$2

	while read file; do
		file=$(echo ${file} | cut -d',' -f2)

		for log in $(ls -1A ${LOGS_DIR}/${TASK}*_${INDEX}*log | grep -e "_${INDEX}.err.log" -e "_${INDEX}.out.log" | sort); do
			LOG_FILENAME=$(basename -- "${log}")
			ERROR=$(cat ${log} | grep -i 'error' | wc -l);
			if [ ! $ERROR -eq 0 ]; then
				echo -e "${file}\t${LOG_FILENAME}"
			fi
		done

		INDEX=$((INDEX + 1))
	done < ${RUN_LIST}
}

process_run_list_logs run-omegamap ${RUN_LISTS_DIR}/omegamap
process_run_list_logs prepare-mrbayes-files ${RUN_LISTS_DIR}/mrbayes
process_run_list_logs run-mrbayes ${RUN_LISTS_DIR}/mrbayes
process_run_list_logs run-fubar ${RUN_LISTS_DIR}/fubar
process_run_list_logs check-codeml-limit ${RUN_LISTS_DIR}/codeml
process_run_list_logs run-codeml ${RUN_LISTS_DIR}/codeml
process_run_list_logs run-phipack ${RUN_LISTS_DIR}/phipack
