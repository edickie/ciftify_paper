#!/bin/bash
#SBATCH --nodes=1
#SBATCH --cpus-per-task=80
#SBATCH --time=11:30:00
#SBATCH --job-name fmriprep_hcp
#SBATCH --output=fmriprep_hcp_%j.txt

cd $SLURM_SUBMIT_DIR

module load singularity
module load gnu-parallel/20180322


export freesufer_license=$HOME/.licenses/freesurfer/license.txt
export fmriprep_container=/scinet/course/ss2018/3_bm/2_imageanalysis/singularity_containers/poldracklab_fmriprep_1.1.1-2018-06-07-2f08547a0732.img

## build the mounts
sing_home=$SCRATCH/sing_home
scratch_dir=$SCRATCH/ciftify_paper/HCP

## yesterday, the phase runs didn't run properly because the IntendedFor field in jsons
## did not mention the func file.. so we try again

# Options we will run separately
# phase: (default usage)
# syn-sdc: --use-syn-sdc --ignore fieldmaps
# topup: (default usage) (w dir inputs)
# none: --ignore fieldmaps

ana_prefix="phase_switchdir"
ana_flags=""
mkdir -p ${scratch_dir}/work4/${ana_prefix}
mkdir -p ${scratch_dir}/output4/${ana_prefix}
# rsync -avL ${scratch_dir}/freesurfer ${scratch_dir}/output/${ana_prefix}/
singularity run \
  -H ${sing_home} \
  -B ${scratch_dir}:/scratch \
  -B ${freesufer_license}:/freesurfer_license.txt \
  ${fmriprep_container} \
      /scratch/hcp_example_bids_v5_phase_noT2w /scratch/output4/${ana_prefix} participant \
      --nthreads 80 \
      --omp-nthreads 80 \
      --use-aroma \
      ${ana_flags} \
      --output-space T1w template \
      --work-dir /scratch/work4/${ana_prefix} \
      --notrack --fs-license-file /freesurfer_license.txt
