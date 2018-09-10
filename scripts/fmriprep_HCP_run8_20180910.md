## run 2018-09-09 on the scc

```sh
ssh dev02
module load singularity/2.5.2
output_run="6scckandel"
fmriprep_container=/KIMEL/tigrlab/archive/code/containers/FMRIPREP/poldracklab_fmriprep_1.1.1-2018-06-07-2f08547a0732.img
scratch_dir=/KIMEL/tigrlab/scratch/edickie/ciftify_paper/HCP
sing_home=/KIMEL/tigrlab/scratch/edickie/ciftify_paper/sing_home
mkdir -p $sing_home


ana_prefix="syn-sdc"
ana_flags="--use-syn-sdc --ignore fieldmaps"
cd ${scratch_dir}
mkdir -p output${output_run}/${ana_prefix} work${output_run}/${ana_prefix} logs${output_run}
cd output${output_run}/${ana_prefix}
ln -s ../freesurfer freesurfer
cd $sing_home


echo "singularity run \
  -H ${sing_home} \
  -B ${scratch_dir}:/scratch \
  -B /quarantine/Freesurfer/6.0.0/freesurfer/license.txt:/license_file.txt \
  ${fmriprep_container} \
      /scratch/hcp_example_bids_v5_phase_nosbref /scratch/output${output_run}/${ana_prefix} participant \
      --nthreads 4 \
      --omp-nthreads 4 \
      --use-aroma \
      ${ana_flags} \
      --output-space T1w template \
      --work-dir /scratch/work${output_run}/${ana_prefix} \
      --no-submm-recon \
      --notrack --fs-license-file /license_file.txt" | \
      qsub -l walltime=6:00:00,nodes=1:ppn=4 -N fmriprep_HCP${ana_prefix} -j oe -o ${scratch_dir}/logs${output_run}


ana_prefix="topup"
ana_flags=""
cd ${scratch_dir}
mkdir -p output${output_run}/${ana_prefix} work${output_run}/${ana_prefix} logs${output_run}
cd output${output_run}/${ana_prefix}
ln -s ../freesurfer freesurfer
cd $sing_home


echo "singularity run \
  -H ${sing_home} \
  -B ${scratch_dir}:/scratch \
  -B /quarantine/Freesurfer/6.0.0/freesurfer/license.txt:/license_file.txt \
  ${fmriprep_container} \
      /scratch/hcp_example_bids_v5_dir_nosbref /scratch/output${output_run}/${ana_prefix} participant \
      --nthreads 4 \
      --omp-nthreads 4 \
      --use-aroma \
      ${ana_flags} \
      --output-space T1w template \
      --work-dir /scratch/work${output_run}/${ana_prefix} \
      --no-submm-recon \
      --notrack --fs-license-file /license_file.txt" | \
      qsub -l walltime=6:00:00,nodes=1:ppn=4 -N fmriprep_HCP${ana_prefix} -j oe -o ${scratch_dir}/logs${output_run}

# none: --ignore fieldmaps
ana_prefix="none"
ana_flags="--ignore fieldmaps"
cd ${scratch_dir}
mkdir -p output${output_run}/${ana_prefix} work${output_run}/${ana_prefix} logs${output_run}
cd output${output_run}/${ana_prefix}
ln -s ../freesurfer freesurfer
cd $sing_home


echo "singularity run \
  -H ${sing_home} \
  -B ${scratch_dir}:/scratch \
  -B /quarantine/Freesurfer/6.0.0/freesurfer/license.txt:/license_file.txt \
  ${fmriprep_container} \
      /scratch/hcp_example_bids_v5_phase_nosbref /scratch/output${output_run}/${ana_prefix} participant \
      --nthreads 4 \
      --omp-nthreads 4 \
      --use-aroma \
      ${ana_flags} \
      --output-space T1w template \
      --work-dir /scratch/work${output_run}/${ana_prefix} \
      --no-submm-recon \
      --notrack --fs-license-file /license_file.txt" | \
      qsub -l walltime=6:00:00,nodes=1:ppn=4 -N fmriprep_HCP${ana_prefix} -j oe -o ${scratch_dir}/logs${output_run}

ana_prefix="phase"
ana_flags=""
cd ${scratch_dir}
mkdir -p output${output_run}/${ana_prefix} work${output_run}/${ana_prefix} logs${output_run}
cd output${output_run}/${ana_prefix}
ln -s ../freesurfer freesurfer
cd $sing_home


echo "singularity run \
  -H ${sing_home} \
  -B ${scratch_dir}:/scratch \
  -B /quarantine/Freesurfer/6.0.0/freesurfer/license.txt:/license_file.txt \
  ${fmriprep_container} \
      /scratch/hcp_example_bids_v5_phase_nosbref /scratch/output${output_run}/${ana_prefix} participant \
      --nthreads 4 \
      --omp-nthreads 4 \
      --use-aroma \
      ${ana_flags} \
      --output-space T1w template \
      --work-dir /scratch/work${output_run}/${ana_prefix} \
      --no-submm-recon \
      --notrack --fs-license-file /license_file.txt" | \
      qsub -l walltime=6:00:00,nodes=1:ppn=4 -N fmriprep_HCP${ana_prefix} -j oe -o ${scratch_dir}/logs${output_run}
```
