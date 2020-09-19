#!/bin/bash

#Appends mrbayes instructions to the end of the filtered sequences file

#Args: [1] file [2] ngen [3] pburnin/tburnin [4] nst [5] rates

nchar=$(cat $1 | grep -o 'nchar=.*;' | sed -e 's/nchar=\(.*\);/\1/')

echo "begin mrbayes;
set autoclose=yes nowarn=yes;
charset first_pos = 1-$nchar\3;
charset second_pos = 2-$nchar\3;
charset third_pos = 3-$nchar\3;
partition by_codon = 3: first_pos,second_pos,third_pos;
set partition = by_codon;
lset nst=$4 rates=$5;
unlink shape=(3);
mcmc ngen=$2;
sump burnin=$3;
sumt conformat=simple burnin=$3;
end;" >> $1
