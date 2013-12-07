library(ggmap)

# ATLANTA ---------------------------------------------------------------------------------------------------

# WASHINGTON ------------------------------------------------------------------------------------------------

# HOUSTON ---------------------------------------------------------------------------------------------------

if (!exists("houston")) {
  houston = get_map(location = c(lon = -95.3, lat = 29.95), zoom = 9, color = "bw")
}

ggmap(houston) +
  geom_point(data = wwlln$houston, aes(x = lon, y = lat)) +
  stat_density2d(aes(x = lon, y = lat, fill = ..level.., alpha = ..level..),
               size = 1, bins = 4,
               geom = 'polygon')