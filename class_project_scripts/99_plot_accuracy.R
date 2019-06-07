library(data.table)
library(dplyr)
library(ggplot2)
library(reshape2)

#prep data for plotting
results_1 <- fread("acc_results_median_1.csv")
results_2 <- fread("acc_results_median_2.csv")
results_3 <- fread("acc_results_median_3.csv")
results_1$run <- "1"
results_2$run <- "2"
results_3$run <- "3"
results <- rbind(results_1, results_2, results_3)
colnames(results)[2] <- "LAMP-LD"
results_melt <- melt(results, id.vars = c("cohort", "run"), measure.vars = c("LAMP-LD", "RFMix", "ELAI"))

#fix cohort labels
results_melt$cohort[results_melt$cohort == "80_20_6"] <- "ADM1"
results_melt$cohort[results_melt$cohort == "80_20_60"] <- "ADM2"
results_melt$cohort[results_melt$cohort == "50_50_6"] <- "ADM3"
results_melt$cohort[results_melt$cohort == "50_50_60"] <- "ADM4"

results_plot <- ggplot(data = results_melt) + 
  geom_point(aes(x = cohort, y = value, color = run), size = 4, alpha = 0.5) + 
  facet_wrap(~ variable, ncol = 1) + 
  labs(color = "Run #", y = "Accuracy", x = "Cohort") + 
  theme_bw() + 
  theme(text = element_text(size = 15)) + 
  scale_color_viridis_d(option = "viridis", begin = 0.1, end = 0.9)
results_plot



