#!/bin/bash
#PBS -N ELAI_run
#PBS -S /bin/bash
#PBS -l walltime=200:00:00
#PBS -l nodes=1:ppn=1
#PBS -l mem=16gb 
#PBS -o logs/${PBS_JOBNAME}.o${PBS_JOBID}.log
#PBS -e logs/${PBS_JOBNAME}.e${PBS_JOBID}.err
cd $PBS_O_WORKDIR

#run ELAI
#MXL
bash 05_ELAI.sh --CEU sim_RFMix/CEU_MXL_ref.vcf.gz --NAT sim_RFMix/NAT_MXL_ref.vcf.gz --adm sim_RFMix/MXL.vcf.gz --out MXL

#PUR
bash 05_ELAI.sh --CEU sim_RFMix/CEU_PUR_ref.vcf.gz --NAT sim_RFMix/NAT_PUR_ref.vcf.gz --adm sim_RFMix/PUR.vcf.gz --out PUR

#ACB
bash 05_ELAI.sh --CEU sim_RFMix/CEU_ACB_ref.vcf.gz --YRI sim_RFMix/YRI_ACB_ref.vcf.gz --adm sim_RFMix/ACB.vcf.gz --out ACB

#ASW
bash 05_ELAI.sh --CEU sim_RFMix/CEU_ASW_ref.vcf.gz --YRI sim_RFMix/YRI_ASW_ref.vcf.gz --adm sim_RFMix/ASW.vcf.gz --out ASW

#EVEN
bash 05_ELAI.sh --CEU sim_RFMix/CEU_EVEN_ref.vcf.gz --YRI sim_RFMix/YRI_EVEN_ref.vcf.gz --NAT sim_RFMix/NAT_EVEN_ref.vcf.gz --adm sim_RFMix/EVEN.vcf.gz --out EVEN

#BRYC
bash 05_ELAI.sh --CEU sim_RFMix/CEU_BRYC_ref.vcf.gz --YRI sim_RFMix/YRI_BRYC_ref.vcf.gz --NAT sim_RFMix/NAT_BRYC_ref.vcf.gz --adm sim_RFMix/BRYC.vcf.gz --out BRYC
