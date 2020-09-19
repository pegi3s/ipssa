#!/bin/bash

#Aligns the previously translated protein sequence

# [1] prot file to be aligned [2] file dir [3] align method [4] Working path

LOWERCASE_ALIGN=$(echo $3 | tr "[:upper:]" "[:lower:]")

case $LOWERCASE_ALIGN in
	"clustalw" )
		docker run --rm -v $4:/data pegi3s/tcoffee t_coffee /data/$2/$1 -method=clustalw_msa -output=aln,fasta_aln,html -run_name /data/$2/aligned_prot ;;
	"muscle" )
		docker run --rm -v $4:/data pegi3s/tcoffee t_coffee /data/$2/$1 -method=muscle_msa -output=aln,fasta_aln,html -run_name /data/$2/aligned_prot ;;
	"kalign" )
		docker run --rm -v $4:/data pegi3s/tcoffee t_coffee /data/$2/$1 -method=kalign_msa -output=aln,fasta_aln,html -run_name /data/$2/aligned_prot ;;
	"t_coffee" )
		docker run --rm -v $4:/data pegi3s/tcoffee t_coffee /data/$2/$1 -method=t_coffee_msa -output=aln,fasta_aln,html -run_name /data/$2/aligned_prot ;;
	"amap" )
		docker run --rm -v $4:/data pegi3s/tcoffee t_coffee /data/$2/$1 -method=amap_msa -output=aln,fasta_aln,html -run_name /data/$2/aligned_prot ;;
	
	* )
		echo "Unknown alignment program." ;;
esac

cp $2/aligned_prot.aln $2/aligned_prot.aln.tmp && yes | mv $2/aligned_prot.aln.tmp $2/aligned_prot.aln
cp $2/aligned_prot.fasta_aln $2/aligned_prot.fasta_aln.tmp && yes | mv $2/aligned_prot.fasta_aln.tmp $2/aligned_prot.fasta_aln

cp $2/aligned_prot.dnd $2/aligned_prot.dnd.tmp && yes | mv $2/aligned_prot.dnd.tmp $2/aligned_prot.dnd
cp $2/aligned_prot.html $2/aligned_prot.html.tmp && yes | mv $2/aligned_prot.html.tmp $2/aligned_prot.html

#mv $2/aligned.fasta_aln $2/aligned.fasta # original file aligned
mv $2/aligned_prot.fasta_aln $2/aligned.prot.fasta # protein alignment, fasta format
mv $2/aligned_prot.aln $2/aligned.prot.aln # protein alignment, aln format
