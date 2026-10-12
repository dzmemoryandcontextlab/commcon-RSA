library(dplyr)
library(readr)
library(lme4)
library(lmerTest)
library(ggdist)
library(purrr)
library(stringr)
library(ggplot2)
library(tibble)
library(emmeans)


#########################
### CORRELATION DATA ###
########################

# Define paths/subjects
subject_numbers <- c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16",
                     "18", "19", "21", "22", "23", "24", "25", "27", "28", "29", "30", "31", "32", "33", "20", "34")

subject_ids <- paste0("sub-", subject_numbers)

base_path <- "/Volumes/BrusselsGriffon/CommCon/SPM_results/Model3_POST-PRE"


# List of ROIs
rois <- c(
  "left_Hippocampus_MNI-BOLD",
  "right_Hippocampus_MNI-BOLD",
  "left_A1_mask_resampled",
  "right_A1_mask_resampled", 
  "left_PHC_MNI-BOLD",
  "right_PHC_MNI-BOLD",
  "left_PRC_MNI-BOLD",
  "right_PRC_MNI-BOLD", 
  "vmPFC_right_resampled",
  "vmPFC_left_resampled",
  "PMC_3mm_resampled_bin")


# Conditions of interest
conditions <- c(
  "same_show_episode",
  "same_show_diff_episode",
  "diff_show")


# Function to load condition data for each ROI
load_condition_data <- function(condition, roi, subject_ids, base_path) {
  
  all_corrs <- list()
  
  for (sub in subject_ids) {
    
    # Path 
    file_path <- file.path(
      base_path,
      paste0(
        "Model3_", sub, "_", roi,
        "_DIFF_", condition, "_corrs.csv"))
    
    # Create df
    df <- read_csv(
      file_path,
      show_col_types = FALSE) %>%
      mutate(
        Subject = sub,
        Condition = condition,
        ROI = roi)
    
    all_corrs[[sub]] <- df}
  
  # Combine all subjects for the given condition and ROI
  bind_rows(all_corrs)
}


# Create empty list to store the data for each ROI
all_data <- list()


# Loop over ROIs and load data for each
for (roi in rois) {
  
  roi_data <- map_dfr(
    conditions,
    ~load_condition_data(
      .x,
      roi,
      subject_ids,
      base_path))
  
  # Append the data for the current ROI to the list
  all_data[[roi]] <- roi_data
}


# Combine all data across ROIs into one data frame
corrs_data <- bind_rows(all_data)

# Check
print(head(corrs_data))

# Add columns for hemisphere and ROI (called region)
corrs_data <- corrs_data %>%
  mutate(
    
    # Clean ROI names
    ROI = str_remove_all(ROI,"(_mask_resampled|_resampled|_MNI-BOLD|_3mm_resampled_bin)"),
    
    # Extract hemisphere 
    Hemisphere = str_extract(ROI,"left|right"),
    
    # Region
    Region = str_remove_all( ROI, "left_|right_|_left|_right|right-|left-"))

# Check
print(head(corrs_data))


# Create pair_id
corrs_data <- corrs_data %>%
  mutate(
    pair_id_new = paste(
      Commercial1,
      Commercial2,
      sep = "_" ))

# Delete sub- from subject id
corrs_data <- corrs_data %>%
  mutate(Subject = str_remove(Subject,"sub-" ))

# Check
head(corrs_data)

# Split into 3 dfs based on condition
same_show_episode_corrs <- corrs_data %>%
  filter(Condition == "same_show_episode")

same_show_diff_episode_corrs <- corrs_data %>%
  filter(Condition == "same_show_diff_episode")

diff_show_corrs <- corrs_data %>%
  filter(Condition == "diff_show")


# Compute subject means
CORRS_subject_condition_roi_means <- corrs_data %>%
  group_by(Subject, Condition, Region) %>%
  summarise(
    mean_correlation = mean(
      Correlation,
      na.rm = TRUE),
    .groups = "drop")

# Check
head(CORRS_subject_condition_roi_means)

######################################
### CORRELATION DATA RAW FOR PLOTS ###
######################################

# Define paths
subject_numbers <- c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16",
                     "18", "19", "21", "22", "23", "24", "25", "27", "28", "29", "30", "31", "32", "33", "20", "34")

subject_ids <- paste0("sub-", subject_numbers)

base_path <- "/Volumes/BrusselsGriffon/CommCon/SPM_results/Model3_POST-PRE"


# List of ROIs
rois <- c(
  "left_Hippocampus_MNI-BOLD",
  "right_Hippocampus_MNI-BOLD",
  "left_A1_mask_resampled",
  "right_A1_mask_resampled", 
  "left_PHC_MNI-BOLD",
  "right_PHC_MNI-BOLD",
  "left_PRC_MNI-BOLD",
  "right_PRC_MNI-BOLD", 
  "vmPFC_right_resampled",
  "vmPFC_left_resampled",
  "PMC_3mm_resampled_bin")

# Conditions of interest
conditions <- c(
  "same_show_episode",
  "same_show_diff_episode",
  "diff_show")


# Function to load condition data for each ROI
load_condition_data <- function(condition, roi, subject_ids, base_path) {
  
  all_corrs <- list()
  
  for (sub in subject_ids) {
    
    # Path
    file_path <- file.path(
      base_path,
      paste0(
        "Model3_", sub, "_", roi,
        "_DIFF_", condition,
        "_corrs_RAW.csv"))
    
    # Create df
    df <- read_csv(
      file_path,
      show_col_types = FALSE) %>%
      mutate(
        Subject = sub,
        Condition = condition,
        ROI = roi)
    
    all_corrs[[sub]] <- df
  }
  
  # Combine all subjects for the given condition and ROI
  bind_rows(all_corrs)
}


# Create empty list to store the data for each ROI
all_data_raw <- list()


# Loop over ROIs and load data for each
for (roi in rois) {
  
  roi_data <- map_dfr(
    conditions,
    ~load_condition_data(
      .x,
      roi,
      subject_ids,
      base_path ))
  
  # Append the data for the current ROI to the list
  all_data_raw[[roi]] <- roi_data
}

# Combine all data across ROIs into one data frame
corrs_data_raw <- bind_rows(all_data_raw)

# Check
print(head(corrs_data_raw))

# Add columns for hemisphere and ROI
corrs_data_raw <- corrs_data_raw %>%
  mutate(
    
    # Clean ROI names
    ROI = str_remove_all(ROI, "(_mask_resampled|_resampled|_MNI-BOLD|_3mm_resampled_bin)"),
    
    # Extract hemisphere 
    Hemisphere = str_extract(ROI,"left|right"),
    
    # Remove hemisphere
    Region = str_remove_all(ROI, "left_|right_|_left|_right|right-|left-"))

# Check
print(head(corrs_data_raw))

# Create pair_id
corrs_data_raw <- corrs_data_raw %>%
  mutate(
    pair_id_new = paste(
      Commercial1,
      Commercial2,
      sep = "_" ))


# Delete sub- from subject id
corrs_data_raw <- corrs_data_raw %>%
  mutate(Subject = str_remove(Subject, "sub-" ))

# Check
head(corrs_data_raw)

# Split into 3 dfs based on condition
same_show_episode_corrs_raw <- corrs_data_raw %>%
  filter(Condition == "same_show_episode")

same_show_diff_episode_corrs_raw <- corrs_data_raw %>%
  filter(Condition == "same_show_diff_episode")

diff_show_corrs_raw <- corrs_data_raw %>%
  filter(Condition == "diff_show")

# Compute subject means
CORRS_subject_condition_roi_means_raw <- corrs_data_raw %>%
  group_by(Subject, Condition, Region ) %>%
  summarise(
    mean_correlation = mean(
      Correlation,
      na.rm = TRUE),
    .groups = "drop")

# Check
head(CORRS_subject_condition_roi_means_raw)

######################
### ACCURACY DATA ###
#####################

# Path 
base_path <- "/Volumes/BrusselsGriffon/CommCon/yorkie/data"

# Read files
same_show_diff_episode_accuracies <- read_csv(
  file.path(
    base_path,
    "same_show_diff_episode_master_df_accuracies.csv"),
  show_col_types = FALSE)


diff_show_accuracies <- read_csv(
  file.path(
    base_path,
    "diff_show_master_df_accuracies.csv"),
  show_col_types = FALSE)

same_show_same_episode_accuracies <- read_csv(
  file.path(
    base_path,
    "same_show_same_episode_master_df_accuracies.csv"),
  show_col_types = FALSE)

# Check
head(same_show_diff_episode_accuracies)
head(diff_show_accuracies)
head(same_show_same_episode_accuracies)

# Combine all 3 into 1 df
accuracy_data <- bind_rows(
  same_show_diff_episode_accuracies,
  diff_show_accuracies,
  same_show_same_episode_accuracies)

# Check
head(accuracy_data)

# Calculate hit rate as proportion correct
hit_rate_data <- accuracy_data %>%
  group_by(
    subject_id,
    category) %>%
  summarise(
    hits = sum(
      SourceMemCond == "yes",
      na.rm = TRUE),
    total_trials = n(),
    hit_rate = hits / total_trials,
    .groups = "drop" )

# # Hit rate where yes and mixed count as hits
# hit_rate_data_yes_mixed <- accuracy_data %>%
#   group_by(
#     subject_id,
#     category
#   ) %>%
#   summarise(
#     hits = sum(
#       SourceMemCond %in% c("yes", "mixed"),
#       na.rm = TRUE
#     ),
#     total_trials = n(),
#     hit_rate_yes_mixed = hits / total_trials,
#     .groups = "drop"
#   )

# Rename to have both df match on condition names
hit_rate_data <- hit_rate_data %>%
  mutate(
    category = case_when(
      category == "Different TVShow" ~ "diff_show",
      category == "Same TVShow & Same Episode" ~ "same_show_episode",
      category == "Same TVShow, Different Episode" ~ "same_show_diff_episode",
      TRUE ~ category))


###########################################
### COMBINE CORRELATION + ACCURCY DATA ###
##########################################

# Create DF
analysis1 <- CORRS_subject_condition_roi_means

analysis1_CORRS_with_hit <- CORRS_subject_condition_roi_means %>%
  left_join(
    hit_rate_data %>%
      select(
        subject_id,
        category,
        hit_rate),
    by = c(
      "Subject" = "subject_id",
      "Condition" = "category" ))

# Data for plotting
plots1 <- CORRS_subject_condition_roi_means_raw

plots1_CORRS_with_hit_raw <- CORRS_subject_condition_roi_means_raw %>%
  left_join(
    hit_rate_data %>%
      select(
        subject_id,
        category,
        hit_rate),
    by = c(
      "Subject" = "subject_id",
      "Condition" = "category" ))


#####################
### LME ANALYSIS ###
####################

analysis1_CORRS_with_hit <- analysis1_CORRS_with_hit %>%
  mutate(
    Subject = factor(Subject),

    # Set reference condition
    Condition = factor(
      Condition,
      levels = c(
        "same_show_episode",
        "same_show_diff_episode",
        "diff_show" ) ))

# Check
head(analysis1_CORRS_with_hit)

# Set reference levels
analysis1_CORRS_with_hit$Subject <- 
  factor(analysis1_CORRS_with_hit$Subject)

analysis1_CORRS_with_hit$Condition <- 
  factor(
    analysis1_CORRS_with_hit$Condition,
    levels = c(
      "same_show_episode",
      "same_show_diff_episode",
      "diff_show"))

###################
### HIPPOCAMPUS ###
###################

hippocampus_data <- analysis1_CORRS_with_hit %>%
  filter(Region == "Hippocampus")

hippocampus_model <- lmer(mean_correlation ~ hit_rate * Condition + (1 | Subject),
  data = hippocampus_data)

summary(hippocampus_model)

anova(hippocampus_model)

# Test sig interaction 
hippocampus_slopes <- emtrends(
  hippocampus_model,
  ~ Condition,
  var = "hit_rate")

hippocampus_slopes

hippocampus_slope_comparisons <- pairs(
  hippocampus_slopes,
  adjust = "holm")

hippocampus_slope_comparisons

#######################################################################
# Filter hippocampus data by condition
#######################################################################

  ## Different context
  hippo_different <- plots1_CORRS_with_hit_raw %>%
    filter(Region == "Hippocampus", Condition == "diff_show")

## Similar context
  hippo_similar <- plots1_CORRS_with_hit_raw %>%
    filter(Region == "Hippocampus", Condition == "same_show_diff_episode")

## Same context
  hippo_same <- plots1_CORRS_with_hit_raw %>%
    filter(Region == "Hippocampus", Condition == "same_show_episode")


#######################################################################
# define colors
#######################################################################

# define category_colors
  category_colors <- c(
      "same_show_episode" = "cornflowerblue",
      "same_show_diff_episode" = "hotpink",
      "diff_show" = "limegreen"
      )

# define dark versions of category_colors
  dark_cornflower <- adjustcolor("cornflowerblue", offset = c(-0.3, -0.3, -0.3, 0))
  dark_hotpink <- adjustcolor("hotpink", offset = c(-0.3, -0.3, -0.3, 0))
  dark_limegreen <- adjustcolor("limegreen", offset = c(-0.3, -0.3, -0.3, 0))

# define category_colors_dark
 category_colors_dark <- c(
      "same_show_episode" = dark_cornflower,
      "same_show_diff_episode" = dark_hotpink,
      "diff_show" = dark_limegreen
      )


#######################################################################
# hippocampus - different context
#######################################################################

hippo_different <- plots1_CORRS_with_hit_raw %>%
  filter(Region == "Hippocampus", Condition == "diff_show"),


h1 <- ggplot(
  hippo_different,
  aes(
    x = hit_rate,
    y = mean_correlation,
    color = Condition)) +
  geom_point(
    size = 2.5,
    alpha = 0.5,
    shape = 16
    ) +
  geom_smooth(
    aes(fill = Condition),
    method = "lm",
    se = TRUE, # 95% confidence interval bands
    linewidth = 1,
    alpha = 0.2) +
  scale_color_manual(
    values = category_colors_dark,
    labels = c(
      "same_show_episode" = "Same show, same episode",
      "same_show_diff_episode" = "Same show, different episode",
      "diff_show" = "Different shows")) +
  scale_fill_manual(
    values = category_colors,
    guide = "none") +
  theme_classic(base_size = 10) +
  theme(
    axis.title.x = element_text(size = 10),
    axis.title.y = element_text(size = 10),
    axis.text.x = element_text(
      size = 8.5,
      color = "black"),
    axis.text.y = element_text(
      size = 8.5,
      color = "black"),
    axis.line = element_line(color = "black"),
    axis.line.x = element_line(color = "black"),
    axis.line.y = element_line(color = "black"),
    legend.position = "none",
    plot.title = element_text(
      hjust = 0.5,
      face = "bold",
      size = 11,
      margin = margin(b = 10)),
    plot.margin = margin(
      t = 15,
      r = 5.5,
      b = 5.5,
      l = 5.5)) +
  labs(
    title = "Different context",
    x = "Source memory accuracy",
    y = "Mean pattern similarity") +
    coord_cartesian(ylim = c(.055, 0.11))

#######################################################################
# hippocampus - similar context
#######################################################################

hippo_similar <- plots1_CORRS_with_hit_raw %>%
  filter(Region == "Hippocampus", Condition == "same_show_diff_episode")

h2 <- ggplot(
  hippo_similar,
  aes(
    x = hit_rate,
    y = mean_correlation,
    color = Condition)) +
  geom_point(
    size = 2.5,
    alpha = 0.5,
    shape = 16
    ) +
  geom_smooth(
    aes(fill = Condition),
    method = "lm",
    se = TRUE, # 95% confidence interval bands
    linewidth = 1,
    alpha = 0.2) +
  scale_color_manual(
    values = category_colors_dark,
    labels = c(
      "same_show_episode" = "Same show, same episode",
      "same_show_diff_episode" = "Same show, different episode",
      "diff_show" = "Different shows")) +
  scale_fill_manual(
    values = category_colors,
    guide = "none") +
  theme_classic(base_size = 10) +
  theme(
    axis.title.x = element_text(size = 10),
    axis.title.y = element_blank(),
    axis.text.x = element_text(
      size = 8.5,
      color = "black"),
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank(),
    axis.line = element_line(color = "black"),
    axis.line.x = element_line(color = "black"),
    axis.line.y = element_line(color = "black"),
    legend.position = "none",
    plot.title = element_text(
      hjust = 0.5,
      face = "bold",
      size = 11,
      margin = margin(b = 10)),
    plot.margin = margin(
      t = 15,
      r = 5.5,
      b = 5.5,
      l = 5.5)) +
  labs(
    title = "Similar context",
    x = "Source memory accuracy",
    y = "Mean pattern similarity") +
    coord_cartesian(ylim = c(.055, 0.11))


#######################################################################
# hippocampus - same context
#######################################################################

hippo_similar <- plots1_CORRS_with_hit_raw %>%
  filter(Region == "Hippocampus", Condition == "same_show_episode")

h3 <- ggplot(
  hippo_similar,
  aes(
    x = hit_rate,
    y = mean_correlation,
    color = Condition)) +
  geom_point(
    size = 2.5,
    alpha = 0.5,
    shape = 16
    ) +
  geom_smooth(
    aes(fill = Condition),
    method = "lm",
    se = TRUE, # 95% confidence interval bands
    linewidth = 1,
    alpha = 0.2) +
  scale_color_manual(
    values = category_colors_dark,
    labels = c(
      "same_show_episode" = "Same show, same episode",
      "same_show_diff_episode" = "Same show, different episode",
      "diff_show" = "Different shows")) +
  scale_fill_manual(
    values = category_colors,
    guide = "none") +
  theme_classic(base_size = 10) +
  theme(
    axis.title.x = element_text(size = 10),
    axis.title.y = element_blank(),
    axis.text.x = element_text(
      size = 8.5,
      color = "black"),
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank(),
    axis.line = element_line(color = "black"),
    axis.line.x = element_line(color = "black"),
    axis.line.y = element_line(color = "black"),
    legend.position = "none",
    plot.title = element_text(
      hjust = 0.5,
      face = "bold",
      size = 11,
      margin = margin(b = 10)),
    plot.margin = margin(
      t = 15,
      r = 5.5,
      b = 5.5,
      l = 5.5)) +
  labs(
    title = "Same context",
    x = "Source memory accuracy",
    y = "Mean pattern similarity") +
    coord_cartesian(ylim = c(.055, 0.11))

#######################################################################
# combine hippocampus plots with cowplot
#######################################################################

hplot <- plot_grid(
                h1, h2, h3, ncol = 3, labels = "AUTO"
              )

hplot


# ggsave(
#   filename = "/Volumes/BrusselsGriffon/CommCon/manuscript-figures/hipp_source_mem_patt_sim.svg",
#   plot = hplot,
#   width = 6.5,
#   height = 3,
#   units = "in")





##########
### A1 ###
#########

A1_data <- analysis1_CORRS_with_hit %>%
  filter(Region == "A1")

A1_model <- lmer(mean_correlation ~ hit_rate * Condition + (1 | Subject),
  data = A1_data)

summary(A1_model)

anova(A1_model)

############
### PHC ###
###########

PHC_data <- analysis1_CORRS_with_hit %>%
  filter(Region == "PHC")

PHC_model <- lmer(mean_correlation ~ hit_rate * Condition + (1 | Subject),
  data = PHC_data)

summary(PHC_model)

anova(PHC_model)

# test sign main effect
PHC_emmeans <- emmeans(
  PHC_model,
  ~ Condition)

PHC_emmeans

pairs(
  PHC_emmeans,
  adjust = "holm")

###########
### PRC ###
###########

PRC_data <- analysis1_CORRS_with_hit %>%
  filter(Region == "PRC")

PRC_model <- lmer(mean_correlation ~ hit_rate * Condition + (1 | Subject),
  data = PRC_data)

summary(PRC_model)

anova(PRC_model)

##############
### vmPFC ###
#############

vmPFC_data <- analysis1_CORRS_with_hit %>%
  filter(Region == "vmPFC")

vmPFC_model <- lmer(mean_correlation ~ hit_rate * Condition + (1 | Subject),
  data = vmPFC_data)

summary(vmPFC_model)

anova(vmPFC_model)

###########
### PMC ###
###########

PMC_data <- analysis1_CORRS_with_hit %>%
  filter(Region == "PMC")

PMC_model <- lmer(mean_correlation ~ hit_rate * Condition + (1 | Subject),
  data = PMC_data)

summary(PMC_model)

anova(PMC_model)