# Get the Data

# Read in with tidytuesdayR package
# Install from CRAN via: install.packages("tidytuesdayR")
# This loads the readme and all the datasets for the week of interest

# Either ISO-8601 date or year/week works!

paygap_data <- tidytuesdayR::tt_load('2022-06-28')
#tuesdata <- tidytuesdayR::tt_load(2022, week = 26)

paygap <- paygap_data$paygap

# Or read in the data manually
# paygap <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-06-28/paygap.csv')


#Explore the dataset
library(skimr)
library(tidyverse)
skim(paygap)


#Mean % difference between male and female hourly pay (negative = women's mean hourly pay is higher)
hist(paygap$diff_mean_hourly_percent)
range(paygap$diff_mean_hourly_percent)
paygap[which(paygap$diff_mean_hourly_percent == -499.9), ]

paygap %>%
  #filter(diff_mean_hourly_percent > -499) %>%
  ggplot( aes(diff_mean_hourly_percent)) +
  geom_histogram()

paygap %>%
  #filter(diff_median_hourly_percent > -499) %>%
  ggplot( aes(diff_median_hourly_percent)) +
  geom_histogram()


