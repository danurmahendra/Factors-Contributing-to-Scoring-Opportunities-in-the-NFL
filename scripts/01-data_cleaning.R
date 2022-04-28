#### Preamble ####
# Purpose: Clean the survey data downloaded from [...UPDATE ME!!!!!]
# Author: Rohan Alexander [CHANGE THIS TO YOUR NAME!!!!]
# Data: 3 January 2021
# Contact: rohan.alexander@utoronto.ca [PROBABLY CHANGE THIS ALSO!!!!]
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the ACS data and saved it to inputs/data
# - Don't forget to gitignore it!
# - Change these to yours
# Any other information needed?


#### Workspace setup ####
library(tidyverse)
library(dplyr)

pbp_data2021 <- read_csv("pbp-2021.csv", col_names = TRUE)
head(pbp_data2021)
pbp_data2021 <- pbp_data2021 %>%
  mutate(bigplay = if_else(IsRush == 1 & Yards > 12, 1, 0)) %>%
  mutate(bigplay1 = if_else(IsPass == 1 & Yards > 16, 1, 0)) %>%
  mutate(IsBigPlay = bigplay + bigplay1)

pbp_data2021 <- pbp_data2021 %>%
  mutate(IsTurnover = IsSack + IsInterception)

pbp_data2021 <- pbp_data2021[-c(11,13,17,18)]

cleaned_pbp <- pbp_data2021 %>%
  select(c(Quarter, Minute, Second, Down, ToGo, YardLine, Yards, IsIncomplete, Formation, SeriesFirstDown, IsRush, IsPass, IsTurnover, PlayType, PassType, RushDirection, IsTouchdown, IsPenalty, IsBigPlay))

cleaned_pbp <- cleaned_pbp %>%
  filter(IsPenalty == 0) %>%
  filter(PlayType == "PASS" | PlayType == "RUSH" | PlayType == "FIELD GOAL" | PlayType == "PUNT") %>%
  filter(Quarter < 5)


cleaned_pbp <- cleaned_pbp %>%
  mutate_all(funs(ifelse(is.na(.), 0, .)))
cleaned_pbp <- cleaned_pbp %>%
  filter(!grepl("NOT LISTED", PassType)) %>% 
  filter(!grepl("INTENDED FOR", PassType)) %>% 
  filter(!grepl("MIDDLE TO", PassType)) %>%
  filter(!grepl("RIGHT TO", PassType))
 
         
