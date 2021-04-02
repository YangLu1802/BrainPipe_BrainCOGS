#!/usr/bin/env bash

job_id0=$(sbatch --parsable ./submit_sleep.sh)
echo ${job_id0}