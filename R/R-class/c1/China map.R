install.packages("ggmap")
install.packages("mapproj")
library(ggmap)
library(mapproj)
map <- get_map(location = 'China', zoom = 4)
ggmap(map)
map <- get_map(location = 'Beijing', zoom = 10, maptype = 'roadmap')
ggmap(map)