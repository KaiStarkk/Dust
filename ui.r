library(shiny)
library(shinydashboard)
library(leaflet)

dashboardPage(skin="yellow",
  dashboardHeader(
    title = "Operation ClearSky",
    dropdownMenuOutput("alertMenu"),
    dropdownMenuOutput("statusMenu")
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Overview", tabName="overview", icon=icon("circle-o-notch")),
      menuSubItem("Plant Map", tabName="plant-map", icon=icon("map-o")),
      menuSubItem("Sensor Measure Map", tabName="sensor-measure-map", icon=icon("map-o")),
      menuItem(
        "Predictions", icon=icon("pie-chart"), collapsible=
        menuSubItem("Stage 1", tabName="stage-1", icon=icon("line-chart")),
        menuSubItem("Stage 2", tabName="stage-2", icon=icon("area-chart")),
        menuSubItem("Recommendations", tabName="recommendations", icon=icon("comments"))
      ),
      menuItem("Historical Data", tabName="historical-data", icon=icon("history")),
      menuItem("Awareness", tabName="awareness", icon=icon("comments"))
    )
  ),
  dashboardBody(
    tags$head(
      tags$script(src = "https://api.mapbox.com/mapbox.js/plugins/leaflet-fullscreen/v1.0.1/Leaflet.fullscreen.min.js"),
      tags$link(href="https://fonts.googleapis.com/css?family=Slabo+27px", rel="stylesheet", type="text/css"),
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
      tags$link(href = "https://api.mapbox.com/mapbox.js/plugins/leaflet-fullscreen/v1.0.1/leaflet.fullscreen.css", rel="stylesheet")
    ),
    tabItems(
      tabItem(tabName="overview", h2("Overview"),
              fluidRow(
                valueBoxOutput("exceedanceBox"),
                valueBoxOutput("sensorBox")
              )
              ),
      tabItem(tabName="plant-map",h2("Plant Map"),leafletOutput("sensorMap")),
      tabItem(tabName="sensor-measure-map",h2("Sensor Map"), 
              sliderInput("dateSlider", label = h4("Date"),
                          min = 1, max = 25, value = 1), 
              textOutput("dateString"),
              leafletOutput("sensorMeasureMap")),
      tabItem(tabName="stage-1", h2("Stage 1"),
              box(
                title = "Bureau of Meteorology - Wind Speed & Direction Forecast", width = 12, status = "warning",
                tags$img(src="images/wind-forecast.png", style="width:100%")
              )
              ),
      tabItem(tabName="stage-2", h2("Stage 2"), h4("Based on the wind speed and direction:"), h4("- the following dust levels are predicted."), br(),
              box(
                title = "Dust Level Forecast", width = 12, status = "warning",
                tags$img(src="images/forecast.png", style="width:100%")
              ),
              h2("This represents an exceedence of the license.")
      ),
      tabItem(tabName="recommendations", h2("Recommendations"), h4("Based on the wind speed and direction:"), h4("- use of the following equipment configurations should be AVOIDED, if possible."), br(),
              box(
                title = "Equipment Combinations", width = 12, status = "warning",
                tags$img(src="images/equipment-combination.png", style="width:100%")
              )              
      ),
      tabItem(
              tabName="historical-data", 
              h2("Historical Data"),
              fluidRow(
                box(
                  title = "Dust Alerts Over Time", width = 12, status = "warning",
                  tags$img(src="images/Dust-Alerts-Over-Time.jpg", style="width:100%")
                )
              ),
              fluidRow(
                box(
                  title = "Daily Average Dust vs. Solar Radiation", width = 6, status = "success", 
                  tags$img(src="images/Dust-Against-Solar-Radiation.jpg", style="width:100%")
                ),
                box(
                  title = "Daily Average Dust vs. Temperature", width = 6,
                  tags$img(src="images/Dust-Against-Temperature.jpg", style="width:100%")
                )
              )
              ),
      tabItem(tabName="awareness",
              box(
                title = "Motivation", width = 12,
                tags$img(src="images/Motivation.png", style="width:100%")
              )
      )
    )
  )
)