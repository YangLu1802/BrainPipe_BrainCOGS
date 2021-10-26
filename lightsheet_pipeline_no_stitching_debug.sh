#!/bin/env bash

# BASH script to submit the light sheet pipeline all the way 
# through registration from lightserv
# for the non-stitching pipeline
output_directory=$1
n_array_jobs_step1=$2
# n_channels_total=$3

# figure out variables depending on input
max_array_job_step1=`echo ${n_array_jobs_step1} | awk '{print $1-1}'`
# max_array_job_step2and3=`echo ${n_channels_total} | awk '{print $1-1}'`
# set up dictionary and save
# OUT0=$(sbatch --parsable --export=ALL,output_directory=${output_directory} --array=0 slurm_files/step0.sh) 
# echo $OUT0

# #process zplns
# OUT1=$(sbatch --parsable --dependency=afterok:${OUT0##* } --export=ALL,output_directory=${output_directory} --array=0-${max_array_job_step1} slurm_files/step1.sh) 
# echo $OUT1
OUT1=$(sbatch --parsable --export=ALL,output_directory=${output_directory} --array=0-${max_array_job_step1} slurm_files/step1.sh) 
echo $OUT1

# #combine stacks into single tifffiles
# OUT2=$(sbatch --parsable --dependency=afterok:${OUT1##* } --export=ALL,output_directory=${output_directory} --array=0-${max_array_job_step2and3} slurm_files/step2.sh) 
# echo $OUT2

# run elastix
# OUT3=$(sbatch --parsable --export=ALL,output_directory=${output_directory} --array=1 slurm_files/step3_debug.sh) 
# echo $OUT3


# Usage notes:
# after = go once the specified job starts
# afterany = go if the specified job finishes, regardless of success
# afternotok = go if the specified job fails
# afterok = go if the specified job completes successfully
