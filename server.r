library(shiny)
library(shinydashboard)
library(leaflet)
library(leafletplugins)
library(RColorBrewer)

server <- function(input, output) {
  
  pwdCheck <- 0
  
  # --------------------- Load Sensor Information ---------------------
  sensorLocs = read.csv("data/MAP_Sensor_Locations.csv")
  
  # ------------------- Load Equipment Information --------------------
  equipment<-read.csv("data/Equipment_with_Coords.csv")
  
  # Calculate Urgent Information
  names = sensorLocs$Sample.Point
  values = sample(1:100, length(names), replace=T)
  current = data.frame(names, values)
  
  alerts = length(which(current$values >= 50))
  alertStatus = "danger"
  alertColor = "red"
  alertIcon = "exclamation-triangle"
  if (alerts <= 5) {
    alertStatus = "warning"
    alertColor = "yellow"
  }
  if (alerts == 0) {
    alertStatus = "success"
    alertColor = "green"
    alertIcon = "tick"
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
    
    username <- input$username
    password <- input$password
    
    if(username=="BHP" & password=="MineHack" ){
      pwdCheck = 1
    }
    else{
      pwdCheck = 0
    }
    
    if(pwdCheck==1){
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
    }
  })
  
  flag<-0
  
  output$dateString <- renderText({
    
    selectedDate <- input$dateSlider
    date <- colnames(sensorsOverTime[selectedDate+2])
    date <- substr(date, 2,8)
  })
  
  output$sensorMeasureMap <- renderLeaflet({
    username <- input$username
    password <- input$password
    
    if(username=="BHP" & password=="MineHack" ){
      pwdCheck = 1
    }
    else{
      pwdCheck = 0
    }
    
    if(pwdCheck==1){
    m <- leaflet()
    m <- addControlFullScreen(m)
    m <- addTiles(m)
    
    m <- addMarkers(m, icon=sensorIcon, lng=sensorLocs$Longitude, lat=sensorLocs$Latitude, 
                    popup=sensorLocs$Sample.Point, 
                    clusterOptions=markerClusterOptions(showCoverageOnHover = FALSE, maxClusterRadius = 20), group="Sensors"
    )
    }
    
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
  
  output$imageWeather <- renderUI({
    username <- input$username
    password <- input$password
    
    if(username=="BHP" & password=="MineHack" ){
      pwdCheck = 1
    }
    else{
      pwdCheck = 0
    }
    if(pwdCheck==1)
      tags$img(src="images/wind-forecast.png", style="max-width:100%")
  })
  
  output$imageForecast <- renderUI({
    username <- input$username
    password <- input$password
    
    if(username=="BHP" & password=="MineHack" ){
      pwdCheck = 1
    }
    else{
      pwdCheck = 0
    }
    if(pwdCheck==1)
    tags$img(src="images/forecast.png", style="max-width:600px")
    })
  
  output$imageRecom <- renderUI({
    username <- input$username
    password <- input$password
    
    if(username=="BHP" & password=="MineHack" ){
      pwdCheck = 1
    }
    else{
      pwdCheck = 0
    }
    if(pwdCheck==1)
      tags$img(src="images/equipment-combination.png", style="max-width:600px")
  })
  
  output$imageDustOverTime <- renderUI({
    username <- input$username
    password <- input$password
    
    if(username=="BHP" & password=="MineHack" ){
      pwdCheck = 1
    }
    else{
      pwdCheck = 0
    }
    if(pwdCheck==1)
      tags$img(src="images/Dust-Alerts-Over-Time.jpg", style="width:100%")
  })
  
  output$imageDustSolar<- renderUI({
    username <- input$username
    password <- input$password
    
    if(username=="BHP" & password=="MineHack" ){
      pwdCheck = 1
    }
    else{
      pwdCheck = 0
    }
    if(pwdCheck==1)
      tags$img(src="images/Dust-Against-Solar-Radiation.jpg", style="width:100%")
  })
  
  output$imageDustTemp<- renderUI({
    username <- input$username
    password <- input$password
    
    if(username=="BHP" & password=="MineHack" ){
      pwdCheck = 1
    }
    else{
      pwdCheck = 0
    }
    if(pwdCheck==1)
      tags$img(src="images/Dust-Against-Temperature.jpg", style="width:100%")
  })
  
  output$imageAwareness<- renderUI({
    username <- input$username
    password <- input$password
    
    if(username=="BHP" & password=="MineHack" ){
      pwdCheck = 1
    }
    else{
      pwdCheck = 0
    }
    if(pwdCheck==1)
      tags$img(src="images/Motivation.png", style="width:100%")
  })
  
  if (alerts > 0) {
    output$alertMenu <- renderMenu({
     username <- input$username
      password <- input$password
      numberOfAlerts <- 0
      
      if(username=="BHP" & password=="MineHack" ){
        pwdCheck = 1
        numberOfAlerts <-alerts
      }
      
      
      dropdownMenu(type="notifications", badgeStatus = alertStatus,
                   notificationItem(
                     text = paste(numberOfAlerts, "sensors detecting >= 70ug/m3", sep=" "),
                     icon = icon("exclamation-triangle"),
                     status = "warning"
                   ))
    })
  }
  
  output$statusMenu <- renderMenu({
    #username <- input$username
    #password <- input$password
    #rowName <- ""
    #rowValue <- 0
    
    #if(username=="BHP" & password=="MineHack" ){
     # pwdCheck = 1
      #rowValue = row[["values"]]
      #rowName = row[["names"]]
    #}
    
    #statuses <- apply(current,1,function(row){
      
     # rowStatus = "green"
      #if (rowValue >= 70) {
       # rowStatus = "red"
      #} else if (rowValue >= 35) {
       # rowStatus = "yellow"
      #}
      #taskItem(value=rowValue, color=rowStatus, paste(rowName," - ",rowValue,"ug/m3"))
    #})
    #dropdownMenu(type="tasks", badgeStatus=alertStatus, .list=statuses)
  })
  
  # ---------------------- Overview graphic information -------------------------
  
  
  output$exceedanceBox <- renderValueBox({
    username <- input$username
    password <- input$password
    numberOfExc <-0
    
    if(username=="BHP" & password=="MineHack" ){
      
      numberOfExc <-alerts
    }
    valueBox(
      numberOfExc, "Exceedances", icon = icon(alertIcon),
      color = alertColor
    )
  })
  output$sensorBox <- renderValueBox({
    username <- input$username
    password <- input$password
    numberOfSensors <-0
    
    if(username=="BHP" & password=="MineHack" ){
      
      numberOfSensors <-length(names)
    }
   
    
    valueBox(
      numberOfSensors, "Sensors Online", icon = icon("list", lib = "glyphicon"),
      color = "blue"
    )
  
  })
  
  
  

}
