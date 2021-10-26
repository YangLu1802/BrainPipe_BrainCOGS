#!/bin/env bash


# echo "Experiment name / TeraStitcher folder hierarchy:" "$1"
# echo "Storage directory:" "$2"

# # # import
OUT0=$(sbatch --parsable --export=ALL,input_dir=$1,output_dir=$2 slurm_scripts/ts_smartspim_import.sh)
echo $OUT0

# # # displacement computation
OUT1=$(sbatch --parsable --dependency=afterok:${OUT0##* } --export=ALL,input_dir=$1,output_dir=$2 slurm_scripts/ts_smartspim_compute_par.sh)
echo $OUT1

# # # projection,thresholding,placing
OUT2=$(sbatch --parsable --dependency=afterok:${OUT1##* } --export=ALL,input_dir=$1,output_dir=$2 slurm_scripts/ts_smartspim_proj.sh)
echo $OUT2

# # # # merge
OUT3=$(sbatch --parsable --dependency=afterok:${OUT2##* } --export=ALL,input_dir=$1,output_dir=$2 slurm_scripts/ts_smartspim_merge_par.sh)
echo $OUT3
