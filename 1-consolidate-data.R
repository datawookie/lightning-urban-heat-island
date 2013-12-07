load.data <- function(city) {
  files = list.files(path = "data", pattern = paste0("*", city, ".loc"), full.names = TRUE)
  
  W = lapply(files, function(f) {
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
  W
}

CITIES = c("atlanta", "houston", "washington")

wwlln <- lapply(CITIES, load.data)

names(wwlln) <- CITIES

save(wwlln, file = "data/wwlln-data.RData")
