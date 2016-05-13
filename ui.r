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
      "Results", icon=icon("pie-chart"), collapsible=
      menuSubItem("Result 1", tabName="result-1", icon=icon("line-chart")),
      menuSubItem("Result 2", tabName="result-2", icon=icon("area-chart")),
      menuSubItem("Result 3", tabName="result-3", icon=icon("bar-chart"))
    ),
    menuItem("Recommendations", tabName="recommendations", icon=icon("comments"))
  )
),
dashboardBody(
  tags$style(type = "text/css", "#sensorMap {height: calc(91vh - 80px) !important;}"),
  tabItems(
    tabItem(tabName="overview", h2("Overview"), p("Lorem ipsum dolor sit amet.")),
    tabItem(tabName="plant-map",h2("Plant Map"), p("Lorem ipsum dolor sit amet."), leafletOutput("sensorMap")),
    tabItem(tabName="result-1", h2("Result 1"), p("Lorem ipsum dolor sit amet.")),
    tabItem(tabName="result-2", h2("Result 2"), p("Lorem ipsum dolor sit amet.")),
    tabItem(tabName="result-3", h2("Result 3"), p("Lorem ipsum dolor sit amet.")),
    tabItem(tabName="recommendations", h2("Recommendations"), p("Lorem ipsum dolor sit amet."))
  )
)
)