#!/bin/sh

#[1] file [2] dir [3] new dir [4] sub size [5] iteraction [6] random seed string

#Group header+sequence using <

SUBSET_TMP_DIR=$(mktemp -d /tmp/pss-subset-tmp.XXXXXXXX)

mkdir -p $SUBSET_TMP_DIR ./$3
cp ./$2/$1 $SUBSET_TMP_DIR/$1
awk '{printf("%s%s",$0,(NR%2==0)?"\n":"<")}' $SUBSET_TMP_DIR/$1 > $SUBSET_TMP_DIR/$1.temp1

i=1
while [ "$i" -le "$5" ] 
do

#If the seq limit is less from total, shuf a subset of them
count_seq=$(grep -c ">" $SUBSET_TMP_DIR/$1.temp1)

if [ "$count_seq" -le "$4" ]; then
	cp $SUBSET_TMP_DIR/$1.temp1 $SUBSET_TMP_DIR/$1.temp2 
fi

if [ "$count_seq" -gt "$4" ]; then
    RAMDOM_SOURCE=$(mktemp /tmp/random.$1.$i.XXXXXXXX)
    RANDOM_SEED=$(($i * $6 + $i + $i * 10))
    echo "$RANDOM_SEED$RANDOM_SEED$RANDOM_SEED$RANDOM_SEED$RANDOM_SEED$RANDOM_SEED$RANDOM_SEED$RANDOM_SEED$RANDOM_SEED$RANDOM_SEED$RANDOM_SEED$RANDOM_SEED$RANDOM_SEED$RANDOM_SEED$RANDOM_SEED$RANDOM_SEED$RANDOM_SEED\n$RANDOM_SEED$RANDOM_SEED$RANDOM_SEED$RANDOM_SEED$RANDOM_SEED$RANDOM_SEED$RANDOM_SEED$RANDOM_SEED$RANDOM_SEED$RANDOM_SEED$RANDOM_SEED$RANDOM_SEED$RANDOM_SEED$RANDOM_SEED$RANDOM_SEED$RANDOM_SEED$RANDOM_SEED" > $RAMDOM_SOURCE
    
	shuf --random-source=$RAMDOM_SOURCE -n $4 $SUBSET_TMP_DIR/$1.temp1 > $SUBSET_TMP_DIR/$1.temp2
fi

#Reset the newlines
sed -i 's/</\n/g' $SUBSET_TMP_DIR/$1.temp2

mv $SUBSET_TMP_DIR/$1.temp2 ./$3/$1.$i


i=$(( i+1 ))

done
rm -rf $SUBSET_TMP_DIR
