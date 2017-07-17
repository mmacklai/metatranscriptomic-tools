#!/bin/bash
#this is the shebang needed for agrajag. I know it's not portable, but it's the one that works...

# April 27 2017 - JM
# Run kaiju on all samples in directory ending in .fastq.gz
# Jul 14 2017 - Use this version as a general script

#----------------Setup - change these paths if necessary
BIN="/Volumes/data/bin/kaiju/bin/"
DB="/Volumes/data/bin/kaiju/kaijudb/"

DATA="/Volumes/data/A_n_L/2017_metagenomes/NS_00018/data"

#-----------------------------------------

mkdir -p kaiju	#make an output directory if it doesn't exist
OUT="kaiju"

for f in $DATA/*.fastq.gz; do

# Split on - and get the first field
	B=`basename $f`	#this will give the file name out of the whole path
	NAME=`echo $B | cut -d "_" -f1`	#split on _ and get first field (sample name)

#testing
#	echo $f
#	echo $B
#	echo $NAME
#	exit

	$BIN/kaiju -t $DB/nodes.dmp -f $DB/kaiju_db_nr_euk.fmi -i <(gunzip -c $f) -o $OUT/$NAME.kaiju.out -z 48

	$BIN/kaijuReport -t $DB/nodes.dmp -n $DB/names.dmp -i $OUT/$NAME.kaiju.out -r genus -o $OUT/$NAME.kaiju.out.summary

done


