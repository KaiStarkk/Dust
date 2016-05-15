library(shiny)
library(shinydashboard)
library(leaflet)
library(leafletplugins)
library(RColorBrewer)

server <- function(input, output) {
  
  # --------------------- Load Sensor Information ---------------------
  sensorLocs = read.csv("data/MAP_Sensor_Locations.csv")
  
  # ------------------- Load Equipment Information --------------------
  equipment<-read.csv("data/Equipment_with_Coords.csv")
  
  # Calculate Urgent Information
  names = sensorLocs$Sample.Point
  values = sample(1:100, length(names), replace=T)
  current = data.frame(names, values)
  
  alerts = length(which(current$values >= 70))
  alertStatus = "danger"
  if (alerts <= 5) {
    alertStatus = "warning"
  }
  
  #Create dataframe that has number of triggers per sensor
  sensorsOverTime <- read.csv("data/sensorsOverTime.csv")
  
  # Remove the airport sensor as it's far away and messing the map zoom
  sensorLocs <- sensorLocs[-c(8),]
  
  # ---------------------- Prepare for Mapping ------------------------
  sensorIcon <- makeIcon(
    iconUrl = "resources/sensor-icon.png",
    iconWidth = 20, iconHeight = 20,
    iconAnchorX = 10, iconAnchorY = 10
  )
  
  output$sensorMap <- renderLeaflet({
    m <- leaflet()
    m <- addControlFullScreen(m)
    m <- addTiles(m)

    m <- addMarkers(m, icon=sensorIcon, lng=sensorLocs$Longitude, lat=sensorLocs$Latitude, 
                    popup=sensorLocs$Sample.Point, 
                    clusterOptions=markerClusterOptions(showCoverageOnHover = FALSE, maxClusterRadius = 20), group="Sensors"
                    )
    
    m <- addMarkers(m, lng=equipment$Longitude, lat=equipment$Latitude,
                    popup=equipment$Code, group=equipment$Type)
    
    # Layers control
    m <-addLayersControl(m, overlayGroups = c("Sensors", levels(equipment$Type)),
      options = layersControlOptions(collapsed = FALSE)
    )    
  })
  
  flag<-0
  
  output$dateString <- renderText({
    
    selectedDate <- input$dateSlider
    date <- colnames(sensorsOverTime[selectedDate+2])
    date <- substr(date, 2,8)
  })
  
  output$sensorMeasureMap <- renderLeaflet({
    
  #selectedDate <- input$dateSlider
    
   #   sensorsOverTime$triggers <- as.numeric((sensorsOverTime[,selectedDate+1]*100))
     # m <- leaflet()
     # m <- addCircles(m, lng=sensorLocs$Longitude, lat=sensorLocs$Latitude, weight=1, 
      #                radius=sqrt(sensorsOverTime$triggers), popup = sensorLocs$Sample.Point)
      #m <- addTiles(m)
    m <- leaflet()
    m <- addControlFullScreen(m)
    m <- addTiles(m)
    
    m <- addMarkers(m, icon=sensorIcon, lng=sensorLocs$Longitude, lat=sensorLocs$Latitude, 
                    popup=sensorLocs$Sample.Point, 
                    clusterOptions=markerClusterOptions(showCoverageOnHover = FALSE, maxClusterRadius = 20), group="Sensors"
    )
    
  })
  
  observe({
     selectedDate <- input$dateSlider
     proxyCir <- leafletProxy("sensorMeasureMap", data=sensorLocs)
      proxyCir <- clearShapes(proxyCir) 
      
      
      listToPlot <- as.numeric(sensorsOverTime[,selectedDate+1])
      
      proxyCir <- addCircles(proxyCir, radius = listToPlot*10, weight = 1, color = "#B0171F", 
                             fillColor ='#B0171F',
                fillOpacity = 0.5, popup = sensorLocs$Sample.Point)
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
