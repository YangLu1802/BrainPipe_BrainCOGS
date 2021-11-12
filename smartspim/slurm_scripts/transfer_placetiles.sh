#!/bin/env bash
#
#SBATCH -p all                # partition (queue)
#SBATCH -c 1                     # number of cores
#SBATCH -t 5
#SBATCH -o logs/ts_transfer_%j.out        # STDOUT #add _%a to see each array job
#SBATCH -e logs/ts_transfer_%j.err        # STDERR #add _%a to see each array job

module load anacondapy/2020.11
. activate lightsheet

xvfb-run -d python spim_transfer.py ${raw_dir_ch1} ${raw_dir_ch2} 
