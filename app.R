#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/


library(shiny)
library(leaflet)
# Define UI

ui <- fluidPage(
  # Give the page a title
  titlePanel("Terrorism in Turkey"),
  # Generate a row with a sidebar
  sidebarPanel(
    sliderInput(inputId = "year", label = "Year of Casualty:",
                value = 2010, min = 1970, max = 2016),
    hr(),
    helpText("Source: Global Terrorism Database, START Consortium")
  ),
  # Show a plot of the generated distribution
  mainPanel(
    leafletOutput("map")
  )
)


# Define server logic

server <- shinyServer(function(input, output) {
  p = data.frame(year=gtd.turkey$year,lon=gtd.turkey$longitude, lat=gtd.turkey$latitude)
  
  output$map = renderLeaflet({
    leaflet() %>%
      addProviderTiles("Stamen.TonerLite") %>% 
      setView(lng = 34.85427, lat = 39.91987, zoom = 5)
  })
  observe({
    leafletProxy("map") %>% clearShapes()%>%
      addCircles(data = p[grepl(input$year, p$year),],color = '#e67e22',weight = 10)
  })
})

# Run the application 
shinyApp(ui, server)

#Leaflet Providers/  http://leaflet-extras.github.io/leaflet-providers/preview/
#Stamen.TonerLite
#Esri.WorldGrayCanvas