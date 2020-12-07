# README
## To run stitching pipeline (from terminal): 
./spim_stitching_pipeline.sh ${input_dir} ${output_dir}

This is a BASH script, not an sbatch script, so you don't need to put "sbatch" before it. This bash script calls four sbatch scripts, each of which launches a single slurm job. The sbatch scripts are in slurm_scripts/ 
