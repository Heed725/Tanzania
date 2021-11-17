# install.packages(c("raster","ggplot2", "magrittr", "sf"))
# remotes::install_github("wmgeolab/rgeoboundaries")
library(raster)
library(ggplot2)
library(magrittr)
library(sf)
library(rgeoboundaries)


# Downloading monthly maximum temperature data
tmax_data <- getData(name = "worldclim", var = "tmax", res = 10)

# Converting temperature values to Celcius
gain(tmax_data) <- 0.1

# Calculating mean of the monthly maximum temperatures
tmax_mean <- mean(tmax_data)

# Downloading the boundary of Nigeria
nigeria_sf <- geoboundaries("Tanzania")

# Extracting temperature data of Nigeria
tmax_mean_ngeria <- raster::mask(tmax_mean, as_Spatial(nigeria_sf))

# Converting the raster object into a dataframe
tmax_mean_nigeria_df <- as.data.frame(tmax_mean_ngeria, xy = TRUE, na.rm = TRUE)

tmax_mean_nigeria_df %>%
  ggplot(aes(x = x, y = y)) +
  geom_raster(aes(fill = layer)) +
  geom_sf(data = nigeria_sf, inherit.aes = FALSE, fill = NA) +
  labs(
    title = "Mean monthly maximum temperatures in Tanzania",
    subtitle = "For the years 1970-2000"
  ) +
  xlab("Longitude") +
  ylab("Latitude") +
  scale_fill_gradient(
    name = "Temperature (°C)",
    low = "#FEED99",
    high = "#AF3301"
  )
