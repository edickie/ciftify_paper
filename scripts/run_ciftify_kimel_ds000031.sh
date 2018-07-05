#!/bin/bash

## running on kandel 2018-07-04 using ciftify's new run.py to help develop the commands

ciftify_recon_all --n_cpus 4 --ciftify-work-dir /scratch/edickie/ciftify_paper/ds000031/output/ciftify --fs-subjects-dir /scratch/edickie/ciftify_paper/ds000031/output/phase/freesurfer --surf-reg MSMSulc sub-01

cifti_vis_recon_all subject --ciftify-work-dir /scratch/edickie/ciftify_paper/ds000031/output/ciftify sub-01

for anatype in force-syn none phase	reports syn-sdc; do
ciftify_subject_fmri --n_cpus 4 --ciftify-work-dir /scratch/edickie/ciftify_paper/ds000031/output/ciftify --surf-reg MSMSulc \
  /scratch/edickie/ciftify_paper/ds000031/output/${anatype}/fmriprep/sub-01/ses-015/func/sub-01_ses-015_task-rest_run-001_bold_space-T1w_preproc.nii.gz \
  sub-01 ses-015_task-rest_run-001_${anatype}

cifti_vis_fmri subject --ciftify-work-dir /scratch/edickie/ciftify_paper/ds000031/output/ciftify ses-015_task-rest_run-001_${anatype} sub-01

ciftify_subject_fmri --n_cpus 4 --ciftify-work-dir /scratch/edickie/ciftify_paper/ds000031/output/ciftify --surf-reg MSMSulc \
  /scratch/edickie/ciftify_paper/ds000031/output/${anatype}/fmriprep/sub-01/ses-018/func/sub-01_ses-018_task-rest_run-001_bold_space-T1w_preproc.nii.gz \
  sub-01 ses-018_task-rest_run-001_${anatype}

cifti_vis_fmri subject --ciftify-work-dir /scratch/edickie/ciftify_paper/ds000031/output/ciftify ses-018_task-rest_run-001_${anatype} sub-01

done
