#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
main.py -- Main module for running Light Sheet Microscope processing pipeline
"""

import os, sys, shutil
from xvfbwrapper import Xvfb; vdisplay = Xvfb(); vdisplay.start()
from tools.imageprocessing import preprocessing
from tools.registration.register import elastix_wrapper
from tools.utils.directorydeterminer import directorydeterminer
import pickle

def run_step0(output_directory,**params):
    # output_directory = '/jukebox/LightSheetData/lightserv_testing/ahoag/test/sample-001/output'
   
    #######################STEP 0 #######################
    #Make parameter dictionary and setup destination
    #####################################################
        
    ###make parameter dictionary and pickle file:
    preprocessing.generateparamdict(os.getcwd(), **params) 

def run_step1(jobid,**params):
    #######################STEP 1 #######################
    #Stitch and preprocess each z plane
    #####################################################
    if params["stitchingmethod"] not in ["terastitcher", "Terastitcher", "TeraStitcher"]:
        ###stitch based on percent overlap only ("dumb stitching"), and save files; showcelldetection=True: save out cells contours ovelaid on images
        preprocessing.arrayjob(jobid, cores=12, compression=1, **params) #process zslice numbers equal to slurmjobfactor*jobid thru (jobid+1)*slurmjobfactor
    else:
        #Stitch using Terastitcher "smart stitching"
        from tools.imageprocessing.stitch import terastitcher_from_params
        terastitcher_from_params(jobid=jobid, cores=6, **params)

def run_step1_check(**params):     
    #######################STEP 1 check##################
    #Check to make sure jobs weren"t lost - important if running on cluster
    #####################################################
    ###check to make sure all step 1 jobs completed properly
    preprocessing.process_planes_completion_checker(**params)
    
def run_step2(jobid,**params):
    #######################STEP 2 #######################
    #Consolidate for Registration
    #####################################################
    ###combine downsized ch and ch+cell files
    preprocessing.tiffcombiner(jobid, cores = 10, **params)
        
def run_step3(jobid,**params):        
    #######################STEP 3 #######################
    #Registration
    #####################################################
    elastix_wrapper(jobid, cores=12, **params) #run elastix
    vdisplay.stop()

if __name__ == '__main__':
    step = sys.argv[1]
    output_directory = sys.argv[2]
    param_file = output_directory + '/param_dict.p'
    jobid = int(os.environ["SLURM_ARRAY_TASK_ID"])
    print("step = {}, Jobid = {}".format(step,jobid))
    user = os.environ['USER']
    print(f"Running as user: {user}")
    with open(param_file,'rb') as pkl_file:
        params = pickle.load(pkl_file)
    print("Loaded params from %s" % param_file)
    print()

    if step == 'step0':
        run_step0(output_directory,**params)
    elif step == 'step1':
        run_step1(jobid=jobid,**params)
    elif step == 'step2':
        # jobid here is used as an index to loop over the number of volumes (channels)
        run_step2(jobid=jobid,**params)
    elif step == 'step3':
        

        # jobid here is used in the following way:
        # 0: 'normal registration'
        # 1: 'cellchannel inverse'
        # 2: 'injchannel inverse'
        # 3: 'genchannel' inverse
        # This should be updated so that it uses a string instead. 
        # Will be less confusing given that the way jobid works 
        # in the other steps is different.
        # Also it is a waste of resources to run array jobs if they don't need to be run
        # Currently the code is run with --array=0-3 and if there is no cell channel
        # Then nothing happens. But the resources are still allocated on spock even if nothing happens
        # and it counts against the user's karma
        run_step3(jobid=jobid,**params)
