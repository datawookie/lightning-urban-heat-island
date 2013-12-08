library(ggmap)
library(geosphere)
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

# PLOTTING FUNCTION -----------------------------------------------------------------------------------------

plot.map <- function(map, name) {
  p1 <- ggmap(map, extent = "panel") +
    # geom_point(data = wwlln[[name]], aes(x = lon, y = lat)) +
    stat_density2d(data = wwlln[[name]], aes(x = lon, y = lat, fill = ..level.., alpha = ..level..),
                   size = 1, bins = 4, geom = 'polygon') +
    theme(legend.position = "none", axis.title = element_blank()) +
    scale_fill_gradient(low = "yellow", high = "red") +
    scale_alpha(range = c(.25, .75), guide = FALSE)
  #
  # Note that we use a weighting factor to account for the expansion of the grid cell
  # areas.
  #
  p2 <- ggplot(data = wwlln[[name]], aes(x = dist)) +
    geom_histogram(aes(weight = 1 / (2 * pi *dist))) +
    xlab("Distance [km]") + ylab(expression(paste("Count [", km^{-2}, "]"))) +
    xlim(0, 150) +
    theme_classic()
  #
  grid.arrange(p1, p2, ncol = 2)
}

# ATLANTA ---------------------------------------------------------------------------------------------------

# WASHINGTON ------------------------------------------------------------------------------------------------

plot.map(washington.map, "washington")

# HOUSTON ---------------------------------------------------------------------------------------------------

plot.map(houston.map, "houston")