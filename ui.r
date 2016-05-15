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
        "Metrics", icon=icon("pie-chart"), collapsible=
        menuSubItem("Metric 1", tabName="metric-1", icon=icon("line-chart")),
        menuSubItem("Metric 2", tabName="metric-2", icon=icon("area-chart")),
        menuSubItem("Metric 3", tabName="metric-3", icon=icon("bar-chart"))
      ),
      menuItem("Historical Data", tabName="historical-data", icon=icon("history")),
      menuItem("Recommendations", tabName="recommendations", icon=icon("comments"))
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
      tabItem(tabName="overview", h2("Overview"), p("Lorem ipsum dolor sit amet.")),
      tabItem(tabName="plant-map",h2("Plant Map"), p("Lorem ipsum dolor sit amet.") ,leafletOutput("sensorMap")),
      tabItem(tabName="sensor-measure-map",h2("Sensor Map"), p("Lorem ipsum dolor sit amet."), 
              sliderInput("dateSlider", label = h3("Date"),
                          min = 1, max = 25, value = 1), 
              textOutput("dateString"),
              leafletOutput("sensorMeasureMap")),
      tabItem(tabName="metric-1", h2("Metric 1"), p("Lorem ipsum dolor sit amet.")),
      tabItem(tabName="metric-2", h2("Metric 2"), p("Lorem ipsum dolor sit amet.")),
      tabItem(tabName="metric-3", h2("Metric 3"), p("Lorem ipsum dolor sit amet.")),
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
      tabItem(tabName="recommendations", h2("Recommendations"), p("orem ipsum dolor sit amet."))
    )
  )
)