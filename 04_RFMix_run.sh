#!/bin/bash
#PBS -N RFMix_run
#PBS -S /bin/bash
#PBS -l walltime=200:00:00
#PBS -l nodes=1:ppn=1
#PBS -l mem=16gb 
#PBS -o logs/${PBS_JOBNAME}.o${PBS_JOBID}.log
#PBS -e logs/${PBS_JOBNAME}.e${PBS_JOBID}.err
cd $PBS_O_WORKDIR

#calc RFMix for 6 pops
for pop in MXL PUR ACB ASW EVEN BRYC; do
  echo Now running ${pop}.
  /home/angela/anaconda2/bin/python 04_RFMix.py --ref_bcf /home/ryan/Local_ancestry/admixture-simulation/${pop}_simulation.ref.bcf.gz --query_vcf /home/ryan/Local_ancestry/admixture-simulation/${pop}_simulation_subset.query.recode.vcf --pop admixture_simulation/${pop}.txt
done
