#!/bin/env bash

module load anacondapy/5.3.1
. activate lightsheet

echo "Experiment name / TeraStitcher folder hierarchy:" "$1"
echo "Storage directory:" "$2"

#import
OUT0=$(sbatch ts_smartspim_import.sh "$1")
echo $OUT0

#displacement computation
OUT1=$(sbatch --dependency=afterok:${OUT0##* } ts_smartspim_compute.sh "$1")
echo $OUT1

#thresholding
OUT2=$(sbatch --dependency=afterok:${OUT1##* } ts_smartspim_proj.sh "$1")
echo $OUT2

#merge
OUT3=$(sbatch --dependency=afterok:${OUT2##* } ts_smartspim_merge.sh "$1" "$2")
echo $OUT3

#functionality
#go to smartspim_pipeline folder and type sbatch spim_stitch.sh [path to terstitcher folder hierarchy] [destination of stitched directory]



