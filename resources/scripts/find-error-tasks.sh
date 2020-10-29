#!/bin/bash

LOGS_DIR=$1
FILES_DIR=$2

INDEX=0

for file in $(ls -A ${FILES_DIR}); do
	ERRORS=$(cat ${LOGS_DIR}/*_${INDEX}*log | grep -i 'error' | wc -l)

	if [ ! ${ERRORS} -eq 0 ]; then
		for log in $(ls -1A ${LOGS_DIR}/*_${INDEX}*log | grep -e "_${INDEX}.err.log" -e "_${INDEX}.out.log" | sort); do
			LOG_FILENAME=$(basename -- "${log}")
			ERROR=$(cat ${log} | grep -i 'error' | wc -l);
			if [ ! $ERROR -eq 0 ]; then
				echo -e "${file}\t${LOG_FILENAME}"
			fi
		done

	fi

	INDEX=$((INDEX + 1))
done
