#!/usr/bin/env bash

job_id0=$(sbatch --parsable ./submit_minimal.sh)
echo ${job_id0}
job_id1=$(sbatch --parsable --dependency=afterany:${job_id0} ./submit_minimal.sh)
echo ${job_id1}
job_id2=$(sbatch --parsable --dependency=afterany:${job_id1} ./submit_minimal.sh)
echo ${job_id2}
job_id3=$(sbatch --parsable --dependency=afterany:${job_id2} ./submit_minimal.sh)
echo ${job_id3}