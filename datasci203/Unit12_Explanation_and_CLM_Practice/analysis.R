mammals_data <- read_csv("data/mammals.csv", na="NA")
prepped_data <- mammals_data %>%
  select(species, non_dreaming, dreaming) %>%
  drop_na(dreaming, non_dreaming)
non_zero_data <- mammals_data %>%
  select(species, brain_wt, non_dreaming, dreaming) %>%
  drop_na(dreaming, non_dreaming) %>%
  filter(dreaming > 0, non_dreaming > 0)

number_of_entries <- nrow(mammals_data)

    
data_long <- prepped_data %>%
  select(species, non_dreaming, dreaming) %>%
  pivot_longer(
    cols = c(non_dreaming, dreaming),
    names_to = "sleep_type",
    values_to = "hours"
  ) %>%
  drop_na(hours)


means <- data_long %>%
  group_by(sleep_type) %>%
  summarise(mean_hours = mean(hours, na.rm = TRUE))

dreaming_non_dreaming_correlation <- cor(prepped_data$dreaming, prepped_data$non_dreaming)

lm_model <- lm(brain_wt ~ dreaming + non_dreaming, data=non_zero_data)
lm_model_summary <- summary(lm_model)
inverse_lm_model <- lm(brain_wt ~ dreaming + I(1 / dreaming) + non_dreaming + I(1 / non_dreaming), data=non_zero_data)
inverse_lm_model_summary <- summary(inverse_lm_model)
