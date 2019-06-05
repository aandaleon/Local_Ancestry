library(data.table)
library(dplyr)

vcf_SNPs <- fread("sim_RFMix/80_20_6/admixed.snps", header = F)
full_gen_map <- fread("admixture-simulation/chr22.interpolated_genetic_map", header = F)
colnames(vcf_SNPs) <- "SNP"
colnames(full_gen_map) <- c("SNP", "BP", "cM")
vcf_gen_map <- left_join(vcf_SNPs, full_gen_map, by = "SNP")
vcf_gen_map$SNP <- NULL
vcf_gen_map$BP <- NULL
vcf_gen_map[is.na(vcf_gen_map)] <- 0 #the first cM is 0 for some reason, so forcing
fwrite(vcf_gen_map, "sim_RFMix/admixed_chr22.pos", col.names = F)
