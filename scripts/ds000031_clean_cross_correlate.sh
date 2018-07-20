# so this is the plan...rest output we


ses-015_task-rest_run-001_force-syn/ses-015_task-rest_run-001_force-syn_Atlas_s0.dtseries.nii
ses-015_task-rest_run-001_none/ses-015_task-rest_run-001_none_Atlas_s0.dtseries.nii
ses-015_task-rest_run-001_phase/ses-015_task-rest_run-001_phase_Atlas_s0.dtseries.nii
ses-015_task-rest_run-001_syn-sdc/ses-015_task-rest_run-001_syn-sdc_Atlas_s0.dtseries.nii
ses-018_task-rest_run-001_force-syn/ses-018_task-rest_run-001_force-syn_Atlas_s0.dtseries.nii
ses-018_task-rest_run-001_none/ses-018_task-rest_run-001_none_Atlas_s0.dtseries.nii
ses-018_task-rest_run-001_phase/ses-018_task-rest_run-001_phase_Atlas_s0.dtseries.nii
ses-018_task-rest_run-001_syn-sdc/ses-018_task-rest_run-001_syn-sdc_Atlas_s0.dtseries.nii

left_surface=/scratch/edickie/ciftify_paper/ds000031/output/ciftify/sub-01/MNINonLinear/fsaverage_LR32k/sub-01.L.midthickness.32k_fs_LR.surf.gii
right_surface=/scratch/edickie/ciftify_paper/ds000031/output/ciftify/sub-01/MNINonLinear/fsaverage_LR32k/sub-01.R.midthickness.32k_fs_LR.surf.gii

ses015_confounds=/scratch/edickie/ciftify_paper/ds000031/output/phase/fmriprep/sub-01/ses-015/func/sub-01_ses-015_task-rest_run-001_bold_confounds.tsv
ses018_confounds=/scratch/edickie/ciftify_paper/ds000031/output/phase/fmriprep/sub-01/ses-018/func/sub-01_ses-018_task-rest_run-001_bold_confounds.tsv
clean_config=/home/edickie/code/ciftify/ciftify/data/cleaning_configs/24MP_8Phys_4GSR.json

# clean and smooth with 2mm fwhm
for anatype in "none" "phase" "syn-sdc"; do
ciftify_clean_img --clean-config=${clean_config} \
  --confounds-tsv=${ses015_confounds}\
  --smooth-fwhm=2 \
  --left-surface=${left_surface} \
  --right-surface=${right_surface} \
  ses-015_task-rest_run-001_${anatype}/ses-015_task-rest_run-001_${anatype}_Atlas_s0.dtseries.nii
done

for anatype in "none" "phase" "syn-sdc"; do
ciftify_clean_img --clean-config=${clean_config} \
  --confounds-tsv=${ses018_confounds}\
  --smooth-fwhm=2 \
  --left-surface=${left_surface} \
  --right-surface=${right_surface} \
  ses-018_task-rest_run-001_${anatype}/ses-018_task-rest_run-001_${anatype}_Atlas_s0.dtseries.nii
done
# calculate a dconn
for session in "018"; do
  for anatype in "none" "phase" "syn-sdc"; do
    wb_command -cifti-correlation \
      ses-${session}_task-rest_run-001_${anatype}/ses-${session}_task-rest_run-001_${anatype}_Atlas_s0_clean_s2.dtseries.nii \
      ses-${session}_task-rest_run-001_${anatype}/ses-${session}_task-rest_run-001_${anatype}_Atlas_s0_clean_s2.dconn.nii \
      -fisher-z
  done
done
# correlate the dcon vertexwise with teh rest..
wb_command -cifti-cross-correlation
ses-015_task-rest_run-001_none/ses-015_task-rest_run-001_none_Atlas_s0_clean_s2.dconn.nii
ses-015_task-rest_run-001_phase/ses-015_task-rest_run-001_phase_Atlas_s0_clean_s2.dconn.nii
