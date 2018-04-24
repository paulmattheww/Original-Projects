# Geocode tool
# server.R

# server.R
require(shiny)
require(shinydashboard)
# library(ggplot2)
require(ggmap)
require(leaflet)
require(shinyapps)

# x = geocode('Major brands 6701 Southwest Ave st. louis MO 63143 USA')
# runApp('C:/Users/pmwash/Desktop/R_files/Applications/Geocode-Customer-Setup', launch.browser=TRUE)
# setwd('C:/Users/pmwash/Desktop/R_files/Applications/Geocode-Customer-Setup')
# deployApp()


shinyServer(
  function(input, output) {
    
    address_input = reactive({
      paste0(as.character(input$customer), ' ', 
             as.character(input$address), ' ', 
             as.character(input$city), ' ',
             as.character(input$state), ' ',
             as.character(input$zip), ' ',
             as.character(input$country))
    })
    
    geo_code = reactive({
      g = geocode(address_input())
    })
    
    output$text_out = renderText({
      paste0(as.character(input$customer), ' Latitude is ', geo_code()[1, 2], ' and Longitude is  ', geo_code()[1, 1])
    })
    
    output$map_out = renderLeaflet({
      x = geo_code()
      
      the_map = leaflet(x) %>% 
        addTiles() %>% 
        addMarkers(data=x,
                   popup=as.character(address_input())) %>%
        addCircles(radius=400)
      
      the_map
    })
    
  })


















