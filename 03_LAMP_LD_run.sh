#!/bin/bash
#PBS -S /bin/bash
#PBS -l nodes=1:ppn=1
#PBS -o /home/ryan/logs/${PBS_JOBNAME}.o${PBS_JOBID}.log
#PBS -e /home/ryan/logs/${PBS_JOBNAME}.e${PBS_JOBID}.err
#PBS -l walltime=150:00:00
#PBS -l mem=16gb
pop=$1
~/scripts/run_LAMP \
--query ~/Local_ancestry/admixture-simulation/${pop}_simulation_subset.query.recode.vcf \
--ref ~/Local_ancestry/admixture-simulation/${pop}_simulation_subset.ref.bcf.gz \
--pos ~/Local_ancestry/maps/pruned_maps/${pop}_chr22.pos \
--pop ~/Local_ancestry/pop_codes/${pop}.txt \
--out ~/Local_ancestry/sim_LAMP/pruned_subset_${pop}
#/usr/bin/time  ~/enet_scripts/prune_testing/pop_train_combos_unpruned.R ${chr} ${pop}
