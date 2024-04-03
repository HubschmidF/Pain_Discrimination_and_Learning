#==============================================================================#
# Figure: Descriptives Choice reaction
#==============================================================================#

# AUTHOR(s):    > FH

#==============================================================================#

suppressMessages(suppressWarnings(library(ggplot2)))  
suppressMessages(suppressWarnings(library(ggpubr)))   
suppressMessages(suppressWarnings(library(rstudioapi)))
analysis_path = rstudioapi::getActiveDocumentContext()$path
setwd(dirname(analysis_path))
print(getwd())
data <- read.csv("PDL_data_discrimination_all.csv", header = T, sep = ";")

#==============================================================================#
# Curation
#==============================================================================#

# For the boxplots
str(data)
data$response <- as.factor(data$response)
data$Reward <- as.factor(data$reward)
levels(data$Reward)
levels(data$Reward) <- c('Contingent', 'Non-Contingent', 'No-Reward')
data$stim<-factor(data$stim)
levels(data$stim)<-c("+0°C", "+0.2°C", "+0.4°C")
data$Pulse <- data$stim

# For the histograms
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
levels(DFplot$Pulse) <- c('+0.4°C','+0.2°C','+0°C', '+0.2°C', '+0.4°C')
str(DFplot)

#==============================================================================#
# Histograms of Choice-Reaction
#==============================================================================#

levels(DFplot$Reward)
levels(DFplot$Pulse)

# Dependant on Pulse conditon -------------------------------------------------#

pl1 <- ggplot(DFplot, aes(x = RT, color = Pulse, fill = Pulse)) +
              geom_histogram( bins = 100, alpha = 0.1, position = 'identity') +
              labs(y = 'Counts', x = 'Reaction Time') +
              scale_color_manual(values=c("turquoise", 'violetred1', "purple1")) +
              scale_fill_manual(values=c("turquoise", 'violetred1', "purple1")) +
              theme_classic() +
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

levels(data$Reward)

# RT --------------------------------------------------------------------------#

pl3 <- ggplot(data, aes(x=Pulse, y=rt, fill=Reward)) +
              geom_boxplot(notch = T, outlier.size = 1.5) +
              labs(y = "Reaction time", x = "Pulse condition") +
              scale_fill_manual(values=c('blue', "chocolate1", "forestgreen")) +
              theme_classic()  +
              theme(legend.position='none')
pl3

# Accuracy --------------------------------------------------------------------#

pl4 <- ggplot(data, aes(x=Pulse, y=prop, fill=Reward)) +
              geom_boxplot(notch = T, outlier.size = 1.5) +
              labs(y = "Prop. of Correct Choices", x = "Pulse condition") +
              scale_fill_manual(values=c("blue", "chocolate1", "forestgreen")) +
              theme_classic()  +
              theme(legend.position='none')
pl4

#==============================================================================#
# Figure
#==============================================================================#

Figure <- ggarrange(pl1, pl2,
          ggarrange(pl3, pl4, ncol= 2, labels = c('C', 'D')),
          nrow = 3, ncol = 1, labels = c('A', 'B'))
Figure

#==============================================================================#