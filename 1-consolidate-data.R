library(geosphere)

# Locations of cities
#
houston      = c(lon = -95.36, lat =  29.76)
atlanta      = c(lon = -84.39, lat =  33.75)
washington   = c(lon = -77.04, lat =  38.90)
johannesburg = c(lon =  28.08, lat = -26.20)

rmax = 250

load.data <- function(city) {
  print(city)
  files = list.files(path = "data", pattern = paste0("*", city, ".loc"), full.names = TRUE)
  
  W = lapply(files, function(f) {
    print(f)
    d = try(read.table(f, sep = ","), silent = TRUE)
    #
    if (class(d) == "try-error") d = NULL
    #
    return(d)
  })
  #
  W = do.call(rbind, W)[, 1:4]
  #
  names(W) <- c("date", "time", "lat", "lon")
  #
  W$dist = distHaversine(get(city), W[, c("lon", "lat")], r = 6378.137)
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

CITIES = c("atlanta", "houston", "washington", "johannesburg")

wwlln <- lapply(CITIES, load.data)

names(wwlln) <- CITIES

save(wwlln, file = "data/wwlln-data.RData")
