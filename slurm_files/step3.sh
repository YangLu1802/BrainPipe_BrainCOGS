#!/bin/env bash
#
#SBATCH -p all                # partition (queue)
#SBATCH -c 14                 # number of cores
#SBATCH -t 700                 # time (minutes)
#SBATCH -o logs/step3_%A_%a.out        # STDOUT
#SBATCH -e logs/step3_%A_%a.err        # STDERR
#SBATCH --contiguous #used to try and get cpu mem to be contigous


module load anacondapy/5.3.1
module load elastix/4.8
. activate lightsheet

xvfb-run -d python main.py step3 ${output_directory} ${SLURM_ARRAY_TASK_ID} # run elastix

# HOW TO USE:
# sbatch --array=0-20 sub_arrayjob.sh 
#sbatch --mail-type=END,FAIL      # notifications for job done & fail
#sbatch --mail-user=email@domain.edu # send-to address

