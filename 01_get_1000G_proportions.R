#run ADMIXTURE on African-American and Hispanic data and randomly choose proportions of individual genotypes from real data
library(data.table)
library(dplyr)
"%&%" = function(a, b) paste(a, b, sep = "")
setwd("/home/angela/Local_Ancestry/")

#get African-American proportions from ASW
#admixture: /home/angela/px_his_chol/ADMIXTURE/admixture_linux-1.3.0/admixture
system("mkdir 1000G/ -p")
setwd("1000G/")

#system("awk -F'\t' '{if ($6 == \"YRI\" || $6 == \"CEU\" || $6 == \"PEL\" || $6 == \"MXL\") {print $1}}' /home/angela/1000G/phase3_corrected.psam > 1000G_IIDs.txt") #extract pop, CEU, NAT, and YRI IIDs

HIS_ref <- fread("/home/angela/Ad_PX_pipe_data/RFMix/RefPop/HIS_pop.txt", header = F)
AFA_ref <- fread("/home/angela/Ad_PX_pipe_data/RFMix/RefPop/AFA_pop.txt", header = F)
ref <- unique(rbind(HIS_ref, AFA_ref))
ref <- ref %>% dplyr::select(V1, V3) #keep just IDs
ref <- subset(ref, V3 != "IBS") #remove IBS
fwrite(ref, "ref_pop.txt", quote = F, na = "NA", col.names = F, sep = "\t")

proportions <- matrix(, nrow = 0, ncol = 5)

for(pop in c("MXL", "PUR", "ACB", "ASW")){
  #system("awk -F'\t' '{if ($6 == \"YRI\" || $6 == \"CEU\" || $6 == \"PEL\" || $6 == \"MXL\"|| $6 == \"" %&% pop %&% "\") {print $1, $6}}' /home/angela/1000G/phase3_corrected.psam > " %&% pop %&% ".pop")
  system("awk -F'\t' '{if ($6 == \"" %&% pop %&% "\") {print $1}}' /home/angela/1000G/phase3_corrected.psam > " %&% pop %&% ".pop")
  
  #make list of inds to extract
  pop_IID <- fread(pop %&% ".pop", header = F)
  keep_IID <- as.data.frame(unique(c(pop_IID$V1, ref$V1)))
  fwrite(keep_IID, pop %&% "_keep_IID.txt", col.names = F, quote = F, na = "NA")
  system("plink2 --pgen /home/angela/1000G/all_phase3.pgen --pvar /home/angela/1000G/all_phase3.pvar --psam /home/angela/1000G/phase3_corrected.psam --keep " %&% pop %&% "_keep_IID.txt --indep-pairwise 50 10 0.1 --make-bed --out " %&% pop %&% "_unpruned --king-cutoff 0.125 --chr 22 --snps-only --max-alleles 2") #extract pops from 1000G, remove SNPs in LD, remove relateds, and limit to chr. 22
  system("plink2 --bfile " %&% pop %&% "_unpruned --extract " %&% pop %&% "_unpruned.prune.in --exclude " %&% pop %&% "_unpruned.king.cutoff.out.id --make-bed --out " %&% pop) #remove linked SNPs and related inds
  system("rm *unpruned*")
  
  #make sure pops are in the right order for ADMIXTURE
  pop_fam <- fread(pop %&% ".fam", header = F)
  pop_sorted <- left_join(pop_fam, ref, by = c("V2" = "V1"))
  pop_sorted <- pop_sorted %>% dplyr::select(V3.y)
  pop_sorted[is.na(pop_sorted)] <- "-" #unknown ancestry marker
  fwrite(pop_sorted, pop %&% ".pop", col.names = F, quote = F, na = "-")

  #run admixture
  system("/home/angela/px_his_chol/ADMIXTURE/admixture_linux-1.3.0/admixture " %&% pop %&% ".bed 3 --supervised -j20")
  admixture <- fread(pop %&% ".3.Q", header = F)
  pop_admixture <- cbind(pop_sorted, admixture)
  pop_admixture <- subset(pop_admixture, V3.y == "-") #keep only the admixture pop
  pop_admixture$V3.y <- NULL
  
  #select 1st, 2nd, and 3rd quartile by Native American proportion
  pop_admixture <- unique(pop_admixture[order(pop_admixture$V1),])
  for(i in c(1, 2, 3)){
    row_num <- i * nrow(pop_admixture)/4 #row to select
    proportions <- rbind(proportions, c(pop, i, pop_admixture[row_num, 1], pop_admixture[row_num, 2], pop_admixture[row_num, 3]))
  }
}

proportions <- as.data.frame(proportions)
colnames(proportions) <- c("pop", "quartile", "NAT", "CEU", "YRI")
fwrite(proportions, "admixture_simulation_proportions.csv", na = "NA", quote = F)
