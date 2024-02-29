library(ncdf4)
library(RColorBrewer)
library(ggplot2)

setwd('/Users/jmaze/Documents/projects/swotrrr')

data_raw_path <- './data_raw/'

# 
tester_path <- paste0(data_raw_path, 'SWOT_L2_HR_Raster_100m_UTM34K_N_x_x_x_484_001_063F_20230407T204900_20230407T204921_PIB0_01.nc')
tester <- nc_open(tester_path)

x <- ncvar_get(tester, 'x')
y <- ncvar_get(tester, 'y')


#print(c(x, y))

wtr_array <- ncvar_get(tester, 'water_area')
range(wtr_array, na.rm = TRUE)
image(x, y, wtr_array, col = rev(brewer.pal(10, 'RdBu')))



#############################################################################
tester2_path <- paste0(data_raw_path, 'SWOT_L2_HR_Raster_250m_UTM34K_N_x_x_x_484_001_063F_20230407T204900_20230407T204921_PIB0_01.nc')
tester2 <- nc_open(tester2_path)

x2 <- ncvar_get(tester2, 'x')
y2 <- ncvar_get(tester2, 'y')


#print(c(x, y))

wtr_array2 <- ncvar_get(tester2, 'water_area')
range(wtr_array2, na.rm = TRUE)

breaks <- seq(min(wtr_array2, na.rm = TRUE), max(wtr_array2, na.rm = TRUE), length.out = 11)
colors <- colorRampPalette(rev(brewer.pal(10, "RdBu")))(length(breaks) - 1)

image(x2, y2, wtr_array2, col = colors, breaks = breaks)




