#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
main.py -- Main module for running Light Sheet Microscope processing pipeline
"""

import datajoint as dj
dj.config['database.host'] = 'braincogs00.pni.princeton.edu'
dj.config['database.user'] = 'ahoag'
dj.config['database.password'] = 'gaoha'


if __name__ == '__main__':
    db_lightsheet = dj.create_virtual_schema('ahoag_lightsheet_demo','ahoag_lightsheet_demo')

    output_directory = sys.argv[2]
    username,request_name,sample_name, = output_directory.split('/')[3:]
    param_file = output_directory + '/param_dict.p'
    jobid = int(os.environ["SLURM_ARRAY_TASK_ID"])
    print("step = {}, Jobid = {}".format(step,jobid))
    with open(param_file,'rb') as pkl_file:
        params = pickle.load(pkl_file)
    print("Loaded params from %s" % param_file)

    if step == 'step0':
        run_step0(output_directory,**params)
    elif step == 'step1':
        print("made it here")
        # run_step1(jobid=jobid,**params)
