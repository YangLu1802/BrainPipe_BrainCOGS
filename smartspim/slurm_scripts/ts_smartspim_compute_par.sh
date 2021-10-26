#!/bin/env bash
#
#SBATCH -p all                # partition (queue)
#SBATCH -n 15                      # number of cores
#SBATCH -t 90					
#SBATCH -o logs/ts_compute_par_%j.out        # STDOUT #add _%a to see each array job
#SBATCH -e logs/ts_compute_par_%j.err        # STDERR #add _%a to see each array job

module load terastitcher/1.11.10
module load parastitcher/3.2.3

mpirun -np 15 parastitcher.py --displcompute --projin=${input_dir}/xml_import.xml \
 --subvoldim=100 --projout=/jukebox/wang/ahoag/test_stitching_mpi/data/xml_displcomp.xml 
