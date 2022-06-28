library(tidyverse)
library(here)

source(here("R", "get_data.R"))

# Read in the sic groups data
sic_gps <- read_csv(here("uk_gender_paygap", "input_data", "sic_groups.csv"), col_types = "c")
head(sic_gps)

# Prepare the sic groups data
sic_full <- sic_gps %>%
  mutate(code_start = map2(min, max, seq)) %>%
  unnest(code_start) %>%
  select(-min, -max, -num)
View(sic_full)


# Prepare the GPG data
paygap_industry_means <- paygap %>%
  mutate(code_start = as.integer(str_extract(sic_codes, "^\\d{2}"))) %>%
  left_join(select(sic_full, description, code_start), by = "code_start") %>%
  group_by(description) %>%
  summarise(mean_gpg = mean(diff_mean_hourly_percent, na.rm = T)) %>%
  ungroup() %>%
  arrange(mean_gpg) %>%
  mutate(description = replace_na(description, "Other Industries"))

# Plot mean diff by major groups (ordered from central line plot) ----
library(png)
male_png <- readPNG(here("uk_gender_paygap", "images", "male.png"))
female_png <- readPNG(here("uk_gender_paygap", "images", "female.png"))

p1 <- paygap_industry_means %>%
  mutate(description = factor(description, levels = description)) %>%
  mutate(mycolour = ifelse(mean_gpg > 0, "male_gpg", "female_gpg")) %>%
  ggplot() +
  geom_segment( aes(x = description, xend = description, y = 0, yend = mean_gpg, color = mycolour)) +
  geom_point( aes(x = description, y = mean_gpg, color = mycolour), size = 4, alpha = 0.6) +
  #geom_segment( aes(x = description, xend = description, y = 0, yend = mean_gpg), color="light blue") +
  #geom_point(size = 4, alpha = 0.6) +
  geom_hline(yintercept = 0) +
  theme_light() +
  coord_flip() +
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.major.y = element_blank(),
    panel.border = element_blank(),
    axis.ticks.x = element_blank()
  ) +
  xlab("") +
  ylab("Average pay gap (%)") +
  theme(legend.position="none")

#If you want to add an image
# p1 + annotation_raster(male_png, ymin = 20, ymax= 21.5,
#                       xmin = 10, xmax = 11.5) +
#     annotation_raster(female_png, ymin = 20, ymax= 21,
#                    xmin = 8, xmax = 9.5)

# Employer Size vs mean diff
paygap_size <- paygap %>%
  filter(employer_size != "Not Provided") %>%
  mutate(employer_size_gps = case_when(
    employer_size == "Less than 250" ~ "small",
    employer_size == "250 to 499" ~ "small",
    employer_size == "500 to 999" ~ "medium",
    employer_size == "1000 to 4999" ~ "medium",
    employer_size == "5000 to 19,999" ~ "large",
    employer_size == "20,000 or more" ~ "large",
    TRUE ~ as.character(employer_size)
  )) %>%
  mutate(employer_size_gps  = factor(employer_size_gps, levels = c("small", "medium", "large"))) %>%
  select("employer_size_gps",
         "male_lower_quartile", "female_lower_quartile",
         "male_top_quartile", "female_top_quartile") %>%
  pivot_longer(cols = -employer_size_gps, names_to = "group", values_to = "percentage") %>%
  mutate(sex = ifelse(str_detect(group, "female"), "female", "male"),
         quartile = ifelse(str_detect(group, "lower"), "lower", "top"))

paygap_size

paygap_size %>%
ggplot(aes(x = employer_size_gps, y = percentage, fill = sex)) +
  geom_boxplot() +
  #geom_violin(position="dodge", alpha=0.5, outlier.colour="transparent") +
  facet_wrap(~quartile)


# Build a regression model of mean diff pgp by company size


# Spatial plot by UK postcode

# Compare
