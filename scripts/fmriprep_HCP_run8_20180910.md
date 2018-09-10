#!/bin/bash
#SBATCH --nodes=1
#SBATCH --cpus-per-task=40
#SBATCH --time=11:00:00
#SBATCH --job-name fmriprep_hcp
#SBATCH --output=fmriprep_hcp_%j.txt

cd $SLURM_SUBMIT_DIR

module load singularity
module load gnu-parallel/20180322


export freesufer_license=$HOME/.licenses/freesurfer/license.txt
export fmriprep_container=/scinet/course/ss2018/3_bm/2_imageanalysis/singularity_containers/poldracklab_fmriprep_1.1.1-2018-06-07-2f08547a0732.img

## build the mounts
sing_home=/KIMEL/tigrlab/scratch/edickie
scratch_dir=/KIMEL/tigrlab/scratch/edickie/ciftify_paper/HCP

## yesterday, the phase runs didn't run properly because the IntendedFor field in jsons
## did not mention the func file.. so we try again
c_fmri  qc_recon_all  sub-100307  zz_templates
[edickie@dev02 ciftify]$ pwd
/KIMEL/tigrlab/scratch/edickie/ciftify_paper/HCP/output5_kandel/ciftify
[edickie@dev02 ciftify]$
187019              edicki
# Options we will run separately
# phase: (default usage)
# syn-sdc: --use-syn-sdc --ignore fieldmaps
# topup: (default usage) (w dir inputs)
# none: --ignore fieldmaps

```sh
ssh dev02
bids_dir=/KIMEL/tigrlab/scratch/edickie/ciftify_paper/HCP/output5_kandel/ciftify
outputdir=/KIMEL/tigrlab/scratch/edickie/saba_PINT/ciftify_fmriprep/
sing_home=/KIMEL/tigrlab/scratch/edickie/saba_PINT/sing_home
mkdir -p $sing_home


SIDlist=`cd ${bids_dir}; ls -1d sub* | sed 's/sub-//g'`
cd /KIMEL/tigrlab/scratch/edickie/saba_PINT/ciftify_fmriprep
mkdir -p ZHH/out ZHH/work ZHH/logs
cd $sing_home
for SID in $SIDlist; do
  subject=$SID
  echo singularity run -H ${sing_home}:/myhome \
    -B ${bids_dir}:/input \
    -B ${outputdir}:/output \
    -B /quarantine/Freesurfer/6.0.0/freesurfer/license.txt:/license_file.txt \
    /KIMEL/tigrlab/archive/code/containers/FMRIPREP_CIFTIFY/tigrlab_fmriprep_ciftify_1.1.2-2.0.9-2018-07-31-d0ccd31e74c5.img \
    /input /output/ZHH/out participant \
    --participant_label=$SID \
    --fmriprep-workdir /output/ZHH/work \
    --fs-license /license_file.txt \
    --n_cpus 4 \
    --fmriprep-args="--use-aroma"  | \
    qsub -l walltime=23:00:00,nodes=1:ppn=4 -N ciftify_$SID -j oe -o ${outputdir}/ZHH/logs;
done
```

# syn-sdc: --use-syn-sdc --ignore fieldmaps
ana_prefix="syn-sdc"
ana_flags="--use-syn-sdc --ignore fieldmaps"
mkdir -p ${scratch_dir}/work6/${ana_prefix}
mkdir -p ${scratch_dir}/output6/${ana_prefix}

echo "singularity run \
  -H ${sing_home} \
  -B ${scratch_dir}:/scratch \
  -B ${freesufer_license}:/freesurfer_license.txt \
  ${fmriprep_container} \
      /scratch/hcp_example_bids_v5_phase_nosbref /scratch/output2/${ana_prefix} participant \
      --nthreads 10 \
      --omp-nthreads 10 \
      --use-aroma \
      ${ana_flags} \
      --output-space T1w template \
      --work-dir /scratch/work6/${ana_prefix} \
      --no-submm-recon \
      --notrack --fs-license-file /freesurfer_license.txt" > jcmds_hcp.txt

# force-syn: --force-syn
ana_prefix="topup"
ana_flags=""
mkdir -p ${scratch_dir}/work2/${ana_prefix}
mkdir -p ${scratch_dir}/output2/${ana_prefix}
rsync -avL ${scratch_dir}/freesurfer ${scratch_dir}/output2/${ana_prefix}/
echo "singularity run \
  -H ${sing_home} \
  -B ${scratch_dir}:/scratch \
  -B ${freesufer_license}:/freesurfer_license.txt \
  ${fmriprep_container} \
      /scratch/hcp_example_bids_v5_dir_nosbref /scratch/output2/${ana_prefix} participant \
      --nthreads 10 \
      --omp-nthreads 10 \
      --use-aroma \
      ${ana_flags} \
      --output-space T1w template \
      --work-dir /scratch/work2/${ana_prefix} \
      --notrack --fs-license-file /freesurfer_license.txt" >> jcmds_hcp.txt

# none: --ignore fieldmaps
ana_prefix="none"
ana_flags="--ignore fieldmaps"
mkdir -p ${scratch_dir}/work2/${ana_prefix}
mkdir -p ${scratch_dir}/output2/${ana_prefix}
rsync -avL ${scratch_dir}/freesurfer ${scratch_dir}/output2/${ana_prefix}/
echo "singularity run \
  -H ${sing_home} \
  -B ${scratch_dir}:/scratch \
  -B ${freesufer_license}:/freesurfer_license.txt \
  ${fmriprep_container} \
      /scratch/hcp_example_bids_v5_phase_nosbref /scratch/output2/${ana_prefix} participant \
      --nthreads 10 \
      --omp-nthreads 10 \
      --use-aroma \
      ${ana_flags} \
      --output-space T1w template \
      --work-dir /scratch/work2/${ana_prefix} \
      --notrack --fs-license-file /freesurfer_license.txt" >> jcmds_hcp.txt

ana_prefix="phase"
ana_flags=""
mkdir -p ${scratch_dir}/work2/${ana_prefix}
mkdir -p ${scratch_dir}/output2/${ana_prefix}
rsync -avL ${scratch_dir}/freesurfer ${scratch_dir}/output2/${ana_prefix}/
echo "singularity run \
  -H ${sing_home} \
  -B ${scratch_dir}:/scratch \
  -B ${freesufer_license}:/freesurfer_license.txt \
  ${fmriprep_container} \
      /scratch/hcp_example_bids_v5_phase_nosbref /scratch/output2/${ana_prefix} participant \
      --nthreads 10 \
      --omp-nthreads 10 \
      --use-aroma \
      ${ana_flags} \
      --output-space T1w template \
      --work-dir /scratch/work2/${ana_prefix} \
      --notrack --fs-license-file /freesurfer_license.txt" >> jcmds_hcp.txt

parallel -j 4 :::: jcmds_hcp.txt
