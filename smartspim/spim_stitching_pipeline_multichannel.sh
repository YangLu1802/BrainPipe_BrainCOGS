#!/bin/env bash

# This script uses the result of one channel's computed displacements to apply 
# in the merge step for all other channels (up to 4 total channels)
# This is much faster than doing the compute displacements on each channel separately.
# It will also guarantee that all channels have the same dimensions and are aligned.
# We set the z displacement to 0 (--sD=0) in the compute step of CH1 since 
# The z planes in each tile should be stable according to LifeCanvas.

# Usage:
# ./spim_stitching_pipeline_multichannel.sh $num_channels $raw_dir_ch1 $stitched_dir_ch1 $raw_dir_ch2 $stitched_dir_ch2 ...
# E.g.
# ./spim_stitching_pipeline_multichannel.sh 3 rdir1 sdir1 rdir2 sdir2 rdir3 sdir3

# For however many channels you pass you need to also pass a raw dir and a stitched dir 
# The stitched dir is the directory where the stitched planes will be saved
# You can use between 1 and 4 channels. If you use 1 channel it will run the normal stitching pipeline
# Uses parastitcher for compute and merge steps so it is ~5-10x faster than our original stitching pipeline

len_array=$# # the number of arguments passed to this script
n_channels=$1
n_args_expected=$(( $n_channels*2 + 1 ))
if [[ ${len_array} != $n_args_expected ]]
then
	echo "Have wrong number of arguments. Expected $n_args_expected, but you provided ${len_array}."
	exit 1
fi

# echo "Have ${n_channels} channels"

raw_dir_ch1=$2
stitched_dir_ch1=$3
# echo $raw_dir_ch1
# echo $stitched_dir_ch1
### CH1 -- normal parallel stitching pipeline ###
# import ch1
OUT0_ch1=$(sbatch --parsable \
	--export=ALL,input_dir=${raw_dir_ch1},output_dir=${stitched_dir_ch1} \
	slurm_scripts/ts_smartspim_import.sh)
echo $OUT0_ch1

# # compute ch1
OUT1_ch1=$(sbatch --parsable --dependency=afterok:${OUT0_ch1##* } \
	--export=ALL,input_dir=${raw_dir_ch1},output_dir=${stitched_dir_ch1} \
	slurm_scripts/ts_smartspim_compute_par.sh)
echo $OUT1_ch1

# projection,thresholding,placing ch1
OUT2_ch1=$(sbatch --parsable --dependency=afterok:${OUT1_ch1##* } \
	--export=ALL,input_dir=${raw_dir_ch1},output_dir=${stitched_dir_ch1} \
	slurm_scripts/ts_smartspim_proj.sh)
echo $OUT2_ch1


# # merge ch1
OUT3_ch1=$(sbatch --parsable --dependency=afterok:${OUT2_ch1##* } \
	--export=ALL,input_dir=${raw_dir_ch1},output_dir=${stitched_dir_ch1} \
	slurm_scripts/ts_smartspim_merge_par.sh)
echo $OUT3_ch1



### CH2 -- modified stitching pipeline to use xml_placetiles ###
if [[ $n_channels > 1 ]]
then
	raw_dir_ch2=$4
	stitched_dir_ch2=$5
	# echo $raw_dir_ch2
	# echo $stitched_dir_ch2
	# import ch2, not dependent on anything
	OUT0_ch2=$(sbatch --parsable \
		--export=ALL,input_dir=${raw_dir_ch2},output_dir=${stitched_dir_ch2} \
		slurm_scripts/ts_smartspim_import.sh)
	echo $OUT0_ch2

	# Copy over placetiles file from ch1 raw folder to ch2 raw folder and modify it once out2_ch1 done
	# Dependent on step 2 of ch1. 
	OUT1_ch2=$(sbatch --parsable --dependency=afterok:${OUT2_ch1##* } \
		--export=ALL,raw_dir_ch1=${raw_dir_ch1},raw_dir_ch2=${raw_dir_ch2} \
		slurm_scripts/transfer_placetiles.sh)
	echo $OUT1_ch2


	# merge ch2 using transferred ch1 placetiles file
	# dependent on the transfer and the ch2 import step (since ch2 mdata.bin file gets created in ch2 import step)
	OUT2_ch2=$(sbatch --parsable --dependency=afterok:${OUT0_ch2##* }:${OUT1_ch2##* } \
		--export=ALL,input_dir=${raw_dir_ch2},output_dir=${stitched_dir_ch2} \
		slurm_scripts/ts_smartspim_merge_par.sh)
	echo $OUT2_ch2
fi

### CH3 -- modified stitching pipeline to use xml_placetiles ###

if [[ $n_channels > 2 ]]
then
	raw_dir_ch3=$6
	stitched_dir_ch3=$7
	### ch3 -- modified stitching pipeline to use xml_placetiles ###

	# import ch3, not dependent on anything
	OUT0_ch3=$(sbatch --parsable \
		--export=ALL,input_dir=${raw_dir_ch3},output_dir=${stitched_dir_ch3} \
		slurm_scripts/ts_smartspim_import.sh)
	echo $OUT0_ch3

	# Copy over placetiles file from ch1 raw folder to ch3 raw folder and modify it once out2_ch1 done
	# Dependent on step 2 of ch1. Note that in transfer_placetiles.sh 
	# the parameters are called raw_dir_ch1 and raw_dir_ch2 -- it just takes two folders 
	# and copies files between them. This raw_dir_ch2 is not to be confused with the raw_dir_ch2 in this script.
	# This is why we have raw_dir_ch2=${raw_dir_ch3} when we pass
	# in the parameter in below. 
	OUT1_ch3=$(sbatch --parsable --dependency=afterok:${OUT2_ch1##* } \
		--export=ALL,raw_dir_ch1=${raw_dir_ch1},raw_dir_ch2=${raw_dir_ch3} \ 
		slurm_scripts/transfer_placetiles.sh)
	echo $OUT1_ch3


	# merge ch3 using transferred ch1 placetiles file
	# dependent on the transfer and the ch3 import step (since ch3 mdata.bin file gets created in ch3 import step)
	OUT2_ch3=$(sbatch --parsable --dependency=afterok:${OUT0_ch3##* }:${OUT1_ch3##* } \
		--export=ALL,input_dir=${raw_dir_ch3},output_dir=${stitched_dir_ch3} \
		slurm_scripts/ts_smartspim_merge_par.sh)
	echo $OUT2_ch3
fi

### CH4 -- modified stitching pipeline to use xml_placetiles ###

if [[ $n_channels > 3 ]]
then
	raw_dir_ch4=$8
	stitched_dir_ch4=$9
	### ch4 -- modified stitching pipeline to use xml_placetiles ###

	# import ch4, not dependent on anything
	OUT0_ch4=$(sbatch --parsable \
		--export=ALL,input_dir=${raw_dir_ch4},output_dir=${stitched_dir_ch4} \
		slurm_scripts/ts_smartspim_import.sh)
	echo $OUT0_ch4

	# Copy over placetiles file from ch1 raw folder to ch4 raw folder and modify it once out2_ch1 done
	# Dependent on step 2 of ch1. Note that in transfer_placetiles.sh 
	# the parameters are called raw_dir_ch1 and raw_dir_ch2 -- it just takes two folders 
	# and copies files between them. This raw_dir_ch2 is not to be confused with the raw_dir_ch2 in this script.
	# This is why we have raw_dir_ch2=${raw_dir_ch4} when we pass
	# in the parameter in below. 
	OUT1_ch4=$(sbatch --parsable --dependency=afterok:${OUT2_ch1##* } \
		--export=ALL,raw_dir_ch1=${raw_dir_ch1},raw_dir_ch2=${raw_dir_ch4} \ 
		slurm_scripts/transfer_placetiles.sh)
	echo $OUT1_ch4


	# merge ch4 using transferred ch1 placetiles file
	# dependent on the transfer and the ch4 import step (since ch4 mdata.bin file gets created in ch4 import step)
	OUT2_ch4=$(sbatch --parsable --dependency=afterok:${OUT0_ch4##* }:${OUT1_ch4##* } \
		--export=ALL,input_dir=${raw_dir_ch4},output_dir=${stitched_dir_ch4} \
		slurm_scripts/ts_smartspim_merge_par.sh)
	echo $OUT2_ch4
fi

 