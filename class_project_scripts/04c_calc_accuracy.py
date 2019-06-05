# -*- coding: utf-8 -*-
"""
Created on Fri Apr 19 14:22:35 2019
#measure the accuracy of each software
@author: Angela
"""
from __future__ import division
import csv
import numpy as np
import pandas as pd
import statistics

def hap2dos(hap_in): #convert haplotypes (ans, LAMP-LD, RFMix) to dosage format (ELAI)
    hap_in = hap_in.copy()
    hap_in.index = rsids
    dos = []
    for rsid in rsids:
        dos_row_CEU = [rsid + "_CEU"]
        dos_row_YRI = [rsid + "_YRI"]
        for ind in ind_list: #extract haplotypes; https://github.com/aandaleon/Ad_PX_pipe/blob/master/15a_RFMix_to_BIMBAM.py
            hap_A = ind + ".0"
            hap_B = ind + ".1"
            YRI = hap_in.loc[rsid, hap_A] + hap_in.loc[rsid, hap_B]
            CEU = 2 - YRI
            dos_row_CEU.append(CEU)
            dos_row_YRI.append(YRI)
        dos.append(dos_row_CEU)
        dos.append(dos_row_YRI)
    dos = pd.DataFrame(dos).set_index(0, drop = True)
    dos.columns = ELAI.columns
    return dos

def calc_accuracy(ans_in, method_in):
    method_eq = ans_in.eq(method_in) #equal to of dataframe and other, element wise; https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.eq.html#pandas.DataFrame.eq
    #acc = sum(method_eq.sum() / len(method_eq.index)) / len(method_eq.columns) #get avg accuracy for each person and avg over all
    acc = statistics.median(method_eq.sum() / len(method_eq.index)) #get median accuracy for each person and avg over all
    return acc

print("Starting calculation of accuracies in LAMPLD, RFMix, and ELAI.")
acc_results = []
for cohort in ["80_20_6", "80_20_60", "50_50_6", "50_50_60"]:
    print("Beginning calculating accuracy in " + cohort + ".")
    
    #load in answer and rs data
    rsids = np.loadtxt("admixture-simulation/admixed_snps.txt", dtype = str)
    ans = pd.read_csv("admixture-simulation/admixed_" + cohort + "_gen.result", delim_whitespace = True).drop("chm", axis = 1).drop("pos", axis = 1) #2 = YRI, 1 = CEU
    ans = ans.replace({1:0}).replace({2:1})
    ind_list = []
    haps = ans.columns
    for hap_i in range(0, len(ans.columns)):
        if hap_i % 2 == 0:
            ind_list.append(ans.columns[hap_i][:-2])
    #change all pop codes to 1 = YRI, 0 = CEU
    
    #LAMPLD
    LAMPLD = pd.read_fwf("sim_LAMPLD/" + cohort + "/admixed_est.long", widths = [1] * len(ans), header = None).transpose()
    LAMPLD.columns = haps
        #1 = YRI, 0 = CEU

    #RFMix is being read in super super weird so I have to do it in a convoluted way
    csvfile = open("sim_RFMix/" + cohort + "/results.0.Viterbi.txt")
    RFMix_csv = csv.reader(csvfile, delimiter = " ")
    RFMix = []
    for row in RFMix_csv:
        RFMix.append(row)
    RFMix = pd.DataFrame(RFMix).drop(40, axis = 1)
    RFMix = RFMix.apply(pd.to_numeric)
    RFMix = RFMix.replace({1:0}).replace({2:1})
    RFMix.columns = haps
    
    #ELAI in dosage format, change everything to match dosage
    ELAI = pd.read_csv("sim_ELAI/" + cohort + "/results.txt", delim_whitespace = True, header = None).transpose().round() #round all ELAI to 0, 1, 2
    rsid_pop = []
    for rsid in rsids:
        for pop in ["CEU", "YRI"]:
            rsid_pop.append(rsid + "_" + pop)
    ELAI.index = rsid_pop
    ELAI.columns = ind_list
    
    #Convert to overall ancestry dosages (see ELAI)
    ans = hap2dos(ans)
    LAMPLD = hap2dos(LAMPLD)
    RFMix = hap2dos(RFMix)
    
    #Measure accuracy of each method and store
    acc_results.append([cohort, calc_accuracy(ans, LAMPLD), calc_accuracy(ans, RFMix), calc_accuracy(ans, ELAI)])
    print("Completed calculating accuracy in " + cohort + ".")
acc_results = pd.DataFrame(acc_results)
acc_results.columns = ["cohort", "LAMPLD", "RFMix", "ELAI"]
acc_results.to_csv("acc_results_median_1.csv", index = False)
print("Completed calculation of accuracies in LAMPLD, RFMix, and ELAI. Have a nice day :).")
