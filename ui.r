library(shinydashboard)
dashboardPage(
dashboardHeader(title = "Dust"),
dashboardSidebar(
  sidebarMenu(
    menuItem("Overview", tabName="overview", icon=icon("circle-o-notch")),
    menuSubItem("Location", tabName="location", icon=icon("map-o")),
    menuItem(
      "Results", icon=icon("pie-chart"), tabName="results", collapsible=
        menuSubItem("Result 1", tabName="result-1", icon=icon("line-chart")),
      menuSubItem("Result 2", tabName="result-2", icon=icon("area-chart")),
      menuSubItem("Result 3", tabName="result-3", icon=icon("bar-chart"))
    ),
    menuItem("Recommendations", tabName="recommendations", icon=icon("comments"))
  )
),
dashboardBody(
  tabItems(
    tabItem(tabName="location", h2("Plant Map"), leafletOutput("sensorMap"))
  )
)
)