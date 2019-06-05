#make a pretty line plot comparing the run time of the softwares
library(data.table)
library(ggplot2)
library(lubridate)
library(reshape2)

data <- fread("benchmarking/benchmarking_results.csv")
data$new_time <- as.numeric(ms(data$cmd_time, roll = T)) #make all time into seconds
#data$cmd_size <- data$cmd_size / 1000 #to MB
for(run in 1:nrow(data)){
  if(is.na(data[run, 5])){
    data[run, 5] <- as.numeric(hms(as.character(data[run, 3]))) #if in HMS format
  }
}
data$cmd_time <- NULL
colnames(data)[2] <- "Method"
melted <- melt(data, id.vars = c("nind", "Method"))
melted$variable <- gsub("cmd_size", "Max. memory usage (MB)", melted$variable)
melted$variable <- gsub("new_time", "Run time (s)", melted$variable)

#plot time vs. size
time_size <- ggplot() + 
  geom_line(data = melted, aes(x = nind, y = value, color = Method), size = 2) + 
  geom_point(data = melted, aes(x = nind, y = value, color = Method)) + 
  labs(x = "Number of individuals", y = NULL) + 
  theme_bw() +
  facet_wrap(~ variable, nrow = 2, scales = "free_y", strip.position = "left") + 
  theme(text = element_text(size = 15)) + 
  scale_color_viridis_d(option = "inferno", begin = 0.1, end = 0.9)
time_size

#memory and run time regressions
LAMPLD <- subset(data, Method == "LAMP-LD")
RFMix <- subset(data, Method == "RFMix")
ELAI <- subset(data, Method == "ELAI")

print(summary(lm(cmd_size ~ nind, data = LAMPLD)))
print(summary(lm(cmd_size ~ nind, data = RFMix)))
print(summary(lm(cmd_size ~ nind, data = ELAI)))

print(summary(lm(new_time ~ nind, data = LAMPLD)))
print(summary(lm(new_time ~ nind, data = RFMix)))
print(summary(lm(new_time ~ nind, data = ELAI)))



