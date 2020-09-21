#!/bin/bash

#Gets MrBayes tree with and whithout branch lengths

#Args: [1] tree file (.nex.con.tre) [2] tree dir

cd $2

touch mrbayes_tree_original.tre

#Writes tree lines to file mrbayes_tree_original.tre
tail -2 $1 | head -1 | sed "s/ //g" | sed -E "s/^t(.)*=//" > mrbayes_tree_original.tre
cp mrbayes_tree_original.tre mrbayes_tree_with_branch_lengths.tre

#Getting the real sequences' names & edit tree accordingly
#Note: defining \t as a variable because not all versions of sed recognize it
TAB=$'\t'
#Gets block of sequences' names into tmpfile
sed -n "/${TAB}taxlabels/,/${TAB}${TAB};/p" $1 | sed "s/${TAB}//g" | tail -n +2 > tmpfile

#Number of sequences present
numseq=$(grep -c "C" tmpfile)

#File with only the sequences' names
head --lines=$numseq tmpfile > tmpfile2
rm -f tmpfile

#Create array with sequences names & replace in mrbayes_tree file
declare -a seq_names
for (( i = 1; i < $(echo $numseq "+1" | bc -l); i++ )); do
	seq_names[$i]=$(cat tmpfile2 | head -$i | tail -1)
	sed -i "s/($i:/(${seq_names[$i]}#/" mrbayes_tree_with_branch_lengths.tre
	sed -i "s/,$i:/,${seq_names[$i]}#/" mrbayes_tree_with_branch_lengths.tre
done

sed -i "s/#/:/g" mrbayes_tree_with_branch_lengths.tre
rm -f tmpfile2

#Still need to remove the numbers after ':' to create tree without branch lengths
cp mrbayes_tree_with_branch_lengths.tre mrbayes_tree_without_branch_lengths.tre
sed -i 's/:[^:,]*,/,/g' mrbayes_tree_without_branch_lengths.tre
sed -i 's/:[^'\)']*//g' mrbayes_tree_without_branch_lengths.tre
