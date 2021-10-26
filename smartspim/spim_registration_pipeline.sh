#!/bin/env bash

# src='/jukebox/LightSheetData/lightserv/diamanti/SynGCaMP7_12/SynGCaMP7_12-001/imaging_request_2/rawdata/resolution_3.6x'
src='/jukebox/LightSheetData/lightserv/cz15/zimmerman_01/zimmerman_01-001/imaging_request_1/rawdata/resolution_3.6x'
reg='Ex_488_Em_0'
cell='Ex_642_Em_2'

# # normal registration
# OUT0=$(sbatch --parsable --export=ALL,src=${src},reg=${reg},cell=${cell} slurm_scripts/spim_register.sh)
# echo $OUT0

# inverse registration
OUT1=$(sbatch --parsable --export=ALL,src=${src},reg=${reg},cell=${cell} slurm_scripts/spim_inverse_register.sh)
echo $OUT1