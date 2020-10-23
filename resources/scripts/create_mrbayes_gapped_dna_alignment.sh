#!/bin/sh

#
# This script receives three files as input:
#  $1) Path to the protein alignment (in clustal format).
#  $2) Path to the filtered protein alignment (in FASTA format).
#  $3) Path to the original DNA (unaligned) file (in FASTA format).
#
# And produces as output ($4) a FASTA file that corresponds to the original DNA file with the
# alignment and filtering gaps present in the protein alignment files.
#

VERSION_ALTER=${VERSION_ALTER:-latest}
VERSION_SEQKIT=${VERSION_SEQKIT:-latest}
VERSION_PEGI3S_UTILITIES=${VERSION_PEGI3S_UTILITIES:-latest}

TMP_DIR=${5:-$(mktemp -d /tmp/gapped_dna_alignment.XXXXX)}

cp $1 ${TMP_DIR}/PROTEIN_ALN.aln
cp $2 ${TMP_DIR}/PROTEIN_ALN_FILTERED.aln
cp $3 ${TMP_DIR}/ORIGINA_DNA.fasta

docker run --rm -v ${TMP_DIR}:/data pegi3s/alter:${VERSION_ALTER} -i /data/PROTEIN_ALN.aln -o /data/PROTEIN_ALN.fasta -ia -of FASTA -oo Linux -op GENERAL
docker run --rm -v ${TMP_DIR}:/data pegi3s/alter:${VERSION_ALTER} -i /data/PROTEIN_ALN_FILTERED.aln -o /data/PROTEIN_ALN_FILTERED.fasta -ia -of FASTA -oo Linux -op GENERAL

docker run --user "$(id -u):$(id -g)" --rm -v ${TMP_DIR}:/data pegi3s/seqkit:${VERSION_SEQKIT} split --by-size 1 /data/PROTEIN_ALN.fasta --out-dir /data/split_protein_alignment
docker run --user "$(id -u):$(id -g)" --rm -v ${TMP_DIR}:/data pegi3s/seqkit:${VERSION_SEQKIT} split --by-size 1 /data/PROTEIN_ALN_FILTERED.fasta --out-dir /data/split_protein_alignment_filtered
docker run --user "$(id -u):$(id -g)" --rm -v ${TMP_DIR}:/data pegi3s/seqkit:${VERSION_SEQKIT} split --by-size 1 /data/ORIGINA_DNA.fasta --out-dir /data/split_original_dna

docker run --rm -v ${TMP_DIR}/split_protein_alignment/:/data pegi3s/utilities:${VERSION_PEGI3S_UTILITIES} bash -c "batch_fasta_remove_line_breaks /data/*"
docker run --rm -v ${TMP_DIR}/split_protein_alignment_filtered/:/data pegi3s/utilities:${VERSION_PEGI3S_UTILITIES} bash -c "batch_fasta_remove_line_breaks /data/*"
docker run --rm -v ${TMP_DIR}/split_original_dna/:/data pegi3s/utilities:${VERSION_PEGI3S_UTILITIES} bash -c "batch_fasta_remove_line_breaks /data/*"

INDEX=1; cd ${TMP_DIR}/split_protein_alignment; for file in `ls ${TMP_DIR}/split_protein_alignment`; do mv $file $INDEX; INDEX=$((INDEX + 1)); done
INDEX=1; cd ${TMP_DIR}/split_protein_alignment_filtered; for file in `ls ${TMP_DIR}/split_protein_alignment_filtered`; do mv $file $INDEX; INDEX=$((INDEX + 1)); done
INDEX=1; cd ${TMP_DIR}/split_original_dna; for file in `ls ${TMP_DIR}/split_original_dna`; do mv $file $INDEX; INDEX=$((INDEX + 1)); done

PROCESS_DIR=${TMP_DIR}/process

mkdir ${PROCESS_DIR}

cd ${PROCESS_DIR}

touch result.fasta

for file in `ls ${TMP_DIR}/split_protein_alignment`; do

  rm -f ./file*
  rm -f ./tmp*

  # 0. prepare files (remove headers)
  grep '>' ${TMP_DIR}/split_original_dna/$file >> result.fasta
  grep -v '>' ${TMP_DIR}/split_protein_alignment/$file > file1
  grep -v '>' ${TMP_DIR}/split_protein_alignment_filtered/$file > file2
  grep -v '>' ${TMP_DIR}/split_original_dna/$file > file3

  # 1 create a list of gapped positions in the original protein alignment
  grep -aob '-' file1 > tmp1
  sed -i 's/[:-]//g' tmp1
  sort -nr tmp1 > tmp2

  # 2 remove positions that are in the original protein alignment from the protein alignment after masking low support positions file
  cp file2 tmp3

  while read line
  do

  line_corr=$(($line + 1)) # counts start at 0, thus the +1

  sed -i "s/.//$line_corr" tmp3

  done < tmp2

  # 3 make a list of the remaining positions in the protein alignment after masking low support positions file
  grep -aob '-' tmp3 > tmp4
  sed -i 's/[:-]//g' tmp4

  # 4 make a list of the corresponding postions in the non-aligned DNA sequence
  touch tmp5
  while read line
  do

  line_corr=$((($line + 1) * 3 -2)) # counts start at 0, thus the +1
  echo $line_corr >> tmp5

  line_corr=$((($line + 1) * 3 -1))
  echo $line_corr >> tmp5

  line_corr=$((($line + 1) * 3))
  echo $line_corr >> tmp5

  done < tmp4

  sort -nr tmp5 > tmp6

  # 5. delete the corresponding postions in the non-aligned DNA sequence

  cp file3 tmp7

  while read line
  do
    sed -i "s/.//$line" tmp7
  done < tmp6

  # 6. insert the gapped positions present in the protein alignment after masking low support positions sequence in the DNA sequence to reconstruct the corresponding DNA alignment

  grep -aob '-' file2 > tmp8
  sed -i 's/[:-]//g' tmp8
  sort -n tmp8 > tmp9

  while read line
  do
    line_corr=$((($line+1) * 3))
    sed -i "s/./&---/$line_corr" tmp7
  done < tmp9

  cat tmp7 >> result.fasta
done

cp result.fasta $4
