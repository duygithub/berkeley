remotes::install_github("baumer-lab/fec16")
library(fec16)
library(lmtest)
library(sandwich)
library(tidyverse)

options(scipen = 999)


data(package = "fec16")

?results_house
glimpse(results_house)
head(results_house)

ggplot(data = results_house,
       aes(x = general_percent)) +
      geom_histogram(bins=20) +
  labs(title="House of Representative Oves",
       x = "General Vote Percent",
       y = "Count") +
  coord_cartesian(xlim = c(0, 1))

?campaigns
glimpse(campaigns)
head(campaigns)

ggplot(data = campaigns,
       aes(x = ttl_disb)) +
  geom_histogram(binwidth = 25000) +
  labs(title="Campaign Spending",
       x = "Total Disbursements",
       y = "Count") +
  coord_cartesian(xlim = c(0, 4000000))

joined_results_house_campaigns_df <- inner_join(results_house, campaigns, by = "cand_id")
number_of_rows <- nrow(joined_results_house_campaigns_df)
number_of_cols <- ncol(joined_results_house_campaigns_df)

head(joined_results_house_campaigns_df)

joined_results_candidate_party_df <- joined_results_house_campaigns_df %>%
  mutate(candidate_party = case_when(
    party == "DEM" ~ "Democrat",
    party == "REP" ~ "Republican",
    TRUE ~ "Other Party"
  ))

joined_results_candidate_party_df %>%
  select(candidate_party, ttl_disb, general_votes) %>%
  head()

min_tbl_disb <- min(joined_results_candidate_party_df$ttl_disb, na.rm=TRUE)
max_tbl_disb <- max(joined_results_candidate_party_df$ttl_disb, na.rm=TRUE)
min_general_votes <- min(joined_results_candidate_party_df$general_votes, na.rm=TRUE)
max_general_votes <- max(joined_results_candidate_party_df$general_votes, na.rm=TRUE)

party_colors <- c(
  "Democrat" = "blue",
  "Republican" = "red",
  "Other Party" = "green"
)


ggplot(data=joined_results_candidate_party_df,
       aes(x = ttl_disb, y=general_votes, color = candidate_party)) +
  geom_point(alpha = 0.5) +
  labs(title="Campaign Spending",
       x = "Total Disbursements",
       y = "General Vote Count",
       color = "Party") +
  scale_color_manual(values = party_colors) +
  coord_cartesian(xlim = c(0, 13500000), ylim = c(50, 750000))

ggplot(data=joined_results_candidate_party_df,
       aes(x = ttl_disb, y=general_votes, color = candidate_party)) +
  geom_point(alpha = 0.5) +
  labs(title="Campaign Spending",
       x = "Total Disbursements",
       y = "General Vote Count",
       color = "Party") +
  scale_color_manual(values = party_colors) +
  coord_cartesian(xlim = c(0, 500000), ylim = c(50, 300000))

model <- lm(general_votes ~ ttl_disb + candidate_party, data=joined_results_candidate_party_df)
coeftest(model, vcov = vcovHC(model, type = "HC1"))
