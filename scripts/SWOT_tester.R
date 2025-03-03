
# 1. Libraries and paths --------------------------------------------------

library(ncdf4)
library(RColorBrewer)
library(ggplot2)
library(dplyr)
library(terra)

setwd('/Users/jmaze/Documents/projects/GEOG590-SWOTR')

data_raw_path <- './data_raw/'


# 2. Test SWOT data imaging -----------------------------------------------

swot_path <- paste0(data_raw_path, 'SWOT1.nc')
tester <- nc_open(swot_path)

x <- ncvar_get(tester, 'x')
y <- ncvar_get(tester, 'y')


#print(c(x, y))

wtr_array <- ncvar_get(tester, 'wse')
range(wtr_array, na.rm = TRUE)
image(x, y, wtr_array, col = rev(brewer.pal(10, 'RdBu')))

# water area units should be m^2, for 100m pixels, min should be 0 and max should be 10,000

wtr_vector <- na.omit(as.vector(wtr_array))
wtr_df <- data.frame(value = wtr_vector) %>% 
  filter(0 < value & value < 1000000)

# Quick histogram for the SWOT
p<- ggplot(data = wtr_df,
           mapping = aes(x = value)) +
  geom_histogram(bins = 500) +
  theme_bw() +
  scale_y_log10()

(p)

breaks <- seq(min(wtr_array, na.rm = TRUE), max(wtr_array, na.rm = TRUE), length.out = 11)
colors <- colorRampPalette(rev(brewer.pal(10, "RdBu")))(length(breaks) - 1)
image(x, y, wtr_array, col = colors, breaks = breaks)


# 3. Read the GSW data ----------------------------------------------------

gsw_occurance_path <- paste0(data_raw_path, "occurrence_130W_50Nv1_4_2021.tif")
gsw_occurance <- rast(gsw_occurance_path)


gsw_max_path <- paste0(data_raw_path, "extent_130W_50Nv1_4_2021.tif")
gsw_max <- rast(gsw_max_path)

# Match GSW with SWOT -----------------------------------------------------

tester2 <- rast(tester_path)
image(tester2)


crs_gsw <- crs(gsw_max)  
crs_swot <- crs(tester2)

# Sheeeshhh this takes a while
gsw_max <- project(gsw_max, crs_swot)
# > gsw_max <- project(gsw_max, crs_swot)
# Warning message:                          
#   In doTryCatch(return(expr), name, parentenv, handler) :
#   restarting interrupted promise evaluation

gsw_max_clip <- crop(gsw_max, ext(tester2))

max_clipped_vals <- values(gsw_max_clip) %>% 
  na.omit() %>% 
  data.frame()

p<- ggplot(data = max_clipped_vals,
           mapping = aes(x = value)) +
  geom_histogram(bins = 500) +
  theme_bw() +
  scale_y_log10()

(p)

image(gsw_max_clip)
image(tester2)  
  



