#==============================================================================#
# Figure: Descriptives
#==============================================================================#

# AUTHOR(s):    > FH

# DESCRIPTION:  > Descriptives plot

#==============================================================================#

# Utility
suppressMessages(suppressWarnings(library(ggplot2)))
suppressMessages(suppressWarnings(library(ggpubr)))
suppressMessages(suppressWarnings(library(ggridges)))
suppressMessages(suppressWarnings(library(plyr)))
suppressMessages(suppressWarnings(library(dplyr)))
suppressMessages(suppressWarnings(library(sm)))
suppressMessages(suppressWarnings(library(boot)))
suppressMessages(suppressWarnings(library(HDInterval)))
suppressMessages(suppressWarnings(library(tidyverse)))
suppressMessages(suppressWarnings(library(readxl)))
suppressMessages(suppressWarnings(library(Rmisc)))
suppressMessages(suppressWarnings(library(grid)))

#==============================================================================#
# DATASETS
#==============================================================================#

#
dataDES <- read.csv("Des_plots.csv", header = T, sep = ";")
data <- read.csv("HDDMS1final.csv", header = T, sep = ";")
#

#==============================================================================#
# Histograms Choice Reaction Data
#==============================================================================#

str(data)
data$response <- as.factor(data$response)
data$Reward <- as.factor(data$reward)
levels(data$Reward)
levels(data$Reward) <- c('Contingent', 'Non-Contingent', 'No-Reward')
DF <- as.data.frame(data)
wrong <- subset(DF, response %in% 0)  
right <- subset(DF, response %in% 1)
neg_wrong <- wrong
neg_wrong[sapply(neg_wrong, is.double)] <- neg_wrong[sapply(neg_wrong, is.double)] * -1
#
RT_wrong <- neg_wrong$rt
RT_right <- right$rt
#
right$Reward <- as.character(right$Reward)
neg_wrong$Reward <- as.character(neg_wrong$Reward)
#
Rew_right <- right$Reward
Rew_wrong <- neg_wrong$Reward
Stim_right <- right$condition
Stim_wrong <- neg_wrong$condition
#
thingy <- c(Rew_right, Rew_wrong)
RT <- c(RT_right, RT_wrong)
stim <- c(Stim_right, Stim_wrong)
Reward <- thingy
Pulse <- stim
DFplot <- data.frame(RT, Reward, stim)
str(DFplot)
DFplot$Reward <- as.factor(DFplot$Reward)
DFplot$Pulse <- as.factor(DFplot$stim)
levels(DFplot$Pulse) <- c('+0°C', '+0.2°C', '+0.4°C')

str(DFplot)
levels(DFplot$Pulse)
levels(DFplot$Reward)

# Dependant on Pulse conditon -------------------------------------------------#

pl1 <- ggplot(DFplot, aes(x = RT, color = Pulse, fill = Pulse)) +
              geom_histogram( bins = 100, alpha = 0.1, position = 'identity') +
              labs(y = 'Counts', x = 'Reaction Time') +
              scale_color_manual(values=c("turquoise", 'violetred1', "purple1")) +
              scale_fill_manual(values=c("turquoise", 'violetred1', "purple1")) +
              theme_classic()+
              theme(legend.position='bottom')
pl1

# Dependant on Reward condition -----------------------------------------------#

pl2 <- ggplot(DFplot, aes(x = RT, color = Reward, fill = Reward)) +
              geom_histogram( bins = 100, alpha = 0.1, position = 'identity') +
              labs(y = 'Counts', x = 'Reaction Time') +
              scale_color_manual(values=c("blue", 'forestgreen', "chocolate1")) +
              scale_fill_manual(values=c("blue", 'forestgreen', "chocolate1")) +
              theme_classic() +
              theme(legend.position='bottom')
pl2

#==============================================================================#
# Boxplots Accuracy and Reaction Times
#==============================================================================#

#
str(dataDES)
dataDES$subj_idx<-factor(dataDES$subj_idx)
dataDES$stim<-factor(dataDES$stim)
dataDES$reward<-factor(dataDES$reward)
dataDES$reward<-relevel(dataDES$reward,ref="NR")
dataDES$response<-factor(dataDES$response)
str(dataDES)
levels(dataDES$reward)<-c("No-Reward", "Contingent", "Non-Contingent")
levels(dataDES$stim)<-c("+0°C", "+0.2°C", "+0.4°C")
dataDES$Reward <- dataDES$reward
dataDES$Pulse <- dataDES$stim
str(dataDES)

levels(dataDES$Reward)

# RT --------------------------------------------------------------------------#

pl3 <- ggplot(dataDES, aes(x=Pulse, y=rt, fill=Reward)) +
              geom_boxplot(notch = T, outlier.size = 1.5) +
              labs(y = "Reaction time", x = "Pulse condition") +
              scale_fill_manual(values=c('forestgreen', "blue", "chocolate1"))+
              theme_classic()  +
              theme(legend.position='none')
pl3

# Accuracy --------------------------------------------------------------------#

pl4 <- ggplot(dataDES, aes(x=Pulse, y=prop, fill=Reward)) +
              geom_boxplot(notch = T, outlier.size = 1.5) +
              labs(y = "% of Correct Choices", x = "Pulse condition") +
              scale_fill_manual(values=c('forestgreen', "blue", "chocolate1"))+
              theme_classic()  +
              theme(legend.position='none')
pl4

#==============================================================================#
# Figure
#==============================================================================#

ggarrange(
  pl1, pl2,                
  
  ggarrange(bxp, dp, ncol = 2, labels = c("B", "C")), 
  nrow = 2, 
  labels = "A"
) 


ggarrange(pl1, pl2,
          
          ggarrange(pl3, pl4, ncol= 2, labels = c('C', 'D')),
          
          nrow = 3, ncol = 1, labels = c('A', 'B'))

Figure

#==============================================================================#
