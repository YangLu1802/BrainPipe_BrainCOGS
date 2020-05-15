#!/usr/bin/env bash

job_id0=$(sbatch --parsable --array=0 ./submit_sleep.sh)
echo ${job_id0}
job_id1=$(sbatch --parsable --dependency=afterany:${job_id0} --array=0-1 ./submit_sleep.sh)
echo ${job_id1}
job_id2=$(sbatch --parsable --dependency=afterany:${job_id1} --array=0-2 ./submit_sleep.sh)
echo ${job_id2}
