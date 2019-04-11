#why is the admixture simulation script so weird
library(data.table)
library(dplyr)
setwd("/home/angela/BIOI500_Local_Ancestry/admixture-simulation/")

ID_in_VCF <- fread("1000G_CEU_YRI_22.recode.vcf_ids.txt", header = F)
pop_codes <- fread("../pop_codes.txt", header = F)
VCF_pop_codes <- left_join(ID_in_VCF, pop_codes, by = "V1")
table(VCF_pop_codes$V2)
CEU <- subset(VCF_pop_codes, V2 == "CEU")
YRI <- subset(VCF_pop_codes, V2 == "YRI")

#filter 80/20
YRI_80 <- sample_n(YRI, 80)
CEU_20 <- sample_n(CEU, 20)
admix_YRI_80_CEU_20 <- rbind(YRI_80, CEU_20)
fwrite(admix_YRI_80_CEU_20, "pop_codes_80_20.txt", col.names = F, sep = "\t", quote = F)

#filter 50/50
YRI_50 <- sample_n(YRI, 50)
CEU_50 <- sample_n(CEU, 50)
admix_YRI_50_CEU_50 <- rbind(YRI_50, CEU_50)
fwrite(admix_YRI_50_CEU_50, "pop_codes_50_50.txt", col.names = F, sep = "\t", quote = F)
