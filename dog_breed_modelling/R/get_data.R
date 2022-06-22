#load data wrangling packages
library(data.table)
library(tidyverse)
library(lubridate)
library(tidytuesdayR)

#load path setting package
library(here)

#load tidymodels package
library(tidymodels)

# Get the Data

# Read in with tidytuesdayR package
# Install from CRAN via: install.packages("tidytuesdayR")
# This loads the readme and all the datasets for the week of interest

# Either ISO-8601 date or year/week works!

#tuesdata <- tidytuesdayR::tt_load('2022-02-01')
tuesdata <- tidytuesdayR::tt_load(2022, week = 5)

#Read in the data manually
#breed_traits <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-02-01/breed_traits.csv')
#trait_description <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-02-01/trait_description.csv')
#breed_rank_all <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-02-01/breed_rank.csv')

# Use tidytuesday function
breed_traits <- tuesdata$breed_traits
trait_description <- tuesdata$trait_description
breed_rank <- tuesdata$breed_rank
rm(tuesdata)

