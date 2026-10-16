library(ggplot2)
library(dplyr)
library(ggdist)
library(cowplot)

#######################################################################
# Prepare Source Memory Accuracy Data
#######################################################################

# 1. Overall accuracy per subject (across all categories)
overall_acc <- accuracy_data %>%
  group_by(subject_id) %>%
  summarise(
    hits = sum(SourceMemCond == "yes", na.rm = TRUE),
    total_trials = n(),
    hit_rate = hits / total_trials,
    category = "Overall",
    .groups = "drop"
  )

# 2. Condition-wise accuracy per subject (using hit_rate_data)
# Ensure categories match plot ordering
hit_rate_data_formatted <- hit_rate_data %>%
  mutate(
    category = factor(
      category,
      levels = c("Overall", "same_show_episode", "same_show_diff_episode", "diff_show")
    )
  )

# Combine overall and condition-specific subject data
all_accuracy_subject_means <- bind_rows(
  overall_acc %>% mutate(category = factor("Overall", levels = c("Overall", "same_show_episode", "same_show_diff_episode", "diff_show"))),
  hit_rate_data_formatted
)

#######################################################################
# Define Colors & Custom Labels
#######################################################################

acc_colors <- c(
  "Overall" = "gray40",
  "same_show_episode" = "cornflowerblue",
  "same_show_diff_episode" = "hotpink",
  "diff_show" = "limegreen"
)

acc_colors_dark <- c(
  "Overall" = "black",
  "same_show_episode" = adjustcolor("cornflowerblue", offset = c(-0.3, -0.3, -0.3, 0)),
  "same_show_diff_episode" = adjustcolor("hotpink", offset = c(-0.3, -0.3, -0.3, 0)),
  "diff_show" = adjustcolor("limegreen", offset = c(-0.3, -0.3, -0.3, 0))
)

condition_labels <- c(
  "Overall" = "Overall",
  "same_show_episode" = "Same\ncontext",
  "same_show_diff_episode" = "Similar\ncontext",
  "diff_show" = "Different\ncontext"
)

#######################################################################
# Generate Source Memory Accuracy Plot
#######################################################################

# Define chance level (1/6 = 0.167 for 6-choice source memory)
chance_level <- 1/6

p_source_mem <- ggplot(
  all_accuracy_subject_means, 
  aes(x = category, y = hit_rate, fill = category)
) +

  # 1. Add dashed chance baseline across all categories
  geom_hline(
    yintercept = chance_level, 
    linetype = "dashed", 
    color = "gray30", 
    linewidth = 0.8
  ) +
  


  # 2. Half-eye distribution densities
  stat_halfeye(
    adjust = waiver(),
    width = 0.5,
    .width = 0,
    shape = NA,
    position = position_nudge(x = 0.18)
  ) +

  # 3. Individual subject data points
  geom_jitter(
    aes(color = category),
    width = 0.06,
    size = 2.2,
    shape = 16,
    alpha = 0.55
  ) +

  scale_color_manual(values = acc_colors) +
  scale_fill_manual(values = acc_colors) +
  new_scale_color() +

  # 4. 95% Confidence Intervals
  stat_summary(
    aes(color = category),
    fun.data = mean_cl_normal,
    fun.args = list(conf.int = 0.95),
    geom = "errorbar",
    linewidth = 1.1,
    width = 0.12,
    position = position_nudge(x = 0.18)
  ) +

  # 5. Group Mean Point
  stat_summary(
    aes(color = category),
    fun.data = mean_cl_normal,
    geom = "point",
    shape = 18,
    size = 3.5,
    position = position_nudge(x = 0.18)
  ) +

  scale_color_manual(values = acc_colors_dark) +

  # Axis formatting
  scale_x_discrete(labels = condition_labels) +
  scale_y_continuous(
    labels = label_number(accuracy = 0.1),
    limits = c(0, 1.0),
    breaks = seq(0, 1, 0.2),
    expand = expansion(mult = c(0.02, 0.05))
  ) +

  theme_classic(base_size = 10) +
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_text(size = 10, color = "black", margin = margin(r = 6)),
    axis.text.x = element_text(size = 9, color = "black", margin = margin(t = 2)),
    axis.text.y = element_text(size = 8.5, color = "black"),
    axis.line = element_line(color = "black"),
    legend.position = "none",
    plot.title = element_text(hjust = 0.5, face = "bold", size = 11, margin = margin(b = 10))
  ) +

  labs(
    title = "Overall source memory accuracy",
    y = "Source memory accuracy"
  )

print(p_source_mem)

#######################################################################
# Save Accuracy Figures
#######################################################################

ggsave(
  filename = "/Volumes/BrusselsGriffon/CommCon/manuscript-figures/overall_source_memory_accuracy.svg",
  plot = p_source_mem,
  width = 6.5,
  height = 3,
  units = "in"
)

ggsave(
  filename = "/Volumes/BrusselsGriffon/CommCon/manuscript-figures/overall_source_memory_accuracy.pdf",
  plot = p_source_mem,
  width = 6.5,
  height = 3,
  units = "in"
)

##########################
# Check stats 
##########################
# accuracy_summary <- hit_rate_data %>%
#   group_by(category) %>%
#   summarise(
#     N = n(),
#     mean_hit_rate = mean(hit_rate, na.rm = TRUE),
#     sd_hit_rate = sd(hit_rate, na.rm = TRUE),
#     min_hit_rate = min(hit_rate, na.rm = TRUE),
#     max_hit_rate = max(hit_rate, na.rm = TRUE),
#     .groups = "drop"
#   )

# print(accuracy_summary)

# overall_stats <- hit_rate_data %>%
#   summarise(
#     category = "Overall",
#     N = n(),
#     mean_hit_rate = mean(hit_rate, na.rm = TRUE),
#     sd_hit_rate = sd(hit_rate, na.rm = TRUE),
#     min_hit_rate = min(hit_rate, na.rm = TRUE),
#     max_hit_rate = max(hit_rate, na.rm = TRUE)
#   )

# all_accuracy_summary <- bind_rows(overall_stats, accuracy_summary)

# print(all_accuracy_summary)

