#!/bin/env bash
#
#SBATCH -p all                # partition (queue)
#SBATCH -n 15                      # number of cores
#SBATCH -t 90					
#SBATCH -o logs/ts_compute_par_%j.out        # STDOUT #add _%a to see each array job
#SBATCH -e logs/ts_compute_par_%j.err        # STDERR #add _%a to see each array job
#SBATCH --mem 100000

module load terastitcher/1.11.10
module load parastitcher/3.2.3

cd ${input_dir}
mpirun -np 15 parastitcher.py -2 --projin=./xml_import.xml --projout=./xml_displcomp.xml --subvoldim=100
