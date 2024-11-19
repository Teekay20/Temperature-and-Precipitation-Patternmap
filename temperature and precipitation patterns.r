# Load necessary libraries
library(ggplot2)
library(biscale)
library(cowplot)
library(sf)

# Classify the temperature and precipitation data into bivariate classes
data <- bi_class(temp_ppt_df,
                 x = temp, 
                 y = ppt, 
                 style = "quantile", 
                 dim = 4)

# Remove rows with missing values in bi_class
data_clean <- na.omit(data)

# Set the color palette for the bivariate map
pallet <- "BlueOr"

# Create the bivariate map using ggplot2
map <- ggplot(data_clean) +
  theme_void(base_size = 14) +  # Set a minimal theme for the map
  coord_fixed() +  # Maintain a fixed aspect ratio
  geom_raster(aes(x = x, y = y, fill = bi_class), data = data_clean, show.legend = FALSE) +
  bi_scale_fill(pal = pallet, dim = 4, flip_axes = FALSE, rotate_pal = FALSE) +
  geom_sf(data = nigeria1, fill = NA, color = "black", size = 0.20) +  
  geom_sf(data = nigeria0, fill = NA, color = "black", size = 0.40) +  
  labs(title = "Nigeria: Temperature and Precipitation Patterns", 
       subtitle = "Mean temperature and precipitation patterns based on 50 years of data.",
       caption = "Source: Terra Climate Data     Author: Taiwo Kayode") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"),
        plot.subtitle = element_text(hjust = 0.5),
        plot.caption = element_text(size = 10, face = "bold", hjust = 0.5),
        plot.margin = margin(1, 1, 1, 1, "cm"))  # Adjust margins as needed

# Create the legend for the bivariate map
legend <- bi_legend(pal = pallet,   
                    flip_axes = FALSE,
                    rotate_pal = FALSE,
                    dim = 4,
                    xlab = "Temperature (°C)",
                    ylab = "Precipitation (mm)",
                    size = 10)

# Combine the map and legend using cowplot
finalPlot <- ggdraw() +
  draw_plot(map, 0.05, 0.05, 0.85, 0.85) +  # Adjusted position and size
  draw_plot(legend, 0.05, 0.05, 0.30, 0.30)  # Draw the legend in the specified position

# Display the final map with legend
print(finalPlot)

# Save the final plot
ggsave("C:/Users/HP/Desktop/Nigeria_Temp_PPT.png", 
       plot = finalPlot,   # The plot object you want to save
       device = "png",     # Specify the device to use, in this case PNG
       dpi = 400,          # Set the resolution (dots per inch)
       width = 10,         # Width in inches
       height = 8)         # Height in inches
