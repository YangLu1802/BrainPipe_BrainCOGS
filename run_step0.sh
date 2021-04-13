#!/bin/env bash

# BASH script to just run step 0 of the light sheet pipeline
# for a hardcoded output_directory 
output_directory="/jukebox/LightSheetData/lightserv_testing/lightserv-test/two_channels/two_channels-001/imaging_request_1/output/processing_request_1/resolution_1.3x"
# figure out variables depending on input
# set up dictionary and save
OUT0=$(sbatch --parsable --export=ALL,output_directory=${output_directory} --array=0 slurm_files/step0.sh) 
echo $OUT0


# Usage notes:
# after = go once the specified job starts
# afterany = go if the specified job finishes, regardless of success
# afternotok = go if the specified job fails
# afterok = go if the specified job completes successfully
