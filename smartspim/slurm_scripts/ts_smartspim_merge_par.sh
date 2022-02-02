#!/bin/env bash
#
#SBATCH -p all                # partition (queue)
#SBATCH -n 15                      # number of cores
#SBATCH -t 200					
#SBATCH -o logs/ts_merge_par_%j.out        # STDOUT #add _%a to see each array job
#SBATCH -e logs/ts_merge_par_%j.err        # STDERR #add _%a to see each array job
#SBATCH --mem 100000

module load terastitcher/1.11.10
module load parastitcher/3.2.3

cd ${input_dir}
output_subdir=`echo ${output_dir%/} | awk -F/ '{print $NF}'` # the %/ removes the trailing slash if there is one
echo "output subdir:"
echo $output_subdir
mpirun -np 15 parastitcher.py -6 --projin=./xml_placetiles.xml \
 --volout=../${output_subdir} --resolutions=0 \
 --sliceheight=50000 --slicewidth=50000 --slicedepth=1


## NOTE: sliceheight and slicewidth are intentionally larger than true x and y dimensions
## This is done because we don't know the exact dimensions ahead of time
## but the code will use the correct dimensions if you supply values that are larger than the true values
## See: https://github.com/abria/TeraStitcher/issues/76