library(shiny)
library(shinydashboard)
library(leaflet)
library(leafletplugins)

server <- function(input, output) {
  sensorLocs=read.csv("data/MAP_Sensor_Locations.csv")
  sensorIcon <- makeIcon(
    iconUrl = "resources/sensor-icon.png",
    iconWidth = 20, iconHeight = 20,
    iconAnchorX = 10, iconAnchorY = 10
  )
  output$sensorMap <- renderLeaflet({
    require(leaflet)
    m <- leaflet()
    m <- addControlFullScreen(m)
    m <- addTiles(m)
    m <- addMarkers(m, icon=sensorIcon, lng=sensorLocs$Longitude, lat=sensorLocs$Latitude, 
                    popup=sensorLocs$Sample.Point, 
                    clusterOptions=markerClusterOptions(showCoverageOnHover = FALSE, maxClusterRadius = 20)
                    )
  })
}