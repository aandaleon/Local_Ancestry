#randomly sample individuals in appropriate proportions for admixture simulation
library(data.table)
library(dplyr)
"%&%" = function(a, b) paste(a, b, sep = "")
setwd("/home/angela/Local_Ancestry/")
system("mkdir -p admixture_simulation/")

#pull in and split data
ref_pop <- fread("1000G/ref_pop.txt", header = F)
nind <- fread("1000G/admixture_simulation_nind.csv")
NAT <- subset(ref_pop, V2 == "NAT")
CEU <- subset(ref_pop, V2 == "CEU")
YRI <- subset(ref_pop, V2 == "YRI")

#iterate pop_codes
for(i in 1:nrow(nind)){
  NAT_sub <- sample_n(NAT, as.integer(nind[i, 3])) #sample appropriate proportion of reference
  CEU_sub <- sample_n(CEU, as.integer(nind[i, 4]))
  YRI_sub <- sample_n(YRI, as.integer(nind[i, 5]))
  pop_ref <- rbind(NAT_sub, CEU_sub, YRI_sub)
  pop_code <- paste(as.character(nind[i, 1]), as.character(nind[i, 2]), sep = "")
  fwrite(pop_ref, "admixture_simulation/" %&% pop_code %&% ".txt", quote = F, sep = "\t", na = "NA", col.names = F)
}

