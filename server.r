library(shiny)
library(shinydashboard)
library(leaflet)

server <- function(input, output) {
  sensorLocs=read.csv("data/MAP_Sensor_Locations.csv")
  
  output$sensorMap <- renderLeaflet({
    require(leaflet)
    
    m <- leaflet()
    m <- addTiles(m)
    
    m <- addMarkers(m, lng=sensorLocs$Longitude, lat=sensorLocs$Latitude, popup=sensorLocs$Sample.Point)
    
  })
}