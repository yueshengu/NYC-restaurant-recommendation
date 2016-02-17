
library('shiny')
require('rCharts')
library('shinydashboard')
library('plyr')
require(RJSONIO)
library(leaflet)
options(stringsAsFactors = F)

brks<-c(0,1e4,5e4,1e5,2.5e5,5e5,1e6)
nb<-length(brks)

palfun<-colorFactor(palette=c("navy","navy","magenta4","magenta4","red","red"),domain=1:(nb-1))



toGeoJSON = function(list_){
  x = lapply(list_, function(l){
    list(
      type = 'Feature',
      geometry = list(
        type = 'Point',
        coordinates = c(l$longitude, l$latitude)
      ),
      properties = l[!(names(l) %in% c('latitude', 'longitude'))]
    )
  })
}

load("./www/uniqueRestau4.RData")


# data_ = fromJSON('http://citibikenyc.com/stations/json', encoding = 'UTF-8')
# bike = data_[[2]]
# bike = bike[-13] # bad encoding
# bike2 <- lapply(bike, function(station){
#   station$fillColor = if(station$totalDocks == 0){
#     '#eeeeee'
#   } else {
#     cut(station$availableBikes/station$totalDocks, 
#         breaks = c(0, 0.20, 0.40, 0.60, 0.80, 1), 
#         labels = RColorBrewer::brewer.pal(5, 'RdYlGn'),
#         include.lowest = TRUE
#     ) 
#   }
#   station$popup = whisker::whisker.render('<b>{{station.stationName}}</b><br>
#                                           <b>Total Docks: </b> {{station.totalDocks}} <br>
#                                           <b>Available Bikes:</b> {{station.availableBikes}}
#                                           <p>Retreived At: {{ time }}</p>', list(station = station, time = data_[[1]]))
#   return(station)
# })
# 
# 
# df <- data.frame(matrix(unlist(bike2), nrow=506, byrow=T))
# names(df)<-names(bike2[[1]])
# df$availableDocks<-as.numeric(df$availableDocks)
# df$fillColor<-as.numeric(df$fillColor)
