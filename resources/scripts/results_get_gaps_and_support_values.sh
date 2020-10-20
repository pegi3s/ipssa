#!/bin/bash

ORIGINAL_FILENAME=$1
WORKING_DIR=$2
HOST_WORKING_DIR=$3

FILENAME_WITHOUT_EXT="${ORIGINAL_FILENAME%.*}"
FILENAME=${FILENAME_WITHOUT_EXT}

TMP_DIR=$(mktemp -d /tmp/support-values-${FILENAME}.XXXX)

#Get alignment gaps

docker run --rm -v ${HOST_WORKING_DIR}/:/data -v /tmp:/tmp pegi3s/alter -i /data/input/6_aligned/${FILENAME}.aln -o ${TMP_DIR}/${FILENAME}.fasta -ia -of FASTA -oo Linux -op GENERAL

docker run --rm -v /tmp:/tmp pegi3s/utilities fasta_remove_line_breaks ${TMP_DIR}/${FILENAME}.fasta

grep -v '>' ${TMP_DIR}/${FILENAME}.fasta > ${TMP_DIR}/${FILENAME}.fasta.tmp1

while read line
do
	echo $line | grep -aob '-' >> ${TMP_DIR}/${FILENAME}.fasta.tmp2
done < ${TMP_DIR}/${FILENAME}.fasta.tmp1

sed -i 's/\://g' ${TMP_DIR}/${FILENAME}.fasta.tmp2
sed -i 's/\-//g' ${TMP_DIR}/${FILENAME}.fasta.tmp2

while read line
do
	corrvalue=$(($line + 1))
	echo $corrvalue >> ${TMP_DIR}/${FILENAME}.fasta.tmp3
done < ${TMP_DIR}/${FILENAME}.fasta.tmp2

sort -nu ${TMP_DIR}/${FILENAME}.fasta.tmp3 > ${TMP_DIR}/${FILENAME}.fasta.tmp4

echo "Gapped sites in protein alignment" >> ${WORKING_DIR}/results/tabulated/${ORIGINAL_FILENAME}
echo $(cat ${TMP_DIR}/${FILENAME}.fasta.tmp4) >> ${WORKING_DIR}/results/tabulated/${ORIGINAL_FILENAME}

#Get low support values

docker run --rm -v ${HOST_WORKING_DIR}/:/data -v /tmp:/tmp pegi3s/alter -i /data/input/10_gapped_alignment/2_gapped_alignment/${FILENAME}.aln -o ${TMP_DIR}/${FILENAME}.fasta.support -ia -of FASTA -oo Linux -op GENERAL

docker run --rm -v /tmp:/tmp pegi3s/utilities fasta_remove_line_breaks ${TMP_DIR}/${FILENAME}.fasta.support

grep -v '>' ${TMP_DIR}/${FILENAME}.fasta.support > ${TMP_DIR}/${FILENAME}.fasta.tmp1.support

while read line
do
	echo $line | grep -aob '-' >> ${TMP_DIR}/${FILENAME}.fasta.tmp2.support
done < ${TMP_DIR}/${FILENAME}.fasta.tmp1.support

sed -i 's/\://g' ${TMP_DIR}/${FILENAME}.fasta.tmp2.support
sed -i 's/\-//g' ${TMP_DIR}/${FILENAME}.fasta.tmp2.support

while read line
do
	corrvalue=$(($line + 1))
	echo $corrvalue >> ${TMP_DIR}/${FILENAME}.fasta.tmp3.support
done < ${TMP_DIR}/${FILENAME}.fasta.tmp2.support

touch ${TMP_DIR}/${FILENAME}.fasta.tmp4.support

while read line
do
	if grep -q "\b$line\b" ${TMP_DIR}/${FILENAME}.fasta.tmp3; then
		:
	else
		echo $line >> ${TMP_DIR}/${FILENAME}.fasta.tmp4.support
	fi
done < ${TMP_DIR}/${FILENAME}.fasta.tmp3.support

sort -nu ${TMP_DIR}/${FILENAME}.fasta.tmp4.support > ${TMP_DIR}/${FILENAME}.fasta.tmp5.support

echo "Low support positions in the alignment" >> ${WORKING_DIR}/results/tabulated/${ORIGINAL_FILENAME}
echo $(cat ${TMP_DIR}/${FILENAME}.fasta.tmp5.support) >> ${WORKING_DIR}/results/tabulated/${ORIGINAL_FILENAME}

recomb=$(cat ${WORKING_DIR}/input/results/master_alignment/phipack/${ORIGINAL_FILENAME}/phipack.log.summary)
echo "Evidence for recombination in the master alignment" >> ${WORKING_DIR}/results/tabulated/${ORIGINAL_FILENAME}
echo $recomb >> ${WORKING_DIR}/results/tabulated/${ORIGINAL_FILENAME}
