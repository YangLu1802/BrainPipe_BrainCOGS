#!/bin/env bash
#
#SBATCH -p all                # partition (queue)
#SBATCH -c 12                 # number of cores
#SBATCH -t 150               # number of minutes 
#SBATCH -o logs/spim_pystripe_%j.out        # STDOUT #add _%a to see each array job
#SBATCH -e logs/spim_pystripe_%j.err        # STDERR #add _%a to see each array job

echo "In the directory: `pwd` "
echo "As the user: `whoami` "
echo "on host: `hostname` "

cat /proc/$$/status | grep Cpus_allowed_list

#required
module load anacondapy/2020.11
. activate lightsheet

echo "Input directory (path to stitched images):" "${input_dir}"
echo "Path to flat.tiff file generated using 'Generate Flat' software:" "${flat_filename_fullpath}"
echo "Output directory (does not need to exist):" "${output_dir}"
which pystripe

pystripe -i "${input_dir}" -f "${flat_filename_fullpath}" -o "${output_dir}"
