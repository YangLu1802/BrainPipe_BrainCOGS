#!/usr/bin/env bash

n_channels=$1

job_id0=$(sbatch --parsable ./submit_minimal.sh)
echo ${job_id0}
job_id1=$(sbatch --parsable --dependency=afterany:${job_id0} ./submit_minimal.sh)
echo ${job_id1}
job_id2=$(sbatch --parsable --dependency=afterany:${job_id1} ./submit_minimal.sh)
echo ${job_id2}
job_id3=$(sbatch --parsable --dependency=afterany:${job_id2} ./submit_minimal.sh)
echo ${job_id3}

if [[ $n_channels > 1 ]]
then
	job_id4=$(sbatch --parsable ./submit_minimal.sh)
	echo ${job_id4}
	job_id5=$(sbatch --parsable --dependency=afterany:${job_id4} ./submit_minimal.sh)
	echo ${job_id5}
	job_id6=$(sbatch --parsable --dependency=afterany:${job_id5} ./submit_minimal.sh)
	echo ${job_id6}
fi

if [[ $n_channels > 2 ]]
then
	job_id7=$(sbatch --parsable ./submit_minimal.sh)
	echo ${job_id7}
	job_id8=$(sbatch --parsable --dependency=afterany:${job_id7} ./submit_minimal.sh)
	echo ${job_id8}
	job_id9=$(sbatch --parsable --dependency=afterany:${job_id8} ./submit_minimal.sh)
	echo ${job_id9}
fi

if [[ $n_channels > 3 ]]
then
	job_id10=$(sbatch --parsable ./submit_minimal.sh)
	echo ${job_id10}
	job_id11=$(sbatch --parsable --dependency=afterany:${job_id10} ./submit_minimal.sh)
	echo ${job_id11}
	job_id12=$(sbatch --parsable --dependency=afterany:${job_id11} ./submit_minimal.sh)
	echo ${job_id12}
fi

