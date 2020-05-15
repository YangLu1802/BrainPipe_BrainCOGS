#!/bin/bash
#
#SBATCH --ntasks=1
#SBATCH --time=1
#SBATCH --nodes=1             # node count
#SBATCH -n 1                 # number of cores
#SBATCH --mem-per-cpu=1
#SBATCH -o logs/badsleep_%j.out        # STDOUT
#SBATCH -e logs/badsleep_%j.err        # STDERR

srun sleep 5
srun slerrrp 5

