#plot dosage of each ancestry against each software's estimate
library(data.table)
library(dplyr)
library(ggplot2)
library(reshape)
"%&%" = function(a, b) paste(a, b, sep = "")
setwd("/home/angela/Local_Ancestry/plot_data/")
pop_name <- "ACB_pruned" #should be the only part that changes
ancs <- c("YRI", "CEU")

#import all as dosages for simplicity
ans <- fread(pop_name %&% "_ans_rs_dos.csv")
LAMPLD <- fread(pop_name %&% "_LAMPLD_dos.csv")
RFMix <- fread(pop_name %&% "_RFMix_dos.csv")
ELAI <- fread(pop_name %&% "_ELAI.csv")

#convert LAMPLD from pos_anc to rs_anc also I know this is absolutely hideous
genetic_map <- fread("../chr22.interpolated_genetic_map")
genetic_map_cM <- genetic_map
colnames(genetic_map_cM) <- c("rs", "bp", "cM")
genetic_map$V3 <- NULL
colnames(genetic_map) <- c("rs_anc", "bp_anc")
genetic_map_anc1 <- genetic_map
genetic_map_anc1$rs_anc <- paste0(genetic_map_anc1$rs_anc, "_", ancs[1])
genetic_map_anc1$bp_anc <- paste0(genetic_map_anc1$bp_anc, "_", ancs[1])
genetic_map_anc2 <- genetic_map
genetic_map_anc2$rs_anc <- paste0(genetic_map_anc2$rs_anc, "_", ancs[2])
genetic_map_anc2$bp_anc <- paste0(genetic_map_anc2$bp_anc, "_", ancs[2])
if(length(ancs) == 3){
  genetic_map_anc3 <- genetic_map
  genetic_map_anc3$rs_anc <- paste0(genetic_map_anc3$rs_anc, "_", ancs[3])
  genetic_map_anc3$bp_anc <- paste0(genetic_map_anc3$bp_anc, "_", ancs[3])
  genetic_map <- rbind(genetic_map_anc1, genetic_map_anc2, genetic_map_anc3)
  rm(genetic_map_anc3)
}else{
  genetic_map <- rbind(genetic_map_anc1, genetic_map_anc2) #its very ugly but it works
}
rm(genetic_map_anc1)
rm(genetic_map_anc2)
colnames(LAMPLD)[1] <- "bp_anc"
LAMPLD <- left_join(LAMPLD, genetic_map, by = "bp_anc")
LAMPLD$bp_anc <- LAMPLD$rs_anc
LAMPLD$rs_anc <- NULL
colnames(LAMPLD)[1] <- "rs_anc"

colnames(ans)[1] <- "rs_anc"
colnames(RFMix)[1] <- "rs_anc"
colnames(ELAI)[1] <- "rs_anc"

#keep only SNPs that match with the other methods
SNPs <- as.data.frame(ELAI$rs_anc) 
colnames(SNPs)[1] <- "rs_anc"
ans <- left_join(SNPs, ans, by = "rs_anc")
LAMPLD <- left_join(SNPs, LAMPLD, by = "rs_anc")
RFMix <- left_join(SNPs, RFMix, by = "rs_anc")

#pull out ind to make a plot of
plot_list = list()
for(ind_index in 2:length(colnames(ans))){
  #ind <- colnames(ans)[i]
  ind <- colnames(ans)[ind_index]
  ans_ind <- ans %>% dplyr::select(rs_anc, ind)
  LAMPLD_ind <- LAMPLD %>% dplyr::select(ind)
  RFMix_ind <- RFMix %>% dplyr::select(ind)
  ELAI_ind <- ELAI %>% dplyr::select(ind)
  ind_df <- cbind(ans_ind, LAMPLD_ind, RFMix_ind, ELAI_ind)
  colnames(ind_df) <- c("rs_anc", "ans", "LAMPLD", "RFMix", "ELAI")
  ind_df$rs <- gsub("_[^_]+$", "", ind_df$rs_anc)
  ind_df <- left_join(ind_df, genetic_map_cM, by = "rs")
  ind_df$rs_anc <- gsub(".*_", "", ind_df$rs_anc)
  ind_df <- ind_df %>% dplyr::select(rs_anc, cM, ans, LAMPLD, RFMix, ELAI) #change to plot other things
  ind_melt <- melt(ind_df, id = c("rs_anc", "cM"))
  
  ind_plot <- ggplot() + 
    geom_point(data = ind_melt, aes(x = cM, y = value, color = rs_anc), alpha = 0.5) +
    facet_wrap(~ variable, nrow = 4) + 
    #geom_bar(stat = "identity") + 
    labs(color = "Pop.", y = "Dosage", title = ind) + 
    theme_bw() + 
    theme(text = element_text(size = 15), plot.title = element_text(hjust = 0.5)) +
    scale_color_viridis(discrete = T, begin = 0.25, end = 0.75)
  plot_list[[ind_index]] = ind_plot
}

pdf(paste0(pop_name, ".pdf")) 
for (i in 2:length(colnames(ans))) {
  print(plot_list[[i]])
}
dev.off()


