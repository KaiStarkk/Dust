library(shiny)
library(shinydashboard)
library(leaflet)

dashboardPage(skin="yellow",
dashboardHeader(title = "Dust"),
dashboardSidebar(
  sidebarMenu(
    menuItem("Overview", tabName="overview", icon=icon("circle-o-notch")),
    menuSubItem("Plant Map", tabName="plant-map", icon=icon("map-o")),
    menuItem(
      "Metrics", icon=icon("pie-chart"), collapsible=
      menuSubItem("Metric 1", tabName="metric-1", icon=icon("line-chart")),
      menuSubItem("Metric 2", tabName="metric-2", icon=icon("area-chart")),
      menuSubItem("Metric 3", tabName="metric-3", icon=icon("bar-chart"))
    ),
    menuItem("Recommendations", tabName="recommendations", icon=icon("comments"))
  )
),
dashboardBody(
  tags$style(type = "text/css", "#sensorMap {height: calc(91vh - 80px) !important;}"),
  tabItems(
    tabItem(tabName="overview", h2("Overview"), p("Lorem ipsum dolor sit amet.")),
    tabItem(tabName="plant-map",h2("Plant Map"), p("Lorem ipsum dolor sit amet."), leafletOutput("sensorMap")),
    tabItem(tabName="metric-1", h2("Metric 1"), p("Lorem ipsum dolor sit amet.")),
    tabItem(tabName="metric-2", h2("Metric 2"), p("Lorem ipsum dolor sit amet.")),
    tabItem(tabName="metric-3", h2("Metric 3"), p("Lorem ipsum dolor sit amet.")),
    tabItem(tabName="recommendations", h2("Recommendations"), p("Lorem ipsum dolor sit amet."))
  )
)
)