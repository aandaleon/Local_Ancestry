# -*- coding: utf-8 -*-
"""
Created on Mon Apr 15 22:36:43 2019
#convert from bcftools haplotype format to LAMP-LD haplotype format
@author: Angela
"""

import argparse
import pandas as pd

parser = argparse.ArgumentParser()
parser.add_argument("--hap.gz", type = str, action = "store", dest = "hap_gz", required = False, help = "Input file (.haps.hap.gz)")
parser.add_argument("--haps", type = str, action = "store", dest = "haps", required = False, help = "Output file prefix")
args = parser.parse_args() 

hap_gz = args.hap_gz
haps = args.haps

'''
hap_gz = "80_20_6/admixed.haps.hap.gz"
haps = "80_20_6/admixed.haps"
'''

print("Starting conversion on " + hap_gz + ".")
hap_bcftools = pd.read_table(hap_gz, compression = 'gzip', sep = ' ', header = None)
hap_bcftools = hap_bcftools.loc[:, 5:] #remove first five columns of SNP info
hap_LAMPLD = hap_bcftools.astype(str).apply(''.join) #https://stackoverflow.com/questions/39172403/how-to-save-a-pandas-dataframe-such-that-there-is-no-delimiter
hap_LAMPLD.to_csv(haps, index = False, header = False, sep = ' ')
print("Conversion complete. Results are available in " + haps + ".")
