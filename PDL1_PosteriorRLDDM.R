#==============================================================================#
# Discr 1: RL models: Inference and Plotting
#==============================================================================#

# AUTHOR(s):    > FH

# DESCRIPTION:  > Inference on RL models and plots

#==============================================================================#

# Utility (probably not all used)

suppressMessages(suppressWarnings(library(ggplot2)))
suppressMessages(suppressWarnings(library(ggpubr)))
suppressMessages(suppressWarnings(library(ggridges)))
suppressMessages(suppressWarnings(library(plyr)))
suppressMessages(suppressWarnings(library(sm)))
suppressMessages(suppressWarnings(library(boot)))
suppressMessages(suppressWarnings(library(HDInterval)))
suppressMessages(suppressWarnings(library(tidyverse)))
suppressMessages(suppressWarnings(library(readxl)))
suppressMessages(suppressWarnings(library(rstudioapi)))
suppressMessages(suppressWarnings(library(dplyr)))
analysis_path = rstudioapi::getActiveDocumentContext()$path
setwd(dirname(analysis_path))
print(getwd())
path <- getwd()
scaleFUN2 <- function(x) sprintf("%.2f", x)     # Used to scale the y axis of the plots (helps with alignment)
scaleFUN1 <- function(x) sprintf("%.1f", x)

#==============================================================================#
# DATASETS
#==============================================================================#

# Data Model 10 (RLDDM, contingent)

data_M10 <- file.path(path,'HDDM10_Draws.csv')
dataM10 <- read.csv(data_M10, header = T, sep = ';') 
DFM10 <- as.data.frame(dataM10)

# Data Model 11 (Dual-RLDDM, contingent)

data_M11 <- file.path(path, 'HDDM11_Draws.csv')
dataM11 <- read.csv(data_M11, header = T, sep = ';') 
DFM11 <- as.data.frame(dataM11)

# Data Model 13 (RLDDM, non-contingent)

data_M13 <- file.path(path, 'HDDM13_Draws.csv')
dataM13 <- read.csv(data_M13, header = T, sep = ';') 
DFM13 <- as.data.frame(dataM13)

# Data Model 14 (Dual-RLDDM, non-contingent)

data_M14 <- file.path(path, 'HDDM14_Draws.csv')
dataM14 <- read.csv(data_M14, header = T, sep = ';') 
DFM14 <- as.data.frame(dataM14)

#==============================================================================#
# Back-transformation from unconstrained into 0-1 space and HDI
#==============================================================================#

# hyper-parameters draws ------------------------------------------------------#

# Model RLDDM-con
CONdrawsalpha <- DFM10$alpha
CONalpha <- inv.logit(CONdrawsalpha)
mean(CONalpha)
hdi(CONalpha, credMass = 0.95)

        # Mean: 0.4722546
        # HDI: Lower: 0.1806856 / Upper: 0.8270110 

# Model RLDDM-non
NONdrawsalpha <- DFM13$alpha
NONalpha <- inv.logit(NONdrawsalpha)
mean(NONalpha)
hdi(NONalpha, credMass = 0.95)

        # Mean: 0.07139801
        # HDI: Lower: 0.04849555 / Upper: 0.09609391

# Model Dual-RLDDM-con
CONdrawsnegalpha <- DFM11$alpha
CONdrawsposalpha <- DFM11$pos_alpha
CONalphaneg <- inv.logit(CONdrawsnegalpha)
CONalphapos <- inv.logit(CONdrawsposalpha)
mean(CONalphaneg)
mean(CONalphapos)
hdi(CONalphaneg, credMass = 0.95)
hdi(CONalphapos, credMass = 0.95)

        # Mean Alpha Neg: 0.06938521
        # HDI: Lower: 1.029758e-05 / Upper: 3.098830e-01 

        # Mean Alpha Pos: 0.8683635
        # HDI: Lower: 0.5838530 / Upper: 0.9999929  

# Model Dual-RLDDM-non
NONdrawsnegalpha <- DFM14$alpha
NONdrawsposalpha <- DFM14$pos_alpha
NONalphaneg <- inv.logit(NONdrawsnegalpha)
NONalphapos <- inv.logit(NONdrawsposalpha)
mean(NONalphaneg)
mean(NONalphapos)
hdi(NONalphaneg, credMass = 0.95)
hdi(NONalphapos, credMass = 0.95)

        # Mean Alpha Neg: 0.001665538
        # HDI: Lower: 9.384893e-07 / Upper: 5.352202e-03

        # Mean Alpha Pos: 0.2545311
        # HDI: Lower: 0.1331741 / Upper: 0.3907961

# IND level parameter draws ---------------------------------------------------#

# Back transforms all draws in the 0 1 space (we are here only interested in learning rates)
DF10_backT <- DFM10 %>% mutate_all(~ inv.logit(.))
DF11_backT <- DFM11 %>% mutate_all(~ inv.logit(.))
DF13_backT <- DFM13 %>% mutate_all(~ inv.logit(.))
DF14_backT <- DFM14 %>% mutate_all(~ inv.logit(.))

# Get back transormed mean values
sum10 <- DF10_backT %>% summarise_all(~ mean(.))
sum11 <- DF11_backT %>% summarise_all(~ mean(.))
sum13 <- DF13_backT %>% summarise_all(~ mean(.))
sum14 <- DF14_backT %>% summarise_all(~ mean(.))

# Individual pooled learning rates -----

# from contingent group
S2_A  <- sum10$alpha_subj.2     # Quite suboptimal should be read through a list 
S3_A  <- sum10$alpha_subj.3     # of which participant that remained in the analysis
S6_A  <- sum10$alpha_subj.6     # was in which reward group.
S7_A  <- sum10$alpha_subj.7
S9_A  <- sum10$alpha_subj.9
S10_A <- sum10$alpha_subj.10
S12_A <- sum10$alpha_subj.12
S13_A <- sum10$alpha_subj.13
S16_A <- sum10$alpha_subj.16
S19_A <- sum10$alpha_subj.19
S20_A <- sum10$alpha_subj.20
S23_A <- sum10$alpha_subj.23
S24_A <- sum10$alpha_subj.24
S26_A <- sum10$alpha_subj.26
S27_A <- sum10$alpha_subj.27
S29_A <- sum10$alpha_subj.29
S30_A <- sum10$alpha_subj.30
S33_A <- sum10$alpha_subj.33
S34_A <- sum10$alpha_subj.34
S37_A <- sum10$alpha_subj.37
S38_A <- sum10$alpha_subj.38
S40_A <- sum10$alpha_subj.40
S41_A <- sum10$alpha_subj.41
S43_A <- sum10$alpha_subj.43
S46_A <- sum10$alpha_subj.46
S47_A <- sum10$alpha_subj.47
S50_A <- sum10$alpha_subj.50
S51_A <- sum10$alpha_subj.51
S54_A <- sum10$alpha_subj.54

# from noncontingent group
S1_A  <- sum13$alpha_subj.1
S4_A  <- sum13$alpha_subj.4
S5_A  <- sum13$alpha_subj.5
S8_A  <- sum13$alpha_subj.8
S11_A <- sum13$alpha_subj.11
S14_A <- sum13$alpha_subj.14
S15_A <- sum13$alpha_subj.15
S17_A <- sum13$alpha_subj.17
S18_A <- sum13$alpha_subj.18
S21_A <- sum13$alpha_subj.21
S22_A <- sum13$alpha_subj.22
S25_A <- sum13$alpha_subj.25
S28_A <- sum13$alpha_subj.28
S31_A <- sum13$alpha_subj.31
S32_A <- sum13$alpha_subj.32
S35_A <- sum13$alpha_subj.35
S36_A <- sum13$alpha_subj.36
S39_A <- sum13$alpha_subj.39
S42_A <- sum13$alpha_subj.42
S44_A <- sum13$alpha_subj.44
S45_A <- sum13$alpha_subj.45
S48_A <- sum13$alpha_subj.48
S49_A <- sum13$alpha_subj.49
S52_A <- sum13$alpha_subj.52
S53_A <- sum13$alpha_subj.53

alphas <-c(S1_A, S2_A, S3_A, S4_A, S5_A, S6_A, S7_A, S8_A, S9_A ,S10_A,
           S11_A, S12_A, S13_A, S14_A, S15_A, S16_A, S17_A, S18_A, S19_A, S20_A,
           S21_A, S22_A, S23_A, S24_A, S25_A, S26_A, S27_A, S28_A, S29_A, S30_A,
           S31_A, S32_A, S33_A, S34_A, S35_A, S36_A, S37_A, S38_A, S39_A, S40_A,
           S41_A, S42_A, S43_A, S44_A, S45_A, S46_A, S47_A, S48_A, S49_A, S50_A,
           S51_A, S52_A, S53_A, S54_A)

# Individual differential learning rates -----

# from contingent group / omission learning
S2_Aneg  <- sum11$alpha_subj.2
S3_Aneg  <- sum11$alpha_subj.3    
S6_Aneg  <- sum11$alpha_subj.6     
S7_Aneg  <- sum11$alpha_subj.7
S9_Aneg  <- sum11$alpha_subj.9
S10_Aneg <- sum11$alpha_subj.10
S12_Aneg <- sum11$alpha_subj.12
S13_Aneg <- sum11$alpha_subj.13
S16_Aneg <- sum11$alpha_subj.16
S19_Aneg <- sum11$alpha_subj.19
S20_Aneg <- sum11$alpha_subj.20
S23_Aneg <- sum11$alpha_subj.23
S24_Aneg <- sum11$alpha_subj.24
S26_Aneg <- sum11$alpha_subj.26
S27_Aneg <- sum11$alpha_subj.27
S29_Aneg <- sum11$alpha_subj.29
S30_Aneg <- sum11$alpha_subj.30
S33_Aneg <- sum11$alpha_subj.33
S34_Aneg <- sum11$alpha_subj.34
S37_Aneg <- sum11$alpha_subj.37
S38_Aneg <- sum11$alpha_subj.38
S40_Aneg <- sum11$alpha_subj.40
S41_Aneg <- sum11$alpha_subj.41
S43_Aneg <- sum11$alpha_subj.43
S46_Aneg <- sum11$alpha_subj.46
S47_Aneg <- sum11$alpha_subj.47
S50_Aneg <- sum11$alpha_subj.50
S51_Aneg <- sum11$alpha_subj.51
S54_Aneg <- sum11$alpha_subj.54

# from contingent group / reward learning
S2_Apos  <- sum11$pos_alpha_subj.2
S3_Apos  <- sum11$pos_alpha_subj.3    
S6_Apos  <- sum11$pos_alpha_subj.6     
S7_Apos  <- sum11$pos_alpha_subj.7
S9_Apos  <- sum11$pos_alpha_subj.9
S10_Apos <- sum11$pos_alpha_subj.10
S12_Apos <- sum11$pos_alpha_subj.12
S13_Apos <- sum11$pos_alpha_subj.13
S16_Apos <- sum11$pos_alpha_subj.16
S19_Apos <- sum11$pos_alpha_subj.19
S20_Apos <- sum11$pos_alpha_subj.20
S23_Apos <- sum11$pos_alpha_subj.23
S24_Apos <- sum11$pos_alpha_subj.24
S26_Apos <- sum11$pos_alpha_subj.26
S27_Apos <- sum11$pos_alpha_subj.27
S29_Apos <- sum11$pos_alpha_subj.29
S30_Apos <- sum11$pos_alpha_subj.30
S33_Apos <- sum11$pos_alpha_subj.33
S34_Apos <- sum11$pos_alpha_subj.34
S37_Apos <- sum11$pos_alpha_subj.37
S38_Apos <- sum11$pos_alpha_subj.38
S40_Apos <- sum11$pos_alpha_subj.40
S41_Apos <- sum11$pos_alpha_subj.41
S43_Apos <- sum11$pos_alpha_subj.43
S46_Apos <- sum11$pos_alpha_subj.46
S47_Apos <- sum11$pos_alpha_subj.47
S50_Apos <- sum11$pos_alpha_subj.50
S51_Apos <- sum11$pos_alpha_subj.51
S54_Apos <- sum11$pos_alpha_subj.54

# from noncontingent group / omission learning
S1_Aneg  <- sum14$alpha_subj.1
S4_Aneg  <- sum14$alpha_subj.4
S5_Aneg  <- sum14$alpha_subj.5
S8_Aneg  <- sum14$alpha_subj.8
S11_Aneg <- sum14$alpha_subj.11
S14_Aneg <- sum14$alpha_subj.14
S15_Aneg <- sum14$alpha_subj.15
S17_Aneg <- sum14$alpha_subj.17
S18_Aneg <- sum14$alpha_subj.18
S21_Aneg <- sum14$alpha_subj.21
S22_Aneg <- sum14$alpha_subj.22
S25_Aneg <- sum14$alpha_subj.25
S28_Aneg <- sum14$alpha_subj.28
S31_Aneg <- sum14$alpha_subj.31
S32_Aneg <- sum14$alpha_subj.32
S35_Aneg <- sum14$alpha_subj.35
S36_Aneg <- sum14$alpha_subj.36
S39_Aneg <- sum14$alpha_subj.39
S42_Aneg <- sum14$alpha_subj.42
S44_Aneg <- sum14$alpha_subj.44
S45_Aneg <- sum14$alpha_subj.45
S48_Aneg <- sum14$alpha_subj.48
S49_Aneg <- sum14$alpha_subj.49
S52_Aneg <- sum14$alpha_subj.52
S53_Aneg <- sum14$alpha_subj.53

# from noncontingent group / reward learning
S1_Apos  <- sum14$pos_alpha_subj.1
S4_Apos  <- sum14$pos_alpha_subj.4
S5_Apos  <- sum14$pos_alpha_subj.5
S8_Apos  <- sum14$pos_alpha_subj.8
S11_Apos <- sum14$pos_alpha_subj.11
S14_Apos <- sum14$pos_alpha_subj.14 
S15_Apos <- sum14$pos_alpha_subj.15
S17_Apos <- sum14$pos_alpha_subj.17
S18_Apos <- sum14$pos_alpha_subj.18
S21_Apos <- sum14$pos_alpha_subj.21
S22_Apos <- sum14$pos_alpha_subj.22
S25_Apos <- sum14$pos_alpha_subj.25
S28_Apos <- sum14$pos_alpha_subj.28
S31_Apos <- sum14$pos_alpha_subj.31
S32_Apos <- sum14$pos_alpha_subj.32
S35_Apos <- sum14$pos_alpha_subj.35
S36_Apos <- sum14$pos_alpha_subj.36
S39_Apos <- sum14$pos_alpha_subj.39
S42_Apos <- sum14$pos_alpha_subj.42
S44_Apos <- sum14$pos_alpha_subj.44
S45_Apos <- sum14$pos_alpha_subj.45
S48_Apos <- sum14$pos_alpha_subj.48
S49_Apos <- sum14$pos_alpha_subj.49
S52_Apos <- sum14$pos_alpha_subj.52
S53_Apos <- sum14$pos_alpha_subj.53

#Append

alpha_negs <-c(S1_Aneg, S2_Aneg, S3_Aneg, S4_Aneg, S5_Aneg, S6_Aneg, S7_Aneg, S8_Aneg, S9_Aneg ,S10_Aneg,
              S11_Aneg, S12_Aneg, S13_Aneg, S14_Aneg, S15_Aneg, S16_Aneg, S17_Aneg, S18_Aneg, S19_Aneg, S20_Aneg,
              S21_Aneg, S22_Aneg, S23_Aneg, S24_Aneg, S25_Aneg, S26_Aneg, S27_Aneg, S28_Aneg, S29_Aneg, S30_Aneg,
              S31_Aneg, S32_Aneg, S33_Aneg, S34_Aneg, S35_Aneg, S36_Aneg, S37_Aneg, S38_Aneg, S39_Aneg, S40_Aneg,
              S41_Aneg, S42_Aneg, S43_Aneg, S44_Aneg, S45_Aneg, S46_Aneg, S47_Aneg, S48_Aneg, S49_Aneg, S50_Aneg,
              S51_Aneg, S52_Aneg, S53_Aneg, S54_Aneg)

alpha_poss <-c(S1_Apos, S2_Apos, S3_Apos, S4_Apos, S5_Apos, S6_Apos, S7_Apos, S8_Apos, S9_Apos ,S10_Apos,
              S11_Apos, S12_Apos, S13_Apos, S14_Apos, S15_Apos, S16_Apos, S17_Apos, S18_Apos, S19_Apos, S20_Apos,
              S21_Apos, S22_Apos, S23_Apos, S24_Apos, S25_Apos, S26_Apos, S27_Apos, S28_Apos, S29_Apos, S30_Apos,
              S31_Apos, S32_Apos, S33_Apos, S34_Apos, S35_Apos, S36_Apos, S37_Apos, S38_Apos, S39_Apos, S40_Apos,
              S41_Apos, S42_Apos, S43_Apos, S44_Apos, S45_Apos, S46_Apos, S47_Apos, S48_Apos, S49_Apos, S50_Apos,
              S51_Apos, S52_Apos, S53_Apos, S54_Apos)

#==============================================================================#
# Inference (group level)
#==============================================================================#

# RLDDM Models ----------------------------------------------------------------#

# Posterior difference density Alpha CON- Alpha NON 
RLdiff <- CONalpha - NONalpha
mean(RLdiff)
hdi(RLdiff, credMass = 0.95)

    # Mean: 0.4008565
    # HDI: Lower: 0.1105847 / Upper: 0.7591065 

# Dual RLDDM Models -----------------------------------------------------------#

# Posterior difference density Pos alpha - Neg alpha (CONTINGENT)
RLCONdiff <- CONalphapos - CONalphaneg
mean(RLCONdiff)
hdi(RLCONdiff, credMass = 0.95)

    # Mean: 0.7989783
    # Lower: 0.4591693  / Upper: 0.9989975 

# Posterior difference density Pos alpha - Neg alpha (NON-CONTINGENT)
RLNONdiff <- NONalphapos - NONalphaneg
mean(RLNONdiff)
hdi(RLNONdiff)

    # Mean: 0.2528656
    # Lower: 0.1300721 / Upper: 0.3873309 

#==============================================================================#
# PLOTS: Posterior difference distribution
#==============================================================================#

# Plot 1: Density difference simple RL ----------------------------------------#

DF_plot1 <- tibble(RLdiff)
pl1 <- ggplot(DF_plot1, aes(x = RLdiff, y = 0, fill = stat(quantile))) + 
              geom_density_ridges_gradient(quantile_lines = TRUE, quantile_fun = hdi, vline_linetype = 2) +
              geom_vline(xintercept = 0, color = 'red', size = 1) +
              labs(y = 'Difference Density', x = 'Contingent - Non Contingent') +
              scale_fill_manual(values = alpha(c("transparent", "darkgrey", "transparent"), 0.5), guide = "none") +
              scale_y_continuous(labels=scaleFUN1) +
              theme_classic()
pl1

# Plot 2: Density difference dual RL CON --------------------------------------#

DF_plot2 <- tibble(RLCONdiff)
pl2 <- ggplot(DF_plot2, aes(x = RLCONdiff, y = 0, fill = stat(quantile))) + 
              geom_density_ridges_gradient(quantile_lines = TRUE, quantile_fun = hdi, vline_linetype = 2) +
              geom_vline(xintercept = 0, color = 'red', size = 1) +
              labs(y = 'Difference Density', x = 'Contingent: α pos - α neg') +
              scale_fill_manual(values = alpha(c("transparent", "blue", "transparent"), 0.5), guide = "none") +
              scale_y_continuous(labels=scaleFUN1) +
              theme_classic()
pl2

# Plot 3: Density difference dual RL NON --------------------------------------#

DF_plot3 <- tibble(RLNONdiff)
pl3 <- ggplot(DF_plot3, aes(x = RLNONdiff, y = 0, fill = stat(quantile))) + 
              geom_density_ridges_gradient(quantile_lines = TRUE, quantile_fun = hdi, vline_linetype = 2) +
              geom_vline(xintercept = 0, color = 'red', size = 1) +
              labs(y = 'Difference Density', x = 'Non-Contingent: α pos - α neg') +
              scale_fill_manual(values = alpha(c("transparent", "chocolate1", "transparent"), 0.5), guide = "none") +
              scale_y_continuous(labels=scaleFUN1) +
              theme_classic()
pl3

#==============================================================================#
# Post Hoc analyses: Corr ind parameter and performance delta
#==============================================================================#


data_task <- read.csv("PDL_data_discrimination_all.csv", header = T, sep = ";")
st_half_dat <- subset(data_task, reinforcement == "no")
nd_half_dat <- subset(data_task, reinforcement == "reinforcement")
# ignore warnings
perf_first <- st_half_dat %>%
                    group_by(subj_idx) %>%
                    summarise_all(~mean(.)) # response collumn is coded 1 correct 0 false so mean returns proportion 
#ignore warnings
perf_second <- nd_half_dat %>%
                    group_by(subj_idx) %>%
                    summarise_all(~mean(.))

performance_first_half <- perf_first$response
performance_second_half <- perf_second$response

delta_data <- data.frame(performance_first_half, performance_second_half)
#
delta_data$delta <- delta_data$performance_second_half - delta_data$performance_first_half # Estimation of the individual change in performance from half 1 to 2
#
delta_data$LR <- alphas
delta_data$LR_pos <- alpha_poss
delta_data$LR_neg <- alpha_negs

# Reward group allocation
delta_data$group <- c('NC','CR','CR','NC','NC','CR','CR','NC','CR','CR',
                      'NC','CR','CR','NC','NC','CR','NC','NC','CR','CR',
                      'NC','NC','CR','CR','NC','CR','CR','NC','CR','CR',
                      'NC','NC','CR','CR','NC','NC','CR','CR','NC','CR',
                      'CR','NC','CR','NC','NC','CR','CR','NC','NC','CR',
                      'CR','NC','NC','CR')


delta_data$Reward <- as.factor(delta_data$group)
#
levels(delta_data$Reward)
levels(delta_data$Reward) <- c('Contingent', 'Non-Contingent')
#
DF_cor_plots <- tibble(delta_data)


#Plot 4

pl4 <- ggplot(DF_cor_plots, aes(x = LR, y = delta, color = Reward)) +
              geom_point() +
              geom_smooth(method = lm) +
              labs(y = 'Performance Change', x = 'Learning Rate: α') +
              scale_color_manual(values = c('blue', 'chocolate1')) +
              stat_cor(aes(label = ..r.label..)) +
              theme_classic() +
              theme(legend.position='none')
pl4

#Plot 5

pl5 <- ggplot(DF_cor_plots, aes(x = LR_pos, y = delta, color = Reward)) +
              geom_point() +
              geom_smooth(method = lm) +
              labs(y = 'Performance Change', x = 'Learning Rate: α pos') +
              scale_color_manual(values = c('blue', 'chocolate1')) +
              stat_cor(aes(label = ..r.label..)) +
              theme_classic() +
              theme(legend.position='none')
pl5

#plot 6

pl6 <- ggplot(DF_cor_plots, aes(x = LR_neg, y = delta, color = Reward)) +
              geom_point() +
              geom_smooth(method = lm) +
              labs(y = 'Performance Change', x = 'Learning Rate: α neg ') +
              scale_color_manual(values = c('blue', 'chocolate1')) +
              stat_cor(aes(label = ..r.label..)) +
              theme_classic() +
              theme(legend.position='none')
pl6

#==============================================================================#
# Final Figure
#==============================================================================#

figure <- ggarrange(pl1, pl2, pl3,
                    pl4, pl5, pl6,
                    labels = c('A', 'B', 'C', 'D', 'E', 'F', 'G'),
                    common.legend = TRUE, legend = 'bottom',
                    ncol = 3, nrow = 2)
figure

#==============================================================================#