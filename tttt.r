# Set working directory
setwd("C:/Users/HP/Desktop/GIS WORK/GIS folder1")

# Load required packages
library(tidyverse)
library(sf)
library(ggplot2)

# Column names for the cities file
col_names = c("geonameid", "name", "asciiname", "alternatenames", "latitude", "longitude", 
              "feature class", "feature code", "country code", "cc2", "admin1 code", "admin2 code", 
              "admin3 code", "admin4 code", "population", "elevation", "dem", "timezone", "modification date")

# Read the cities file using here() to ensure the path is correct
cities <- read_csv("C:/Users/HP/Desktop/cities/practice.csv", col_names = col_names)  # Corrected to CSV file

# Clean the data by converting relevant columns to numeric
cities_clean <- cities %>%
  mutate(
    latitude = as.numeric(latitude),
    longitude = as.numeric(longitude)
  ) %>%
  filter(!is.na(latitude) & !is.na(longitude))  # Remove rows with missing coordinates

# Check cleaned data (optional step)
head(cities_clean)

# Convert cities data to spatial data frame
cities_sf <- st_as_sf(cities_clean, coords = c("longitude", "latitude"), crs = 4326)

# Visualize the data with ggplot
ggplot(cities_sf) +
  geom_sf(size = 0.5, color = "orange", alpha = 0.5) +
  labs(title = "Cities Data - Cleaned") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5)
  )
