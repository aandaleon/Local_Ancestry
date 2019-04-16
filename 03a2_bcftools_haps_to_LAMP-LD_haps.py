# -*- coding: utf-8 -*-
"""
Created on Mon Apr 15 22:36:43 2019
#convert from bcftools haplotype format to LAMP-LD haplotype format
@author: Angela
"""

import argparse
import numpy as np
import pandas as pd

parser = argparse.ArgumentParser()
parser.add_argument("--hap.gz", type = str, action = "store", dest = "hap_gz", required = False, help = "Input file (.haps.hap.gz)")
parser.add_argument("--adm", action = "store_true", dest = "adm", default = False, help = "Include for admixed sample.")
parser.add_argument("--haps", type = str, action = "store", dest = "haps", required = False, help = "Output file prefix")
args = parser.parse_args() 

hap_gz = args.hap_gz
haps = args.haps
adm = args.adm

'''
hap_gz = "80_20_6/admixed.haps.hap.gz"
haps = "80_20_6/admixed.haps"
adm = True
'''

print("Starting conversion on " + hap_gz + ".")
hap_bcftools = pd.read_table(hap_gz, compression = 'gzip', sep = ' ', header = None)
hap_bcftools = hap_bcftools.loc[:, 5:] #remove first five columns of SNP info

if adm:
    print("This conversion is admixed.") #why is this so complicated. Why can't you be like the other haplotypes.
    hap_bcftools_adm = hap_bcftools.transpose()
    hap_LAMPLD = hap_bcftools_adm.groupby(np.arange(len(hap_bcftools_adm)) // 2).sum().transpose() #adds haplotypes so each row is an ind.; https://stackoverflow.com/questions/36810595/calculate-average-of-every-x-rows-in-a-table-and-create-new-table/36810658
    hap_LAMPLD = hap_LAMPLD.astype(str).apply(''.join)

else:
    print("This conversion is not admixed.")
    hap_LAMPLD = hap_bcftools.astype(str).apply(''.join) #effectively makes delimiter = ''; https://stackoverflow.com/questions/39172403/how-to-save-a-pandas-dataframe-such-that-there-is-no-delimiter

hap_LAMPLD.to_csv(haps, index = False, header = False, sep = ' ')
print("Conversion complete. Results are available in " + haps + ".")
