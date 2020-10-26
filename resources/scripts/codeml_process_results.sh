#!/bin/bash

#Extracts uncorrected and corrected codeML PSS

#[1] input FASTA file [2] codeml.out file [3] results file

INPUT_FASTA_FILENAME=$(basename -- "$1")
CODEML_OUT_FILE=${INPUT_FASTA_FILENAME}.codeml.out

TMP_DIR=$(mktemp -d /tmp/pss-codeML-results-${INPUT_FASTA_FILENAME}.XXXXXX)
cd ${TMP_DIR}

cp $2 ${TMP_DIR}/${CODEML_OUT_FILE}
cp $1 ${TMP_DIR}/${INPUT_FASTA_FILENAME}

#Extract and compare log likelihood values

#codeML will execute models by the order indicated in the config file. Moreover the loglikelihood value is not always in the same position relative to the header
M1=$(grep -A10 'Model 1' ${CODEML_OUT_FILE} | grep 'lnL' | grep -o -e ' \-[0123456789.]* ' | sed 's/ //g')
M2=$(grep -A10 'Model 2' ${CODEML_OUT_FILE} | grep 'lnL' | grep -o -e ' \-[0123456789.]* ' | sed 's/ //g')
M7=$(grep -A10 'Model 7' ${CODEML_OUT_FILE} | grep 'lnL' | grep -o -e ' \-[0123456789.]* ' | sed 's/ //g')
M8=$(grep -A10 'Model 8' ${CODEML_OUT_FILE} | grep 'lnL' | grep -o -e ' \-[0123456789.]* ' | sed 's/ //g')

echo "The loglikelihoods for models M1, M2, M7 and M8 are" $M1 $M2 $M7 $M8 "respectively"

M2dif=$(echo "2 * ($M2 - $M1)" |bc)
M8dif=$(echo "2 * ($M8 - $M7)" |bc)
testM2=$(echo "$M2dif > 5.99" |bc)
testM8=$(echo "$M8dif > 5.99" |bc)

if [ $testM2 -eq 1 ]
then
   echo "The loglikelihood for model M2a is significantly different from that for M1a. Twice the difference is" $M2dif
   sed -n '/Model 2/,/Time used/p' ${CODEML_OUT_FILE} > ${CODEML_OUT_FILE}.filtered
fi

if [ $testM8 -eq 1 ]
then
   echo "The loglikelihood for model M8 is significantly different from that for M7. Twice the difference is" $M8dif
   sed -n '/Model 8/,/Time used/p' ${CODEML_OUT_FILE} >> ${CODEML_OUT_FILE}.filtered
fi

#Extract codeML PSS

if [ -f ${CODEML_OUT_FILE}.filtered ]
then
    grep "*" ${CODEML_OUT_FILE}.filtered | grep -v "|" | grep -v "branch" | grep -v "Positively" > ${CODEML_OUT_FILE}.tmp1

    while cat ${CODEML_OUT_FILE}.tmp1 | grep -q "  "
    do
    sed -i 's/  / /g' ${CODEML_OUT_FILE}.tmp1
    done

    cut ${CODEML_OUT_FILE}.tmp1 -d" " -f2 > ${CODEML_OUT_FILE}.tmp2
    sort -n -u ${CODEML_OUT_FILE}.tmp2 > ${CODEML_OUT_FILE}.without_correction

    #Identify gap positions

    grep -v ">" ${INPUT_FASTA_FILENAME} > ${INPUT_FASTA_FILENAME}.tmp1
    while read seq
    do
        echo $seq > ${INPUT_FASTA_FILENAME}.tmp2
        sed -i 's/---/\nX\n/g' ${INPUT_FASTA_FILENAME}.tmp2
        sed -i '/X/ ! s/.../A/g' ${INPUT_FASTA_FILENAME}.tmp2
        (tr "\n" " " < ${INPUT_FASTA_FILENAME}.tmp2) > ${INPUT_FASTA_FILENAME}.tmp3
        sed -i 's/ //g' ${INPUT_FASTA_FILENAME}.tmp3
        seq=$(cat ${INPUT_FASTA_FILENAME}.tmp3)
        grep -aob "X" ${INPUT_FASTA_FILENAME}.tmp3 >> ${INPUT_FASTA_FILENAME}.tmp4
    done < ${INPUT_FASTA_FILENAME}.tmp1
    sed -i 's/\:X//g' ${INPUT_FASTA_FILENAME}.tmp4
    sort -n -u ${INPUT_FASTA_FILENAME}.tmp4 > ${INPUT_FASTA_FILENAME}.tmp5 # Numbers are offset by 1
    while read value
    do
        new_value=$(($value + 1))
        echo $new_value >> ${INPUT_FASTA_FILENAME}.gap_position_list
    done < ${INPUT_FASTA_FILENAME}.tmp5

    #Corrects codeML positions

    while read codeml_value
    do
    while read gap_value
    do
        if [ "$codeml_value" -ge "$gap_value" ]
        then
        codeml_value=$(($codeml_value + 1))
        fi
    done < ${INPUT_FASTA_FILENAME}.gap_position_list
    echo $codeml_value >> ${CODEML_OUT_FILE}.list
    done < ${CODEML_OUT_FILE}.without_correction

    cp ${CODEML_OUT_FILE}.list $3

else
    touch $3
fi

cd .. && rm -rf ${TMP_DIR}
