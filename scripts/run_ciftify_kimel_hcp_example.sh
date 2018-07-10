#!/usr/bin/env bash

# ciftify_recon_all \
#   --n_cpus 4 \
#   --ciftify-work-dir /scratch/edickie/ciftify_paper/HCP/output/ciftify \
#   --fs-subjects-dir /scratch/edickie/ciftify_paper/HCP/output/phase_switchdir/freesurfer \
#   --surf-reg MSMSulc sub-100307
#
# cifti_vis_recon_all subject \
#  --ciftify-work-dir /scratch/edickie/ciftify_paper/HCP/output/ciftify \
#  sub-100307

for anatype in none syn-sdc topup phase_switchdir; do
echo ciftify_subject_fmri --n_cpus 4 \
  --ciftify-work-dir /scratch/edickie/ciftify_paper/HCP/output/ciftify \
  --surf-reg MSMSulc \
  --T1w-anat /scratch/edickie/ciftify_paper/HCP/output/${anatype}/fmriprep/sub-100307/anat/sub-100307_T1w_preproc.nii.gz \
  /scratch/edickie/ciftify_paper/HCP/output/${anatype}/fmriprep/sub-100307/func/sub-100307_task-EMOTION_acq-LR_bold_space-T1w_preproc.nii.gz \
  sub-100307 \
  task-EMOTION_acq-LR_${anatype}

echo cifti_vis_fmri subject --ciftify-work-dir /scratch/edickie/ciftify_paper/HCP/output/ciftify \
  task-EMOTION_acq-LR_${anatype} sub-100307
done
