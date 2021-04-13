#!/bin/bash
#
#SBATCH --job-name=test
#SBATCH --output=res_%j.txt
#
#SBATCH --ntasks=1
#SBATCH --time=0:005
#SBATCH --mem-per-cpu=1
#SBATCH -o logs/minimal_%j.out        # STDOUT
#SBATCH -e logs/minimal_%j.err        # STDERR

srun sleep 0.001
