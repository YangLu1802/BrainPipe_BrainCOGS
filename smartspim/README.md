# README
## To run stitching pipeline (from terminal): 
./spim_stitching_pipeline.sh ${input_dir} ${output_dir}

- ${input_dir} is the full path to the tiled raw data directory for a single channel, e.g. /jukebox/LightSheetData/lightserv/gerardjb/Aldolase_C_Titration/Aldolase_C_Titration-1_50/imaging_request_1/rawdata/resolution_3.6x/Ex_488_Em_0/. This folder needs to contain no folders except for the ones containing the smartspim data, e.g. 
	- 107770/
	- 174950/      
	- 141360/             

- ${output_dir} is the path where you want to save the stitched data. Ideally, do not use output_dir = ${input_dir}/stitched/ because this will create the stitched/ folder inside ${input_dir}. If you need to re-run this pipeline for any reason it will fail for the reason that the only folders that can be present in ${input_dir} are the raw data subfolders.

Note that this is a BASH script, not an sbatch script. You don't need to put "sbatch" before the script name. This bash script calls four sbatch scripts, each of which launches a single slurm job. The sbatch scripts it calls live in slurm_scripts/ 
