#!/bin/bash
#SBATCH --nodes=1
#SBATCH --cpus-per-task=40
#SBATCH --time=6:00:00
#SBATCH --job-name fmriprep_ds000031
#SBATCH --output=fmriprep_ds000031_%j.txt

cd $SLURM_SUBMIT_DIR

module load singularity
module load gnu-parallel/20180322

# # things that were run to download and set-up the dataset 2018-06-23
# singularity run -B $SCRATCH/datalad:/scratch /scinet/course/ss2018/3_bm/8_publicdataneuro/datalad-datalad-master-fullmaster.simg install -s ///openfmri/ds000031 /scratch/datalad/ds000031
# singularity run -B $SCRATCH/datalad:/scratch /scinet/course/ss2018/3_bm/8_publicdataneuro/datalad-datalad-master-fullmaster.simg get /scratch/datalad/ds000031/derivatives/fmriprep_1.0.0/freesurfer/
# singularity run -B $SCRATCH/datalad:/scratch /scinet/course/ss2018/3_bm/8_publicdataneuro/datalad-datalad-master-fullmaster.simg get /scratch/datalad/ds000031/sub-01/ses-015/
# singularity run -B $SCRATCH/datalad:/scratch /scinet/course/ss2018/3_bm/8_publicdataneuro/datalad-datalad-master-fullmaster.simg get /scratch/datalad/ds000031/sub-01/ses-018/
# mkdir $SCRATCH/ciftify_paper/ds000031/bids/sub-01
# rsync -avL $SCRATCH/datalad/datalad/ds000031/*.json $SCRATCH/ciftify_paper/ds000031/bids/
# rsync -avL $SCRATCH/datalad/datalad/ds000031/sub-01/ses-015 $SCRATCH/ciftify_paper/ds000031/bids/sub-01/
# rsync -avL $SCRATCH/datalad/datalad/ds000031/sub-01/ses-018 $SCRATCH/ciftify_paper/ds000031/bids/sub-01/


dataset="ds000031"
export freesufer_license=$HOME/.licenses/freesurfer/license.txt
export fmriprep_container=/scinet/course/ss2018/3_bm/2_imageanalysis/singularity_containers/poldracklab_fmriprep_1.1.1-2018-06-07-2f08547a0732.img

## build the mounts
sing_home=$SCRATCH/sing_home
scratch_dir=$SCRATCH/ciftify_paper/ds000031



# Options we will run separately
# phase: (default usage)
# syn-sdc: --use-syn-sdc --ignore fieldmaps
# force-syn: --force-syn --use-syn-sdc
# none: --ignore fieldmaps

ana_prefix="phase"
ana_flags=""
mkdir -p ${scratch_dir}/work/${ana_prefix}
mkdir -p ${scratch_dir}/output/${ana_prefix}
rsync -avL ${scratch_dir}/pre_derivatives/freesurfer ${scratch_dir}/output/${ana_prefix}/
echo "singularity run \
  -H ${sing_home} \
  -B ${scratch_dir}:/scratch \
  -B ${freesufer_license}:/freesurfer_license.txt \
  ${fmriprep_container} \
      /scratch/bids /scratch/output/${ana_prefix} participant \
      --nthreads 10 \
      --omp-nthreads 10 \
      --use-aroma \
      ${ana_flags} \
      --output-space T1w template \
      --work-dir /scratch/work/${ana_prefix} \
      --notrack --fs-license-file /freesurfer_license.txt" > jcmds_ds000031.txt

# syn-sdc: --use-syn-sdc --ignore fieldmaps
ana_prefix="syn-sdc"
ana_flags="--use-syn-sdc --ignore fieldmaps"
mkdir -p ${scratch_dir}/work/${ana_prefix}
mkdir -p ${scratch_dir}/output/${ana_prefix}
rsync -avL ${scratch_dir}/pre_derivatives/freesurfer ${scratch_dir}/output/${ana_prefix}/
echo "singularity run \
  -H ${sing_home} \
  -B ${scratch_dir}:/scratch \
  -B ${freesufer_license}:/freesurfer_license.txt \
  ${fmriprep_container} \
      /scratch/bids /scratch/output/${ana_prefix} participant \
      --nthreads 10 \
      --omp-nthreads 10 \
      --use-aroma \
      ${ana_flags} \
      --output-space T1w template \
      --work-dir /scratch/work/${ana_prefix} \
      --notrack --fs-license-file /freesurfer_license.txt" >> jcmds_ds000031.txt

# none: --ignore fieldmaps
ana_prefix="none"
ana_flags="--ignore fieldmaps"
mkdir -p ${scratch_dir}/work/${ana_prefix}
mkdir -p ${scratch_dir}/output/${ana_prefix}
rsync -avL ${scratch_dir}/pre_derivatives/freesurfer ${scratch_dir}/output/${ana_prefix}/
echo "singularity run \
  -H ${sing_home} \
  -B ${scratch_dir}:/scratch \
  -B ${freesufer_license}:/freesurfer_license.txt \
  ${fmriprep_container} \
      /scratch/bids /scratch/output/${ana_prefix} participant \
      --nthreads 10 \
      --omp-nthreads 10 \
      --use-aroma \
      ${ana_flags} \
      --output-space T1w template \
      --work-dir /scratch/work/${ana_prefix} \
      --notrack --fs-license-file /freesurfer_license.txt" >> jcmds_ds000031.txt

# force-syn: --force-syn
ana_prefix="force-syn"
ana_flags="--force-syn"
mkdir -p ${scratch_dir}/work/${ana_prefix}
mkdir -p ${scratch_dir}/output/${ana_prefix}
rsync -avL ${scratch_dir}/pre_derivatives/freesurfer ${scratch_dir}/output/${ana_prefix}/
echo "singularity run \
  -H ${sing_home} \
  -B ${scratch_dir}:/scratch \
  -B ${freesufer_license}:/freesurfer_license.txt \
  ${fmriprep_container} \
      /scratch/bids /scratch/output/${ana_prefix} participant \
      --nthreads 10 \
      --omp-nthreads 10 \
      --use-aroma \
      ${ana_flags} \
      --output-space T1w template \
      --work-dir /scratch/work/${ana_prefix} \
      --notrack --fs-license-file /freesurfer_license.txt" >> jcmds_ds000031.txt

parallel -j 4 :::: jcmds_ds000031.txt
