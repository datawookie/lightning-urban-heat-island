library(ggmap)
library(gridExtra)
library(plotrix)

# http://www.r-bloggers.com/visualising-crime-hotspots-in-england-and-wales-using-ggmap-2/

# GRAB MAPS -------------------------------------------------------------------------------------------------

load("data/city-maps.RData")

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
  W = wwlln[[name]]
  #
  nyear <- attributes(W)$ndays / 365
  #
  # One might think that the "average" radius of an annulus is midway between the inner and outer
  # radii. But this is not true: if you take the probability as being proportional to the area,
  # then the average radius is in fact 2/3 of the way out from the inner radius (ie. closer to the
  # outer radius).
  #
  W$weight = 1 / (2 * pi * (ceiling(W$dist / rbin) - 1/3) * rbin * rbin * nyear)
  #
  # NOTE: Had to do it this rather obscure way so that density and contours are consistent across
  # the edges of the plot. So we set up the plot data, generature the contours/density and only
  # then do we limit the scope of the graph.
  #
  p1 <- ggmap(map, extent = "normal", maprange=FALSE) %+% W + aes(x = lon, y = lat) +
    # geom_point() +
    geom_density2d() +
    stat_density2d(aes(fill = ..level.., alpha = ..level..),
                   size = 0.01, bins = 16, geom = 'polygon') +
    scale_fill_gradient(low = "green", high = "red") +
    scale_alpha(range = c(0.00, 0.25), guide = FALSE) +
    coord_map(projection="mercator", 
              xlim=c(attr(map, "bb")$ll.lon, attr(map, "bb")$ur.lon),
              ylim=c(attr(map, "bb")$ll.lat, attr(map, "bb")$ur.lat)) +
    theme(legend.position = "none", axis.title = element_blank(), text = element_text(size = 18))
  #
  # Note that we use a weighting factor to account for the expansion of the grid cell
  # areas. The weighting factor is the area of the circular "strip" at the distance
  # of the midpoint of the bin.
  #
  p2 <- ggplot(data = W, aes(x = dist)) +
    geom_histogram(aes(weight = weight), binwidth = rbin) +
    xlab("Distance [km]") + ylab(expression(paste("Count [", km^{-2}, " ", yr^{-1}, "]"))) +
    xlim(0, 150) +
    theme_classic() +
    theme(text = element_text(size = 18))
  #
  grid.arrange(p1, p2, ncol = 2, widths = c(0.7, 0.3))
  #
  # Test whether the histogram is uniformly distributed (not sure whether this is meaningful though since
  # distributions which are clearly not uniform are still giving p ~ 1!)
  #
  h = weighted.hist(W$dist, W$weight, breaks = seq(0, rmax, rbin), plot = FALSE)
  #
  print(chisq.test(h$counts))
}

# -----------------------------------------------------------------------------------------------------------

for (city in CITIES) {
  png(paste0("fig/map-hist-", city, ".png"), width = 1200, height = 900)
  plot.map(get(paste0(city, ".map")), city)
  dev.off()
}
