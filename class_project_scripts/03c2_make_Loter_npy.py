# -*- coding: utf-8 -*-
"""
Created on Fri Apr 19 10:11:42 2019
#run from the BIOI500_Local_Ancestry/ to convert .vcfs to .npy (Loter claims it can run straight from .vcf but it runs into an error)
@author: Angela
"""

import allel
import numpy as np

def vcf2npy(vcfpath): #converts a .vcf file to a numpy matrix w/ values 0, 1, and 2; https://github.com/bcm-uga/Loter/blob/master/python-package/Local_Ancestry_Example.ipynb
        callset = allel.read_vcf(vcfpath)
        haplotypes_1 = callset['calldata/GT'][:,:,0]
        haplotypes_2 = callset['calldata/GT'][:,:,1]
    
        m, n = haplotypes_1.shape
        mat_haplo = np.empty((2*n, m))
        mat_haplo[::2] = haplotypes_1.T
        mat_haplo[1::2] = haplotypes_2.T
    
        return mat_haplo.astype(np.uint8)

for cohort in ["80_20_6", "80_20_60", "50_50_6", "50_50_60"]:
    H_ceu = vcf2npy("sim_LAMPLD/" + cohort + "/CEU_ref.vcf")
    H_yri = vcf2npy("sim_LAMPLD/" + cohort + "/YRI_ref.vcf")
    H_adm = vcf2npy("admixture-simulation/admixed_" + cohort + "_gen.query.vcf")

    np.save("sim_Loter/" + cohort + "/CEU.npy", H_ceu)
    np.save("sim_Loter/" + cohort + "/YRI.npy", H_yri)
    np.save("sim_Loter/" + cohort + "/adm.npy", H_adm)
