#!/bin/sh

# [1] ctl file path
#[1] file [2] file dir [3] tree file [4] tree file dir [5] codeMLmodels

CTL_FILE_PATH=$1
CODE_ML_MODELS=$2
DOCKER_PATH_SEQFILE=$3
DOCKER_PATH_TREEFILE=$4
DOCKER_PATH_OUTFILE=$5

rm -f ${CTL_FILE_PATH}
touch ${CTL_FILE_PATH}

echo "seqfile = ${DOCKER_PATH_SEQFILE}" > ${CTL_FILE_PATH}
echo "treefile = ${DOCKER_PATH_TREEFILE}" >> ${CTL_FILE_PATH}
echo "outfile = ${DOCKER_PATH_OUTFILE}" >> ${CTL_FILE_PATH}

echo "noisy = 3" >> ${CTL_FILE_PATH}
echo "verbose = 0" >> ${CTL_FILE_PATH}
echo "runmode = 0" >> ${CTL_FILE_PATH}

echo "seqtype = 1" >> ${CTL_FILE_PATH}
echo "CodonFreq = 2" >> ${CTL_FILE_PATH}
echo "clock = 0" >> ${CTL_FILE_PATH}
echo "aaDist = 0" >> ${CTL_FILE_PATH}
echo "model = 0" >> ${CTL_FILE_PATH}

echo "NSsites =" ${CODE_ML_MODELS} >> ${CTL_FILE_PATH}
echo "icode = 0" >> ${CTL_FILE_PATH}
echo "Mgene = 0" >> ${CTL_FILE_PATH}

echo "fix_kappa = 0" >> ${CTL_FILE_PATH}
echo "kappa = .3" >> ${CTL_FILE_PATH}
echo "fix_omega = 0" >> ${CTL_FILE_PATH}
echo "omega = 1.3" >> ${CTL_FILE_PATH}
echo "ncatG = 10" >> ${CTL_FILE_PATH}

echo "getSE = 0" >> ${CTL_FILE_PATH}
echo "RateAncestor = 0" >> ${CTL_FILE_PATH}

echo "Small_Diff = .45e-6" >> ${CTL_FILE_PATH}
echo "cleandata = 1" >> ${CTL_FILE_PATH}
echo "fix_blength = 0" >> ${CTL_FILE_PATH}

