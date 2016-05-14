library(shiny)
library(shinydashboard)
library(leaflet)
library(leafletplugins)

server <- function(input, output) {
  sensorLocs = read.csv("data/MAP_Sensor_Locations.csv")
  names = sensorLocs$Sample.Point
  values = sample(1:100, length(names), replace=T)
  current = data.frame(names, values)
  
  alerts = length(which(current$values >= 70))
  alertStatus = "danger"
  if (alerts <= 5) {
    alertStatus = "warning"
  }
  
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
  
  if (alerts > 0) {
    output$alertMenu <- renderMenu({
      dropdownMenu(type="notifications", badgeStatus = alertStatus,
                   notificationItem(
                     text = paste(alerts, "sensors detecting >= 70ug/m3", sep=" "),
                     icon = icon("exclamation-triangle"),
                     status = "warning"
                   ))
    })
  }
  
  output$statusMenu <- renderMenu({
    statuses <- apply(current,1,function(row){
      rowValue = row[["values"]]
      rowName = row[["names"]]
      rowStatus = "green"
      if (rowValue >= 70) {
        rowStatus = "red"
      } else if (rowValue >= 35) {
        rowStatus = "yellow"
      }
      taskItem(value=rowValue, color=rowStatus, rowName)
    })
    dropdownMenu(type="tasks", badgeStatus=alertStatus, .list=statuses)
  })
}