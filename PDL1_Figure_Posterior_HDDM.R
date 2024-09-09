#==============================================================================#
# Discr 1: Figure: HDDM model Parameters
#==============================================================================#

# AUTHOR(s):    > FH

#==============================================================================#

# Packages

suppressMessages(suppressWarnings(library(ggplot2)))
suppressMessages(suppressWarnings(library(ggpubr)))
suppressMessages(suppressWarnings(library(plyr)))
suppressMessages(suppressWarnings(library(grid)))
suppressMessages(suppressWarnings(library(rstudioapi)))
analysis_path = rstudioapi::getActiveDocumentContext()$path
setwd(dirname(analysis_path))
print(getwd())

# Data

analysis_dir <- getwd()
data_file <- file.path(analysis_dir, 'HDDM8_Draws.csv')   #csv of vectors of posterior draws from model HDDM8
data <- read.csv(data_file, header = T, sep = ';') 
DF <- as.data.frame(data)

# Color pallette

  # Blue = 'darkblue'
  # Orange = 'chocolate1'
  # Green = 'forestgreen'

# Vector of groups

n_draws <- 15000                 #vector of total number of posterior draws used in estimation of each parameter
Grp_0_nor <- rep(1,n_draws)
Grp_0_non <- rep(2,n_draws)
Grp_0_con <- rep(3,n_draws)
Reward <- c(Grp_0_nor, Grp_0_non, Grp_0_con)
Reward <- as.factor(Reward)
levels(Reward) <- c('No Reward', 'Non Contingent', 'Contingent')

#==============================================================================#
# Differences between drift rates
#==============================================================================#

# Within 0°C pulse ------------------------------------------------------------#

# Vector of Draws
V_0_nor <- DF$v.NR.control.
V_0_non <- DF$v.NC.control.
V_0_con <- DF$v.CR.control.
P1_draws <- c(V_0_nor, V_0_non, V_0_con)

# Data
dataP1 <- data.frame(Reward, P1_draws)

# Get mean posterior density
mu1 <- ddply(dataP1, "Reward", summarise, grp.mean=mean(P1_draws))

pl1 <- ggplot(dataP1, aes(x = P1_draws, color = Reward, fill = Reward)) +
              geom_density(alpha = 0.2) +
              geom_vline(data=mu1, aes(xintercept=grp.mean, color=Reward), linetype = 'dashed') +
              labs(y = 'Density', x = 'Drift Rate') +
              scale_fill_manual(values=c('forestgreen', 'chocolate1', 'blue')) +
              scale_color_manual(values=c('forestgreen', 'chocolate1', 'blue')) +
              xlim(-1, 4) +
              theme_classic() +
              theme(legend.position='top')
pl1

# Within 0.2°C pulse ----------------------------------------------------------#

# Vector of Draws
V_2_nor <- DF$v.NR.difficult.
V_2_non <- DF$v.NC.difficult.
V_2_con <- DF$v.CR.difficult.
P2_draws <- c(V_2_nor, V_2_non, V_2_con)

# Data
dataP2 <- data.frame(Reward, P2_draws)

# Get the mean posterior density
mu2 <- ddply(dataP2, "Reward", summarise, grp.mean=mean(P2_draws))
#
bar1 <- grobTree(textGrob("___", x=0.43,  y=0.85, hjust=0, gp=gpar(col="black", fontsize=12, fontface="italic")))
pr1 <- grobTree(textGrob("Pr = 0.974", x=0.40,  y=0.86, hjust=0, gp=gpar(col="black", fontsize=8, fontface="italic")))
#
bar2 <- grobTree(textGrob("____", x=0.41,  y=0.75, hjust=0, gp=gpar(col="black", fontsize=12, fontface="italic")))
pr2 <- grobTree(textGrob("Pr = 0.972", x=0.40,  y=0.76, hjust=0, gp=gpar(col="black", fontsize=8, fontface="italic")))
#

pl2 <- ggplot(dataP2, aes(x = P2_draws, color = Reward, fill = Reward)) +
              geom_density(alpha = 0.2) +
              geom_vline(data=mu2, aes(xintercept=grp.mean, color=Reward), linetype = 'dashed') +
              labs(y = 'Density', x = 'Drift Rate') +
              scale_fill_manual(values=c('forestgreen', 'chocolate1', 'blue')) +
              scale_color_manual(values=c('forestgreen', 'chocolate1', 'blue')) +
              xlim(-1, 4) +
              theme_classic() +
              theme(legend.position='top') +
              annotation_custom(bar1) +
              annotation_custom(pr1) +
              annotation_custom(bar2) +
              annotation_custom(pr2)
pl2

# Within 0.4°C pulse ----------------------------------------------------------#

# Vector of Draws
V_4_nor <- DF$v.NR.easy.
V_4_non <- DF$v.NC.easy.
V_4_con <- DF$v.CR.easy.
P3_draws <- c(V_4_nor, V_4_non, V_4_con)

# Data
dataP3 <- data.frame(Reward, P3_draws)


# Get the mean posterior density
mu3 <- ddply(dataP3, "Reward", summarise, grp.mean=mean(P3_draws))

bar1 <- grobTree(textGrob("____", x=0.645,  y=0.85, hjust=0, gp=gpar(col="black", fontsize=12, fontface="italic")))
pr1 <- grobTree(textGrob("Pr = 0.985", x=0.66,  y=0.86, hjust=0, gp=gpar(col="black", fontsize=8, fontface="italic")))
#
bar2 <- grobTree(textGrob("_________", x=0.55,  y=0.95, hjust=0, gp=gpar(col="black", fontsize=12, fontface="italic")))
pr2 <- grobTree(textGrob("Pr > 0.999", x=0.57,  y=0.96, hjust=0, gp=gpar(col="black", fontsize=8, fontface="italic")))
#
bar3 <- grobTree(textGrob("___", x=0.545,  y=0.85, hjust=0, gp=gpar(col="black", fontsize=12, fontface="italic")))
pr3 <- grobTree(textGrob("Pr = 0.968", x=0.49,  y=0.86, hjust=0, gp=gpar(col="black", fontsize=8, fontface="italic")))

pl3 <- ggplot(dataP3, aes(x = P3_draws, color = Reward, fill = Reward)) +
              geom_density(alpha = 0.2) +
              geom_vline(data=mu3, aes(xintercept=grp.mean, color=Reward), linetype = 'dashed') +
              labs(y = 'Density', x = 'Drift Rate') +
              scale_fill_manual(values=c('forestgreen', 'chocolate1', 'blue')) +
              scale_color_manual(values=c('forestgreen', 'chocolate1', 'blue')) +
              theme_classic() +
              xlim(-1, 4) +
              theme(legend.position='top') +
              annotation_custom(bar1) +
              annotation_custom(pr1) +
              annotation_custom(bar2) +
              annotation_custom(pr2) +
              annotation_custom(bar3) +
              annotation_custom(pr3)
pl3

#==============================================================================#
# Differences between boundaries
#==============================================================================#

# Within 0°C pulse ------------------------------------------------------------#

# Vector of Draws
A_0_nor <- DF$a.NR.control.
A_0_non <- DF$a.NC.control.
A_0_con <- DF$a.CR.control.
P4_draws <- c(A_0_nor, A_0_non, A_0_con)

# Data
dataP4 <- data.frame(Reward, P4_draws)

# Get mean posterior density
mu4 <- ddply(dataP4, "Reward", summarise, grp.mean=mean(P4_draws))

bar1 <- grobTree(textGrob("_______", x=0.43,  y=0.85, hjust=0, gp=gpar(col="black", fontsize=12, fontface="italic")))
pr1 <- grobTree(textGrob("Pr = 0.992", x=0.44,  y=0.86, hjust=0, gp=gpar(col="black", fontsize=8, fontface="italic")))
#
bar2 <- grobTree(textGrob("________________", x=0.43,  y=0.95, hjust=0, gp=gpar(col="black", fontsize=12, fontface="italic")))
pr2 <- grobTree(textGrob("Pr > 0.999", x=0.53,  y=0.96, hjust=0, gp=gpar(col="black", fontsize=8, fontface="italic")))
#
bar3 <- grobTree(textGrob("_______", x=0.615,  y=0.85, hjust=0, gp=gpar(col="black", fontsize=12, fontface="italic")))
pr3 <- grobTree(textGrob("Pr = 0.995", x=0.63,  y=0.86, hjust=0, gp=gpar(col="black", fontsize=8, fontface="italic")))


pl4 <- ggplot(dataP4, aes(x = P4_draws, color = Reward, fill = Reward)) +
              geom_density(alpha = 0.2) +
              geom_vline(data=mu4, aes(xintercept=grp.mean, color=Reward), linetype = 'dashed') +
              labs(y = 'Density', x = 'Boundary Separation') +
              scale_fill_manual(values=c('forestgreen', 'chocolate1', 'blue')) +
              scale_color_manual(values=c('forestgreen', 'chocolate1', 'blue')) +
              xlim(0.8, 1.7) +
              theme_classic() +
              theme(legend.position='top') +
              annotation_custom(bar1) +
              annotation_custom(pr1) +
              annotation_custom(bar2) +
              annotation_custom(pr2) +
              annotation_custom(bar3) +
              annotation_custom(pr3)
pl4

# Within 0.2°C pulse ----------------------------------------------------------#

# Vector of Draws
A_2_nor <- DF$a.NR.difficult.
A_2_non <- DF$a.NC.difficult.
A_2_con <- DF$a.CR.difficult.
P5_draws <- c(A_2_nor, A_2_non, A_2_con)

# Data
dataP5 <- data.frame(Reward, P5_draws)

# Get the mean posterior density
mu5 <- ddply(dataP5, "Reward", summarise, grp.mean=mean(P5_draws))

bar1 <- grobTree(textGrob("_________", x=0.31,  y=0.85, hjust=0, gp=gpar(col="black", fontsize=12, fontface="italic")))
pr1 <- grobTree(textGrob("Pr = 0.999", x=0.35,  y=0.86, hjust=0, gp=gpar(col="black", fontsize=8, fontface="italic")))
#
bar2 <- grobTree(textGrob("__________________", x=0.31,  y=0.95, hjust=0, gp=gpar(col="black", fontsize=12, fontface="italic")))
pr2 <- grobTree(textGrob("Pr > 0.999", x=0.44,  y=0.96, hjust=0, gp=gpar(col="black", fontsize=8, fontface="italic")))
#
bar3 <- grobTree(textGrob("_______", x=0.54,  y=0.85, hjust=0, gp=gpar(col="black", fontsize=12, fontface="italic")))
pr3 <- grobTree(textGrob("Pr = 0.993", x=0.55,  y=0.86, hjust=0, gp=gpar(col="black", fontsize=8, fontface="italic")))

pl5 <- ggplot(dataP5, aes(x = P5_draws, color = Reward, fill = Reward)) +
              geom_density(alpha = 0.2) +
              geom_vline(data=mu5, aes(xintercept=grp.mean, color=Reward), linetype = 'dashed') +
              labs(y = 'Density', x = 'Boundary Separation') +
              scale_fill_manual(values=c('forestgreen', 'chocolate1', 'blue')) +
              scale_color_manual(values=c('forestgreen', 'chocolate1', 'blue')) +
              xlim(0.8, 1.7) +            
              theme_classic() +
              theme(legend.position='top') +
              annotation_custom(bar1) +
              annotation_custom(pr1) +
              annotation_custom(bar2) +
              annotation_custom(pr2) +
              annotation_custom(bar3) +
              annotation_custom(pr3)
pl5

# Within 0.4°C pulse ----------------------------------------------------------#

# Vector of Draws
A_4_nor <- DF$a.NR.easy.
A_4_non <- DF$a.NC.easy.
A_4_con <- DF$a.CR.easy.
P6_draws <- c(A_4_nor, A_4_non, A_4_con)

# Data
dataP6 <- data.frame(Reward, P6_draws)

# Get the mean posterior density
mu6 <- ddply(dataP6, "Reward", summarise, grp.mean=mean(P6_draws))

bar1 <- grobTree(textGrob("______", x=0.31,  y=0.85, hjust=0, gp=gpar(col="black", fontsize=12, fontface="italic")))
pr1 <- grobTree(textGrob("Pr = 0.978", x=0.31,  y=0.86, hjust=0, gp=gpar(col="black", fontsize=8, fontface="italic")))
#
bar2 <- grobTree(textGrob("___________________", x=0.30,  y=0.95, hjust=0, gp=gpar(col="black", fontsize=12, fontface="italic")))
pr2 <- grobTree(textGrob("Pr > 0.999", x=0.42,  y=0.96, hjust=0, gp=gpar(col="black", fontsize=8, fontface="italic")))
#
bar3 <- grobTree(textGrob("__________", x=0.48,  y=0.85, hjust=0, gp=gpar(col="black", fontsize=12, fontface="italic")))
pr3 <- grobTree(textGrob("Pr = 0.999", x=0.53,  y=0.86, hjust=0, gp=gpar(col="black", fontsize=8, fontface="italic")))

pl6 <- ggplot(dataP6, aes(x = P6_draws, color = Reward, fill = Reward)) +
              geom_density(alpha = 0.2) +
              geom_vline(data=mu6, aes(xintercept=grp.mean, color=Reward), linetype = 'dashed') +
              labs(y = 'Density', x = 'Boundary Separation') +
              scale_fill_manual(values=c('forestgreen', 'chocolate1', 'blue')) +
              scale_color_manual(values=c('forestgreen', 'chocolate1', 'blue')) +
              xlim(0.8, 1.7) +            
              theme_classic() +
              theme(legend.position='top') +
              annotation_custom(bar1) +
              annotation_custom(pr1) +
              annotation_custom(bar2) +
              annotation_custom(pr2) +
              annotation_custom(bar3) +
              annotation_custom(pr3)
pl6


#==============================================================================#
# Differences between non-decision times
#==============================================================================#

# Within 0°C pulse ------------------------------------------------------------#

# Vector of Draws
T_0_nor <- DF$t.NR.control.
T_0_non <- DF$t.NC.control.
T_0_con <- DF$t.CR.control.
P7_draws <- c(T_0_nor, T_0_non, T_0_con)

# Data
dataP7 <- data.frame(Reward, P7_draws)

# Get mean posterior density
mu7 <- ddply(dataP7, "Reward", summarise, grp.mean=mean(P7_draws))

bar1 <- grobTree(textGrob("__________", x=0.395,  y=0.85, hjust=0, gp=gpar(col="black", fontsize=12, fontface="italic")))
pr1 <- grobTree(textGrob("Pr = 0.987", x=0.43,  y=0.86, hjust=0, gp=gpar(col="black", fontsize=8, fontface="italic")))
#
bar2 <- grobTree(textGrob("____________", x=0.395,  y=0.95, hjust=0, gp=gpar(col="black", fontsize=12, fontface="italic")))
pr2 <- grobTree(textGrob("Pr = 0.998", x=0.45,  y=0.96, hjust=0, gp=gpar(col="black", fontsize=8, fontface="italic")))
#

pl7 <- ggplot(dataP7, aes(x = P7_draws, color = Reward, fill = Reward)) +
              geom_density(alpha = 0.2) +
              geom_vline(data=mu7, aes(xintercept=grp.mean, color=Reward), linetype = 'dashed') +
              labs(y = 'Density', x = 'Non-Decision Times') +
              scale_fill_manual(values=c('forestgreen', 'chocolate1', 'blue')) +
              scale_color_manual(values=c('forestgreen', 'chocolate1', 'blue')) +
              xlim(0.24, 0.36) +            
              theme_classic() +
              theme(legend.position='top') +
              annotation_custom(bar1) +
              annotation_custom(pr1) +
              annotation_custom(bar2) +
              annotation_custom(pr2)
pl7

# Within 0.2°C pulse ----------------------------------------------------------#

# Vector of Draws
T_2_nor <- DF$t.NR.difficult.
T_2_non <- DF$t.NC.difficult.
T_2_con <- DF$t.CR.difficult.
P8_draws <- c(T_2_nor, T_2_non, T_2_con)

# Data
dataP8 <- data.frame(Reward, P8_draws)

# Get the mean posterior density
mu8 <- ddply(dataP8, "Reward", summarise, grp.mean=mean(P8_draws))

bar1 <- grobTree(textGrob("__________", x=0.36,  y=0.85, hjust=0, gp=gpar(col="black", fontsize=12, fontface="italic")))
pr1 <- grobTree(textGrob("Pr = 0.987", x=0.41,  y=0.86, hjust=0, gp=gpar(col="black", fontsize=8, fontface="italic")))

pl8 <- ggplot(dataP8, aes(x = P8_draws, color = Reward, fill = Reward)) +
              geom_density(alpha = 0.2) +
              geom_vline(data=mu8, aes(xintercept=grp.mean, color=Reward), linetype = 'dashed') +
              labs(y = 'Density', x = 'Non-Decision Times') +
              scale_fill_manual(values=c('forestgreen', 'chocolate1', 'blue')) +
              scale_color_manual(values=c('forestgreen', 'chocolate1', 'blue')) +
              xlim(0.24, 0.36) +             
              theme_classic() +
              theme(legend.position='top') +
              annotation_custom(bar1) +
              annotation_custom(pr1)
pl8

# Within 0.4°C pulse ----------------------------------------------------------#

# Vector of Draws
T_4_nor <- DF$t.NR.easy.
T_4_non <- DF$t.NC.easy.
T_4_con <- DF$t.CR.easy.
P9_draws <- c(T_4_nor, T_4_non, T_4_con)

# Data
dataP9 <- data.frame(Reward, P9_draws)

bar1 <- grobTree(textGrob("___________", x=0.315,  y=0.85, hjust=0, gp=gpar(col="black", fontsize=12, fontface="italic")))
pr1 <- grobTree(textGrob("Pr = 0.997", x=0.355,  y=0.86, hjust=0, gp=gpar(col="black", fontsize=8, fontface="italic")))
#
bar2 <- grobTree(textGrob("_______", x=0.40,  y=0.75, hjust=0, gp=gpar(col="black", fontsize=12, fontface="italic")))
pr2 <- grobTree(textGrob("Pr = 0.962", x=0.405,  y=0.76, hjust=0, gp=gpar(col="black", fontsize=8, fontface="italic")))


# Get the mean posterior density
mu9 <- ddply(dataP9, "Reward", summarise, grp.mean=mean(P9_draws))

pl9 <- ggplot(dataP9, aes(x = P9_draws, color = Reward, fill = Reward)) +
              geom_density(alpha = 0.2) +
              geom_vline(data=mu9, aes(xintercept=grp.mean, color=Reward), linetype = 'dashed') +
              labs(y = 'Density', x = 'Non-Decision Times') +
              scale_fill_manual(values=c('forestgreen', 'chocolate1', 'blue')) +
              scale_color_manual(values=c('forestgreen', 'chocolate1', 'blue')) +
              xlim(0.24, 0.36) +             
              theme_classic() +
              theme(legend.position='top') +
              annotation_custom(bar1) +
              annotation_custom(pr1) +
              annotation_custom(bar2) +
              annotation_custom(pr2) 
pl9

#==============================================================================#
# Combination 
#==============================================================================#

figure <- ggarrange(pl1, pl2, pl3,
                    pl4, pl5, pl6,
                    pl7, pl8, pl9,
                    labels = c('A', 'B', 'C'),
                    common.legend = TRUE, legend = 'top',
                    ncol = 3, nrow = 3)
figure

#==============================================================================#