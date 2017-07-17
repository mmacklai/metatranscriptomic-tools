#!/usr/bin/env bash

#19Apr2017 - JM
#copied file from 2016_corn_metagenomes/seed_compare
# 1) Use diamond to compare all read files to the SEED fig.peg database
# 2) Merge all the best hits into a counts table

#Note: diamond is already in my path for running
#[mmacklai@agrajag map_seed]$ which diamond
#/Volumes/bin/diamond

#--------------------------------------------------------------------------
# Run all samples against the SEED database
#--------------------------------------------------------------------------


WD="/Volumes/data/A_n_L/2017_metagenomes/NS_00019/map_seed"
data="../data"
DB="/Volumes/data/SEED_database/subsys4.dmnd"
OUT="diamond_output/";

cd $WD
mkdir -p $WD/$OUT #Make this directory if it doesn't exist

for f in $data/*.gz; do	# e.g. F2G-3_S13_R1_001.fastq.gz

# Split on . and get the first field
	B=`basename $f`
	NAME=`echo $B | cut -d "_" -f1`

#	echo $B
#	echo $NAME
#	exit

#$DIAMOND blastx -d $DB -q ../data/sequence_files/F12_S17_L004_R2_001.fastq.gz -a diamond_output/F12_S17_L004_R2_001 --salltitles -k 3
	diamond blastx -d $DB -q $data/${f} -a diamond_output/${NAME} --salltitles -k 3
		# --salltitles           print full subject titles in output files
		# --max-target-seqs (-k) maximum number of target sequences to report alignments for
		# by default, diamond will use all available cores
	diamond view -a diamond_output/${NAME}.daa -o diamond_output/${NAME}.m8 #convert to blast tabular format

done

#example file names
#F2G-3_S13_R1_001.fastq.gz
#Field 2 "Good" timepoint 3

#--------------------------------------------------------------------------
# Get the best hits counts table
#--------------------------------------------------------------------------

for f in $OUT/*.m8; do

# Split on - and get the first field
	B=`basename $f .m8`
	NAME=`echo $B | cut -d "." -f1`

#	echo $NAME
#	exit

	./blast_to_counts.pl $f $NAME $OUT

done

#merge the count tables into one
	./merge_counts.pl $OUT > $OUT/all_counts.txt
	
#cleanup
mv $OUT/all_counts.txt ./
rm $OUT/*_counts.txt
mv all_counts.txt $OUT/all_counts.txt
