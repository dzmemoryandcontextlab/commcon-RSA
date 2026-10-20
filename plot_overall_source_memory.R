library(ggplot2)
library(dplyr)
library(ggdist)
library(cowplot)
library(scales)
library(stringr)
library(ggnewscale)

#######################################################################
# Master Setup: Expected Items, Theme & Color Scales
#######################################################################

# Define the exact 24 commercial names (this is because an inconsistency in commercial names
# was causing only 23 commercials to appear originally)

expected_commercials <- c(
  "adopt-a-pet", "arctic-leash", "area-wide-exterminators", "arrowhead-clinic",
  "bang-bang-boom-boom", "big-al-pizza", "bowling", "cecil-myers",
  "china-star-delicious", "cie-perfume", "crazy-gideon", "go-wireless",
  "heindl-used-cars", "henry-beer-commercial", "horrible-insurance", "jp-audio-mart",
  "lens-rap", "local-commercial-fail", "martin-fine-furniture", "pay-me-now",
  "rug-it-riders", "sushi-bar", "take-my-wife", "village-inn-family-buffet"
)

# Shared publication theme
theme_paper <- function(base_size = 10) {
  theme_classic(base_size = base_size) +
    theme(
      axis.title.x = element_blank(),
      axis.title.y = element_text(size = 10, color = "black", margin = margin(r = 6)),
      axis.text.x  = element_text(size = 9, color = "black", margin = margin(t = 2)),
      axis.text.y  = element_text(size = 8.5, color = "black"),
      axis.line    = element_line(color = "black"),
      legend.position = "none",
      plot.title   = element_text(hjust = 0.5, face = "bold", size = 11, margin = margin(b = 10))
    )
}

# Define condition palette
acc_colors <- c(
  "same_show_episode"      = "cornflowerblue",
  "same_show_diff_episode" = "hotpink",
  "diff_show"              = "limegreen"
)

acc_colors_dark <- c(
  "same_show_episode"      = adjustcolor("cornflowerblue", offset = c(-0.3, -0.3, -0.3, 0)),
  "same_show_diff_episode" = adjustcolor("hotpink", offset = c(-0.3, -0.3, -0.3, 0)),
  "diff_show"              = adjustcolor("limegreen", offset = c(-0.3, -0.3, -0.3, 0))
)

condition_labels <- c(
  "same_show_episode"      = "Same context",
  "same_show_diff_episode" = "Similar context",
  "diff_show"              = "Different context"
)

chance_level <- 1/6

#######################################################################
# Plot 1: Overall Source Memory Accuracy
#######################################################################

overall_acc_df <- accuracy_data %>%
  group_by(subject_id) %>%
  summarise(
    hits = sum(SourceMemCond == "yes", na.rm = TRUE),
    total_trials = n(),
    hit_rate = hits / total_trials,
    category = "Overall",
    .groups = "drop"
  )

p_overall <- ggplot(overall_acc_df, aes(x = category, y = hit_rate)) +
  geom_hline(yintercept = chance_level, linetype = "dashed", color = "gray30", linewidth = 0.8) +
  stat_halfeye(
    fill = "gray40", adjust = waiver(), width = 0.5, .width = 0,
    shape = NA, position = position_nudge(x = 0.18)
  ) +
  geom_jitter(
    color = "gray40", width = 0.06, size = 2.2, shape = 16, alpha = 0.55
  ) +
  stat_summary(
    fun.data = mean_cl_normal, fun.args = list(conf.int = 0.95),
    geom = "errorbar", color = "black", linewidth = 1.1, width = 0.12,
    position = position_nudge(x = 0.18)
  ) +
  stat_summary(
    fun.data = mean_cl_normal, geom = "point",
    color = "black", shape = 18, size = 3.5, position = position_nudge(x = 0.18)
  ) +
  scale_y_continuous(
    labels = label_number(accuracy = 0.1),
    limits = c(0, 1.0),
    breaks = seq(0, 1, 0.2),
    expand = expansion(mult = c(0.02, 0.05))
  ) +
  theme_paper() +
  labs(title = "", y = "Source memory accuracy")

print(p_overall)

#######################################################################
# Plot 2: Source Memory Accuracy Split by Condition
#######################################################################

pair_type_df <- hit_rate_data %>%
  filter(category != "Overall") %>%
  mutate(
    category = factor(
      category,
      levels = c("same_show_episode", "same_show_diff_episode", "diff_show")
    )
  )

p_pair_type <- ggplot(pair_type_df, aes(x = category, y = hit_rate, fill = category)) +
  geom_hline(yintercept = chance_level, linetype = "dashed", color = "gray30", linewidth = 0.8) +
  stat_halfeye(
    adjust = waiver(), width = 0.5, .width = 0,
    shape = NA, position = position_nudge(x = 0.18)
  ) +
  geom_jitter(
    aes(color = category), width = 0.06, size = 2.2, shape = 16, alpha = 0.55
  ) +
  scale_color_manual(values = acc_colors) +
  scale_fill_manual(values = acc_colors) +
  ggnewscale::new_scale_color() +
  stat_summary(
    aes(color = category),
    fun.data = mean_cl_normal, fun.args = list(conf.int = 0.95),
    geom = "errorbar", linewidth = 1.1, width = 0.12,
    position = position_nudge(x = 0.18)
  ) +
  stat_summary(
    aes(color = category),
    fun.data = mean_cl_normal, geom = "point",
    shape = 18, size = 3.5, position = position_nudge(x = 0.18)
  ) +
  scale_color_manual(values = acc_colors_dark) +
  scale_x_discrete(labels = condition_labels) +
  scale_y_continuous(
    labels = label_number(accuracy = 0.1),
    limits = c(0, 1.0),
    breaks = seq(0, 1, 0.2),
    expand = expansion(mult = c(0.02, 0.05))
  ) +
  theme_paper() +
  labs(title = "", y = "Source memory accuracy")

print(p_pair_type)

#######################################################################
# Plot 3: Item-level Accuracy Across All 24 Commercials
#######################################################################

comm_acc_df <- accuracy_data %>%
  mutate(
    # Clean string labels: remove segment suffixes and trim trailing spaces
    CommercialCopy = str_remove_all(as.character(CommercialCopy), "_seg-\\d+"),
    CommercialCopy = str_trim(CommercialCopy),
    # Lock to all 24 expected commercial factor levels
    CommercialCopy = factor(CommercialCopy, levels = expected_commercials)
  ) %>%
  group_by(CommercialCopy, .drop = FALSE) %>% 
  summarise(
    mean_hit_rate = mean(SourceMemCond == "yes", na.rm = TRUE),
    n = n(),
    se = ifelse(n > 1, sd(SourceMemCond == "yes", na.rm = TRUE) / sqrt(n), 0),
    ci_lower = mean_hit_rate - 1.96 * se,
    ci_upper = mean_hit_rate + 1.96 * se,
    .groups = "drop"
  ) %>%
  mutate(CommercialCopy = reorder(CommercialCopy, mean_hit_rate))

p_commercial <- ggplot(comm_acc_df, aes(x = CommercialCopy, y = mean_hit_rate)) +
  geom_hline(
    yintercept = chance_level, 
    linetype = "dashed", 
    color = "gray30", 
    linewidth = 0.8
  ) +
  annotate(
    "text",
    x = 1, 
    y = chance_level + 0.03, 
    label = "Chance (16.7%)",
    color = "gray30",
    size = 3,
    fontface = "italic",
    hjust = 0
  ) +
  geom_errorbar(
    aes(ymin = pmax(0, ci_lower), ymax = pmin(1, ci_upper)),
    width = 0.2, color = "firebrick", linewidth = 0.7
  ) +
  geom_point(size = 3, color = "firebrick") +
  scale_y_continuous(
    labels = label_number(accuracy = 0.1),
    limits = c(0, 1.0),
    breaks = seq(0, 1, 0.2),
    expand = expansion(mult = c(0.02, 0.05))
  ) +
  theme_paper() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1, size = 8, color = "black"),
    axis.title.x = element_text(size = 10, color = "black", margin = margin(t = 6))
  ) +
  labs(
    title = "",
    x = "Commercial",
    y = "Source memory accuracy"
  )

print(p_commercial)


#######################################################################
# Save Accuracy Figures
#######################################################################

ggsave(
  filename = "/Volumes/BrusselsGriffon/CommCon/manuscript-figures/source_mem_overall.pdf",
  plot = p_overall,
  width = 2,
  height = 3,
  units = "in"
)

ggsave(
  filename = "/Volumes/BrusselsGriffon/CommCon/manuscript-figures/source_mem_condition.pdf",
  plot = p_pair_type,
  width = 6.5,
  height = 3,
  units = "in"
)

ggsave(
  filename = "/Volumes/BrusselsGriffon/CommCon/manuscript-figures/source_mem_commercial.pdf",
  plot = p_commercial,
  width = 6.5,
  height = 6,
  units = "in"
)
