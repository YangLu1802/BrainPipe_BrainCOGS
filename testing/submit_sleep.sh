#!/bin/bash
#
#SBATCH --ntasks=1
#SBATCH --time=1 # minutes
#SBATCH --nodes=1             # node count
#SBATCH -n 1                 # number of cores
#SBATCH --mem-per-cpu=1
#SBATCH -o logs/sleep.out        # STDOUT
#SBATCH -e logs/sleep.err        # STDERR

srun sleep 0.05
