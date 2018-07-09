#!/usr/bin/env bash

ciftify_recon_all \
  --n_cpus 4 \
  --ciftify-work-dir /scratch/edickie/ciftify_paper/HCP/output1/ciftify \
  --fs-subjects-dir /scratch/edickie/ciftify_paper/HCP/output1/phase_switchdir/freesurfer \
  --surf-reg MSMSulc sub-100307

cifti_vis_recon_all subject \
 --ciftify-work-dir /scratch/edickie/ciftify_paper/HCP/output1/ciftify \
 sub-100307

anatype="phase_switchdir"
ciftify_subject_fmri --n_cpus 4 \
  --ciftify-work-dir /scratch/edickie/ciftify_paper/HCP/output1/ciftify \
  --surf-reg MSMSulc \
  --OutputSurfDiagnostics \
  /scratch/edickie/ciftify_paper/HCP/output1/${anatype}/fmriprep/sub-100307/func/sub-100307_task-EMOTION_acq-LR_bold_space-T1w_preproc.nii.gz \
  sub-100307 \
  task-EMOTION_acq-LR_${anatype}

cifti_vis_fmri subject --ciftify-work-dir /scratch/edickie/ciftify_paper/HCP/output1/ciftify \
  task-EMOTION_acq-LR_${anatype} sub-100307
