#!/bin/env bash


# Run pystripe.sh 
OUT0=$(sbatch --parsable --export=ALL,input_dir=$1,flat_filename_fullpath=$2,output_dir=$3 slurm_scripts/pystripe.sh)
echo $OUT0


