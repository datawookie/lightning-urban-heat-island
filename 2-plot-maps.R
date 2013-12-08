library(ggmap)
library(gridExtra)

# http://www.r-bloggers.com/visualising-crime-hotspots-in-england-and-wales-using-ggmap-2/

# GRAB MAPS -------------------------------------------------------------------------------------------------

if (!exists("houston.map")) {
  houston.map = get_map(location = houston, zoom = 8, color = "bw")
}
if (!exists("atlanta.map")) {
  atlanta.map = get_map(location = atlanta, zoom = 8, color = "bw")
}
if (!exists("washington.map")) {
  washington.map = get_map(location = washington, zoom = 8, color = "bw")
}
if (!exists("johannesburg.map")) {
  johannesburg.map = get_map(location = johannesburg, zoom = 8, color = "bw")
}

save(houston.map, atlanta.map, washington.map, johannesburg.map, file = "data/city-maps.RData")

# PLOTTING FUNCTION -----------------------------------------------------------------------------------------

rbin = 10

plot.map <- function(map, name) {
  p1 <- ggmap(map, extent = "panel") +
    # geom_point(data = wwlln[[name]], aes(x = lon, y = lat)) +
    geom_density2d(data = wwlln[[name]], aes(x = lon, y = lat)) +
    stat_density2d(data = wwlln[[name]], aes(x = lon, y = lat, fill = ..level.., alpha = ..level..),
                   size = 1, bins = 4, geom = 'polygon') +
    theme(legend.position = "none", axis.title = element_blank()) +
    scale_fill_gradient(low = "yellow", high = "red")
  #
  # Note that we use a weighting factor to account for the expansion of the grid cell
  # areas.
  #
  p2 <- ggplot(data = wwlln[[name]], aes(x = dist)) +
    geom_histogram(aes(weight = 1 / (2 * pi * (ceiling(dist / rbin) - 0.5) * rbin)), binwidth = rbin) +
    xlab("Distance [km]") + ylab(expression(paste("Count [", km^{-2}, "]"))) +
    xlim(0, 150) +
    theme_classic()
  #
  grid.arrange(p1, p2, ncol = 2, widths = c(0.7, 0.3))
}

# -----------------------------------------------------------------------------------------------------------

for (c in CITIES) {
  png(paste0("fig/map-hist-", c, ".png"), width = 800, height = 600)
  plot.map(get(paste0(c, ".map")), c)
  dev.off()
}
