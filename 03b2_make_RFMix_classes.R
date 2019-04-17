#Make classes for RFMix
library(dplyr)
library(data.table)
"%&%" = function(a,b) paste(a, b, sep = "")
args <- commandArgs(trailingOnly = T)
vcf_ids <- args[1]
#vcf_ids <- "sim_RFMix/80_20_6/merged.vcf_ids.txt"

pop_codes <- fread("../../pop_codes.txt", header = F)
vcf_ids <- fread(vcf_ids, header = F)
colnames(pop_codes) <- c("IID", "pop")
colnames(vcf_ids) <- "IID"
vcf_pops <- left_join(vcf_ids, pop_codes)
vcf_pops$pop <- as.numeric(factor(vcf_pops$pop)) #convert pops to ints
vcf_pops[is.na(vcf_pops)] <- 0
write(paste(as.character(vcf_pops$pop), collapse = " "), "merged.classes")
