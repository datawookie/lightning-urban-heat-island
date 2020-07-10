library(geosphere)
library(plyr)

# Locations of cities
#
city = read.table(text ="
houston       -95.36  29.76
atlanta       -84.39  33.75
washington    -77.04  38.90
johannesburg   28.08 -26.20
bloemfontein   26.22 -29.18
durban         31.05 -29.88
capetown       18.42 -33.92
", col.names = c("name", "lon", "lat"))

rmax = 250

load.data <- function(C) {
  print(C)
  files = list.files(path = "data", pattern = paste0("*", C, ".loc"), full.names = TRUE)
  
  W = lapply(files, function(f) {
    print(f)
    d = try(read.table(f, sep = ","), silent = TRUE)
    #
    if (class(d) == "try-error") d = NULL
    #
    return(d)
  })
  #
  W = rbind.fill(W)[, 1:4]
  #
  names(W) <- c("date", "time", "lat", "lon")
  #
  W$dist = distHaversine(subset(city, name == C)[, c("lon", "lat")], W[, c("lon", "lat")], r = 6378.137)
  #
  # Retain only "nearby" data
  #
  W <- subset(W, dist <= rmax)
  #
  # Consolidate date and time to decimal format
  #
  # W$time <- as.POSIXct(paste(W$date, W$time), format = "%Y/%m/%d %H:%M:%S", tz = "GMT")
  W$time <- NULL
  W$date <- NULL
  #
  attributes(W)$ndays = length(files)
  #
  W
}

wwlln <- lapply(city$name, load.data)

names(wwlln) <- city$name

save(wwlln, file = "data/wwlln-data.RData")
