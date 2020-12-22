#!/bin/bash

LOGS_DIR=$1
FILES_DIR=$2
RUN_LISTS_DIR=$3

INDEX=0

for file in $(ls -A ${FILES_DIR}); do
	ERROR_LOGS=$(mktemp /tmp/logs_${INDEX}.XXXXXXX)
	touch ${ERROR_LOGS}

	ls ${LOGS_DIR}/*_${INDEX}.*log | grep -v 'run-omegamap\|prepare-mrbayes-files\|run-mrbayes\|run-fubar\|check-codeml-limit\|run-codeml\|run-phipack' | grep -e "_${INDEX}.err.log" -e "_${INDEX}.out.log" | xargs grep -l -i 'error' > ${ERROR_LOGS}

	while read LOG_FILE; do
		LOG_FILENAME=$(basename -- "${LOG_FILE}")
		echo -e "${file}\t${LOG_FILENAME}"
	done < ${ERROR_LOGS}

	rm -f  ${ERROR_LOGS}

	INDEX=$((INDEX + 1))
done

function process_run_list_logs {
	TASK=$1
	RUN_LIST=$2

	TASK_LOG_FILES=$(grep -l -i 'error' ${LOGS_DIR}/${TASK}*log)
	for LOG_FILE in ${TASK_LOG_FILES}; do
		LOG_FILE_INDEX=$(echo ${LOG_FILE} | sed -r 's#.*_([0-9]*)\..*#\1#g' | awk '{print $1+1}');
		ERROR_FILE_NAME=$(cat ${RUN_LIST} | sed -n "${LOG_FILE_INDEX}p" | cut -d',' -f2)

		LOG_FILENAME=$(basename -- "${LOG_FILE}")
		ERROR_FILE_NAME=$(basename -- "${ERROR_FILE_NAME}")

		echo -e "${ERROR_FILE_NAME}\t${LOG_FILENAME}"
	done

}

process_run_list_logs run-omegamap ${RUN_LISTS_DIR}/omegamap
process_run_list_logs prepare-mrbayes-files ${RUN_LISTS_DIR}/mrbayes
process_run_list_logs run-mrbayes ${RUN_LISTS_DIR}/mrbayes
process_run_list_logs run-fubar ${RUN_LISTS_DIR}/fubar
process_run_list_logs check-codeml-limit ${RUN_LISTS_DIR}/codeml
process_run_list_logs run-codeml ${RUN_LISTS_DIR}/codeml
process_run_list_logs run-phipack ${RUN_LISTS_DIR}/phipack
