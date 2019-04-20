#get cM map for chr. 22
library(data.table)
library(dplyr)
vcf_SNPs <- fread("admixture-simulation/chr22.interpolated_genetic_map.snps.txt")
genetic_map <- fread("admixture-simulation/chr22.interpolated_genetic_map")
colnames(genetic_map) <- c("ID", "POS", "cM")
colnames(vcf_SNPs)[1] <- "CHROM"
vcf_genetic_map <- left_join(vcf_SNPs, genetic_map, by = c("POS", "ID"))
vcf_genetic_map$CHROM <- paste("chr", vcf_genetic_map$CHROM, sep = "")
vcf_genetic_map$ID <- NULL
vcf_genetic_map <- vcf_genetic_map[complete.cases(vcf_genetic_map),]
fwrite(vcf_genetic_map, "admixture-simulation/chr22.interpolated_genetic_map.pruned", sep = "\t", col.names = F, quote = F, na = "NA")
