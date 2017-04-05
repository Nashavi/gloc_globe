setwd("~/Documents/UCD/BA Prac/gloc_globe")
library(jsonlite)
require(dplyr)
devtools::install_github("bwlewis/rthreejs")
require(threejs)
system.time(x <- fromJSON("LocationHistory.json"))
system.time(y <- fromJSON("LocationHistory2.json"))

loc = x$locations
loc2 = y$locations

# converting time column from posix milliseconds into a readable time scale
loc$time = as.POSIXct(as.numeric(x$locations$timestampMs)/1000, origin = "1970-01-01")
loc2$time = as.POSIXct(as.numeric(y$locations$timestampMs)/1000, origin = "1970-01-01")

loc<- rbind(loc,loc2)

# converting longitude and latitude from E7 to GPS coordinates
loc$lat = loc$latitudeE7 / 1e7
loc$lon = loc$longitudeE7 / 1e7


ds<- loc[,c(9:11)]

ds<- arrange(ds,time)

ds<-ds[,c(2,3)]
ds<-unique(ds)

ds$lat<-round(ds$lat,2)
ds$lon<-round(ds$lon,2)

ds<-unique(ds)
ds$laglat<- lag(ds$lat)
ds$laglon<- lag(ds$lon)

ds<-ds[-1,]


save(ds,file="myloc2.RData")

runApp(system.file("examples/globe", package="threejs"))
earth <- system.file("images/world.jpg",  package="threejs")
output$globe <- renderGlobe({ 
  globejs(img=earth, lat=ds[,1], long=ds[,2], arcs=ds,
        arcsHeight=0.3, arcsLwd=2, arcsColor="#ffff00", arcsOpacity=0.15, atmosphere=TRUE)
})
})

