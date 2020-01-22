library(tidyverse)
library(forcats)
library(knitr)
library(maptools)
library(viridis)
library(RColorBrewer)
library(mapproj)
library(broom)
library(ggrepel)
library(sf)


data <- read_csv("data/children-born-per-woman.csv")

data <- data %>% select(-Code) 
data <- data %>% 
  rename(country = "Entity", year = "Year", fertility = "(children per woman)")
data_dacades <- data %>% 
  filter(year %in% c(1960:2015))

africa <-
  sf::st_read(
    file.path("data/Africa.shp"), 
    stringsAsFactors = FALSE, quiet = TRUE
  ) %>%
  rename(country = "COUNTRY") %>%
  left_join(data_dacades, by = "country")


#Plot
africa %>% 
  ggplot(aes(fill = fertility)) + 
  geom_sf() +
  coord_sf() +
  scale_fill_viridis(option = "plasma") +
  theme_minimal() +
  # transition_states(africa$year,
  #                   transition_length = 7, state_length = 7, wrap = TRUE) +
  labs(title = " How fertility rate varies by country over the past 5 decades? {closest_state}")

gganimate::animate(mymap)
# anim_save(filename = "Africa_life_Expectancy_animation.gif")