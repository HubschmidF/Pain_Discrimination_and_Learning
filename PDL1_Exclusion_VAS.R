#==============================================================================#
# Figure: Exclusion and Manipulation Checks
#==============================================================================#

# AUTHOR(s):    > FH

#==============================================================================#

suppressMessages(suppressWarnings(library(ggplot2)))
suppressMessages(suppressWarnings(library(ggpubr)))     
suppressMessages(suppressWarnings(library(Rmisc)))     
suppressMessages(suppressWarnings(library(grid)))      
suppressMessages(suppressWarnings(library(rstudioapi)))
analysis_path = rstudioapi::getActiveDocumentContext()$path
setwd(dirname(analysis_path))
print(getwd())

#==============================================================================#
# Data and curation
#==============================================================================#

#
dataVAS <- read.csv("PDL_data_vas.csv", header = T, sep = ";")
dataEXC <- read.csv("PDL_data_inclusion_exclusion.csv", header = T, sep = ";")
#
str(dataVAS)
dataVAS$participant_code<-factor(dataVAS$participant_code)
dataVAS$trial<-factor(dataVAS$trial)
dataVAS$Reward <- dataVAS$condition
#
dataVAS$Reward <- as.factor(dataVAS$Reward)
levels(dataVAS$Reward)
levels(dataVAS$Reward) <- c('Contingent', 'Non-Contingent')

#
DF_VAS <- tibble(dataVAS)
DF_plot1 <- tibble(dataEXC)
pd <- position_dodge(0.3)

#==============================================================================#
# Histogram: Choice option selection
#==============================================================================#

DF_plot1 <- tibble(dataEXC)

pl1 <- ggplot(DF_plot1, aes(x = yes_s)) +
              geom_histogram(color = 'red2', fill = c('azure2'), bins = 17) +
              geom_vline(aes(xintercept = mean(yes_s)), color = 'red2', linetype = 'dashed', size = 1) +
              geom_vline(aes(xintercept = 80), color = 'black', linetype = 'dashed', size = 1) +
              xlim(40,122) +
              labs(y = 'n° of Participants', x = 'n° times response = YES was chosen') +
              theme_classic()
pl1
  
#==============================================================================#
# Lineplots: VAS intensity and pleasantness
#==============================================================================#

# VAS intensity ---------------------------------------------------------------#

# Labels for the BF01 (calculated in JASP before)
int13  <- grobTree(textGrob("3.50", x=0.02,  y=0.85, hjust=0, gp=gpar(col="black", fontsize=10, fontface="italic")))
int26  <- grobTree(textGrob("3.40", x=0.12,  y=0.85, hjust=0, gp=gpar(col="black", fontsize=10, fontface="italic")))
int39  <- grobTree(textGrob("3.15", x=0.22,  y=0.85, hjust=0, gp=gpar(col="black", fontsize=10, fontface="italic")))
int52  <- grobTree(textGrob("2.81", x=0.32,  y=0.85, hjust=0, gp=gpar(col="black", fontsize=10, fontface="italic")))
int65  <- grobTree(textGrob("3.48", x=0.42,  y=0.85, hjust=0, gp=gpar(col="black", fontsize=10, fontface="italic")))
int78  <- grobTree(textGrob("3.10", x=0.52,  y=0.85, hjust=0, gp=gpar(col="black", fontsize=10, fontface="italic")))
int91  <- grobTree(textGrob("3.32", x=0.62,  y=0.85, hjust=0, gp=gpar(col="black", fontsize=10, fontface="italic")))
int104 <- grobTree(textGrob("3.38", x=0.72,  y=0.85, hjust=0, gp=gpar(col="black", fontsize=10, fontface="italic")))
int117 <- grobTree(textGrob("3.53", x=0.82,  y=0.85, hjust=0, gp=gpar(col="black", fontsize=10, fontface="italic")))
int130 <- grobTree(textGrob("3.29", x=0.92,  y=0.85, hjust=0, gp=gpar(col="black", fontsize=10, fontface="italic")))
tit    <- grobTree(textGrob("Corresponding BF01", x=0.60,  y=0.95, hjust=0, gp=gpar(col="black", fontsize=10, fontface="bold")))

# Data
SumINT <- summarySE(dataVAS, measurevar="VAS_intensity", groupvars=c("trial","Reward"))

# Plot
pl2 <- ggplot(SumINT, aes(x=trial, y=VAS_intensity, color = Reward, group = Reward)) +
              geom_errorbar(aes(ymin=VAS_intensity-sd, ymax=VAS_intensity+sd), width=.1, position=pd) +
              geom_line(position=pd) +
              geom_point(position=pd)+
              geom_hline(aes(yintercept = 100), color = 'black', linetype = 'dotted', size = 1) +
              labs(y = "Intensity Rating", x = "Trial") +
              scale_color_manual(values=c("blue", "chocolate1"))+ theme_classic() + 
              ylim(0,200) +
              theme_classic() +
              theme(legend.position='none') +
              annotation_custom(int13) +
              annotation_custom(int26) +
              annotation_custom(int39) +
              annotation_custom(int52) +
              annotation_custom(int65) +
              annotation_custom(int78) +
              annotation_custom(int91) +
              annotation_custom(int104) +
              annotation_custom(int117) +
              annotation_custom(int130) +
              annotation_custom(tit)
pl2

# VAS pleasantness ------------------------------------------------------------#

# Labels for the BF01 (calculated in JASP before)
ple13  <- grobTree(textGrob("3.32", x=0.02,  y=0.85, hjust=0, gp=gpar(col="black", fontsize=10, fontface="italic")))
ple26  <- grobTree(textGrob("3.54", x=0.12,  y=0.85, hjust=0, gp=gpar(col="black", fontsize=10, fontface="italic")))
ple39  <- grobTree(textGrob("3.64", x=0.22,  y=0.85, hjust=0, gp=gpar(col="black", fontsize=10, fontface="italic")))
ple52  <- grobTree(textGrob("3.01", x=0.32,  y=0.85, hjust=0, gp=gpar(col="black", fontsize=10, fontface="italic")))
ple65  <- grobTree(textGrob("3.64", x=0.42,  y=0.85, hjust=0, gp=gpar(col="black", fontsize=10, fontface="italic")))
ple78  <- grobTree(textGrob("3.63", x=0.52,  y=0.85, hjust=0, gp=gpar(col="black", fontsize=10, fontface="italic")))
ple91  <- grobTree(textGrob("2.77", x=0.62,  y=0.85, hjust=0, gp=gpar(col="black", fontsize=10, fontface="italic")))
ple104 <- grobTree(textGrob("3.41", x=0.72,  y=0.85, hjust=0, gp=gpar(col="black", fontsize=10, fontface="italic")))
ple117 <- grobTree(textGrob("3.55", x=0.82,  y=0.85, hjust=0, gp=gpar(col="black", fontsize=10, fontface="italic")))
ple130 <- grobTree(textGrob("3.04", x=0.92,  y=0.85, hjust=0, gp=gpar(col="black", fontsize=10, fontface="italic")))

# Data
SumPLEA <- summarySE(dataVAS, measurevar="VAS_unpleasanteness", groupvars=c("trial","Reward"))

# Plot
pl3 <- ggplot(SumPLEA, aes(x=trial, y=VAS_unpleasanteness, color = Reward, group = Reward)) +
              geom_errorbar(aes(ymin=VAS_unpleasanteness-sd, ymax=VAS_unpleasanteness+sd), width=.1, position=pd) +
              geom_line(position=pd) +
              geom_point(position=pd)+
              geom_hline(aes(yintercept = 0), color = 'black', linetype = 'dotted', size = 1) +
              labs(y = "Un-/pleasanteness Rating", x = "Trial") +
              scale_color_manual(values=c("blue", "chocolate1")) +
              ylim(-100,100) +
              theme_classic() +
              theme(legend.position='none') +
              annotation_custom(ple13) +
              annotation_custom(ple26) +
              annotation_custom(ple39) +
              annotation_custom(ple52) +
              annotation_custom(ple65) +
              annotation_custom(ple78) +
              annotation_custom(ple91) +
              annotation_custom(ple104) +
              annotation_custom(ple117) +
              annotation_custom(ple130) +
              annotation_custom(tit)
pl3

#==============================================================================#
# Final Figure
#==============================================================================#

figure <- ggarrange(pl1, pl2, pl3,
                    labels = c('A', 'B', 'C'),
                    common.legend = TRUE, legend = 'bottom',
                    ncol = 3, nrow = 1)
figure

#==============================================================================#