#!/bin/bash
#
#SBATCH --ntasks=1
#SBATCH --time=1 # minutes
#SBATCH --nodes=1             # node count
#SBATCH -n 1                 # number of cores
#SBATCH --mem-per-cpu=1
#SBATCH -o logs/sleep_%j.out        # STDOUT
#SBATCH -e logs/sleep_%j.err        # STDERR

srun sleep 5
