#calculate accuracy of the results from LAMP-LD, RFMix, and ELAI
#python3 06_calc_accuracy.py --LAMPLD.long /home/ryan/Local_ancestry/sim_LAMP/MXL_pruned/pruned_subset_MXLadmixed_est.long --LAMPLD.haps.hap.gz /home/ryan/Local_ancestry/sim_LAMP/MXL_pruned/pruned_subset_MXLadmixed.haps.hap.gz --RFMix.rfmix.2.Viterbi.txt sim_RFMix_pruned_6-11-19/results/MXL.rfmix.2.Viterbi.txt --RFMix.snps sim_RFMix_pruned_6-11-19/MXL.snps --ELAI.results.txt sim_ELAI_pruned_6-12-19/results/MXL.results.txt --ELAI.recode.pos.txt sim_ELAI_pruned_6-12-19/MXL.recode.pos.txt --pop admixture_simulation/MXL.txt --result /home/ryan/Local_ancestry/sim_LAMP/admixture-simulation/MXL_simulation.result --genetic-map chr22.interpolated_genetic_map --out MXL
from __future__ import division
import argparse
import csv
import numpy as np
import pandas as pd
import statistics

#take in data from softwares to convert
parser = argparse.ArgumentParser()
parser.add_argument("--LAMPLD.long", type = str, action = "store", dest = "LAMPLD_long", required = True, help = "Output from LAMP-LD. Ends in '.long'.")
parser.add_argument("--LAMPLD.haps.hap.gz", type = str, action = "store", dest = "LAMPLD_haps_hap_gz", required = True, help = "Precursor to input from LAMP-LD of the admixed population. Ends in '.haps.hap.gz'.")
parser.add_argument("--RFMix.rfmix.2.Viterbi.txt", type = str, action = "store", dest = "RFMix_Viterbi", required = True, help = "Output from RFMix. Ends in '.rfmix.2.Viterbi.txt'.")
parser.add_argument("--RFMix.snps", type = str, action = "store", dest = "RFMix_snps", required = True, help = "Precursor to input from RFMix of the SNP IDs included in analysis. Ends in '.snps'.")
#parser.add_argument("--RFMix.vcf_ids.txt", type = str, action = "store", dest = "RFMix_vcf_ids", required = True, help = "IDs of individuals in the merged vcf file. Ends in '.vcf_ids.txt'.")
#parser.add_argument("--RFMix.classes", type = str, action = "store", dest = "RFMix_classes", required = True, help = ".classes input of RFMix")
parser.add_argument("--ELAI.results.txt", type = str, action = "store", dest = "ELAI_results", required = True, help = "Output from ELAI. Ends in '.results.txt'.")
parser.add_argument("--ELAI.recode.pos.txt", type = str, action = "store", dest = "ELAI_pos", required = True, help = "Input to ELAI that includes chr, rsid, and pos of SNPs. Ends in '.recode.pos.txt'.")
parser.add_argument("--pop", type = str, action = "store", dest = "pop", required = True, help = "Pop code file that was input into admixture-simulation.py")
parser.add_argument("--result", type = str, action = "store", dest = "result", required = True, help = "True local ancestry output by admixture-simulation.py. Ends in '.result'")
parser.add_argument("--genetic-map", type = str, action = "store", dest = "genetic_map", required = True, help = "Interpolated genetic map file from https://github.com/joepickrell/1000-genomes-genetic-maps.")
parser.add_argument("--out", type = str, action = "store", dest = "out", required = True, help = "Prefix for accuracy output. Use population name (Ex. 'MXL').")
args = parser.parse_args() #then pass these arguments to further things

LAMPLD_long = args.LAMPLD_long
LAMPLD_haps_hap_gz = args.LAMPLD_haps_hap_gz
RFMix_Viterbi = args.RFMix_Viterbi
RFMix_snps = args.RFMix_snps
#RFMix_vcf_ids = args.RFMix_vcf_ids
#RFMix_classes = args.RFMix_classes
ELAI_results = args.ELAI_results
ELAI_pos = args.ELAI_pos
pop_file = args.pop
result_file = args.result
genetic_map_file = args.genetic_map
out = args.out

def hap2dos(hap_in): #convert haplotypes (ans, LAMP-LD, RFMix) to dosage format (ELAI)
    #hap_in = ans_pos
    hap_in = hap_in.copy()
    dos = []
    if pop["anc_code"].values.max() == 2: #number of rows to make; two way admixture
        for index_id in hap_in.index:
            row_1 = []
            row_2 = []
            for ind in ind_list: #extract haplotypes; https://github.com/aandaleon/Ad_PX_pipe/blob/master/15a_RFMix_to_BIMBAM.py
                hap_A = ind + ".0"
                hap_B = ind + ".1"
                anc1 = 0 #dosage of an ancestry
                anc2 = 0
                if hap_in.loc[index_id, hap_A] == 1:
                    anc1 += 1
                else: #second anc
                    anc2 += 1
                if hap_in.loc[index_id, hap_B] == 1:
                    anc1 += 1
                else: #second anc
                    anc2 += 1
                row_1.append(anc1)
                row_2.append(anc2)
            dos.append(row_1)
            dos.append(row_2)
    if pop["anc_code"].values.max() == 3: #three way admixture
        for index_id in hap_in.index:
            row_1 = []
            row_2 = []
            row_3 = []
            for ind in ind_list: #extract haplotypes; https://github.com/aandaleon/Ad_PX_pipe/blob/master/15a_RFMix_to_BIMBAM.py
                hap_A = ind + ".0"
                hap_B = ind + ".1"
                anc1 = 0 #dosage of an ancestry
                anc2 = 0
                anc3 = 0
                if hap_in.loc[index_id, hap_A] == 1:
                    anc1 += 1
                elif hap_in.loc[index_id, hap_A] == 2: #second anc
                    anc2 += 1
                else: #third anc
                    anc3 += 1
                if hap_in.loc[index_id, hap_B] == 1:
                    anc1 += 1
                elif hap_in.loc[index_id, hap_B] == 2: #second anc
                    anc2 += 1
                else: #third anc
                    anc3 += 1
                row_1.append(anc1)
                row_2.append(anc2)
                row_3.append(anc3)
            dos.append(row_1)
            dos.append(row_2)
            dos.append(row_3)
    dos = pd.DataFrame(dos)
    
    #reassign SNPs by ancestry
    id_pop = [] #by SNP then ancestry
    for SNP in hap_in.index: #SNP is either base pair or rsid
        for pop_i in pop["anc"].drop_duplicates(): #get in the right order
            id_pop.append(str(SNP) + "_" + pop_i)
    dos.index = id_pop
    dos.columns = ind_list #rows are SNPs, cols are inds
    dos = dos.astype(int) #simplify by keeping everything integers
    return dos

def calc_accuracy(ans_in, method_in):
    #ans_in = ans_pos
    #method_in = LAMPLD
    ans_in = ans_in.reindex(method_in.index) #only keep shared rows between methods
    cors = ans_in.corrwith(method_in).dropna() #correlations between true and estimated
    med_R2 = statistics.median(np.square(cors))
    mean_R2 = statistics.mean(np.square(cors))
    return med_R2, mean_R2

#test data
'''
LAMPLD_long = "sim_LAMPLD/pruned_subset_ASWadmixed_est.long"
LAMPLD_haps_hap_gz = "sim_LAMPLD/pruned_subset_ASWadmixed.haps.hap.gz"
RFMix_Viterbi = "sim_RFMix_pruned_6-11-19/results/ASW.rfmix.2.Viterbi.txt"
RFMix_snps = "sim_RFMix_pruned_6-11-19/ASW.snps"
#RFMix_vcf_ids = "sim_RFMix_pruned_6-11-19/ASW_merged.vcf_ids.txt"
#RFMix_classes = "sim_RFMix_pruned_6-11-19/ASW.classes"
genetic_map_file = "chr22.interpolated_genetic_map"
ELAI_results = "sim_ELAI_pruned_6-12-19/results/ASW.results.txt"
ELAI_pos = "sim_ELAI_pruned_6-12-19/ASW.recode.pos.txt"
pop_file = "admixture_simulation/ASW.txt"
result_file = "ASW_simulation.result"
out = "ASW"
'''

print("Starting calculation of accuracies in LAMPLD, RFMix, and ELAI in " + out + ".")

#load in answer and rs data
ans_pos = pd.read_csv(result_file, delim_whitespace = True).drop("chm", axis = 1)
ans_pos = ans_pos.set_index("pos")
ind_list = []
haps = ans_pos.columns
for hap_i in range(0, len(ans_pos.columns)):
    if hap_i % 2 == 0:
        ind_list.append(ans_pos.columns[hap_i][:-2])

#get genetic map and prep for files that need it
genetic_map = pd.read_csv(genetic_map_file, delim_whitespace = True, header = None).drop(2, axis = 1)
genetic_map.columns = ["rs", "pos"]

#make ans for rsid
genetic_map_pos_index = genetic_map.set_index("pos")
ans_rs = ans_pos.merge(genetic_map_pos_index, left_index = True, right_index = True).set_index("rs")

#translate which ancestry is which in the answers
  #"the entires of the tab delimited matrix are integer codes starting from 1 and correspond to the population labels in the input sample map file in the order they first appear"
pop = pd.read_csv(pop_file, delim_whitespace = True, header = None, index_col = 0)
pop.columns = ["anc"]
pop["anc_code"] = pd.factorize(pop["anc"])[0] + 1

##############
### LAMPLD ###
##############

#get pos of snps that were input
LAMPLD_pos = pd.read_csv(LAMPLD_haps_hap_gz, delim_whitespace = True, header = None)[[2]]
LAMPLD_pos.columns = ["pos"]

#read in LAMP answers
LAMPLD = pd.read_fwf(LAMPLD_long, widths = [1] * len(LAMPLD_pos.index), header = None).transpose()
LAMPLD.columns = haps 
LAMPLD.index = LAMPLD_pos.pos
LAMPLD += 1 #0, 1 to 1, 2 ancestry coding

#############
### RFMIX ###
#############

#RFMix is being read in super super weird so I have to do it in a convoluted way
csvfile = open(RFMix_Viterbi)
RFMix_csv = csv.reader(csvfile, delimiter = " ")
RFMix = []
for row in RFMix_csv:
    RFMix.append(row)
RFMix = pd.DataFrame(RFMix).apply(pd.to_numeric).iloc[:, :-1] #last column is wonky (nan)
RFMix.columns = haps
RFMix.index = np.loadtxt(RFMix_snps, dtype = str)[1:] #add rsids for comparing to ans later

'''
#make sure classes are in the same order as the .result file
RFMix_vcf_ids = np.loadtxt(RFMix_vcf_ids, dtype = str)
RFMix_ref_vcf_ids = [x for x in RFMix_vcf_ids if x not in ind_list] #only keep non-admixed
RFMix_classes = np.loadtxt(RFMix_classes, dtype = str).tolist()
RFMix_classes = RFMix_classes[:int(len(RFMix_classes) - len(RFMix.columns))][::2] #remove admixed and keep every other haplotype
RFMix_id_classes = pd.DataFrame({"ref_id": RFMix_ref_vcf_ids, "class_code": RFMix_classes}).set_index("ref_id")
compare_RFMix_class_to_result = pop.merge(RFMix_id_classes, left_index = True, right_index = True) #this is ridiculous
#IF WRONG FIXXXXXXXX
'''

############
### ELAI ###
############

#ELAI in dosage format, change ans to match dosage
ELAI = pd.read_csv(ELAI_results, delim_whitespace = True, header = None).transpose().astype(int) #round all ELAI to pop codes
ELAI_pos = pd.read_csv(ELAI_pos, delim_whitespace = True, header = None)
rsid_pop = []

if "ASW" in out: #remove native american from pop file if african american
    pop = pop[pop.anc != "NAT"] 
elif "ACB" in out:
    pop = pop[pop.anc != "NAT"] 

for rsid in ELAI_pos[0]:
    for pop_i in pop["anc"].drop_duplicates(): #get in the right order
        #if pop_i == "NAT" and "ASW" in out or "ACB" in out: #skip Native American in African-American pops
        #    print("it worked!")
        #    next
        rsid_pop.append(rsid + "_" + pop_i)
#print(rsid_pop[1:10])
ELAI.index = rsid_pop
ELAI.columns = ind_list
    
#Convert to overall ancestry dosages (see ELAI)
ans_rs_dos = hap2dos(ans_rs)
  
#Measure accuracy of each method and store
LAMPLD_acc = calc_accuracy(ans_pos, LAMPLD)
RFMix_acc = calc_accuracy(ans_rs, RFMix)
ELAI_acc = calc_accuracy(ans_rs_dos, ELAI)

with open("accuracy_results.csv", 'a+') as f: #give user choice to change this later
    f.write(",".join([out, str(LAMPLD_acc[0]), str(LAMPLD_acc[1]), str(RFMix_acc[0]), str(RFMix_acc[1]), str(ELAI_acc[0]), str(ELAI_acc[1])]))
print("Completed calculation of accuracies in LAMPLD, RFMix, and ELAI. Have a nice day :).")
