# Geo code tool for Customer Setup

# ui.R


require(shiny)
require(leaflet)
require(ggmap)

shinyUI(fluidPage(
  titlePanel(HTML("<center><h1><b>Geocode Generator</b></center></h1>
                  <center><h3>Input the precise address of your desired location to get latitude & longitude information</h3></center><br/>"), 'Geocode Generator'),
  
  
  
  sidebarLayout(
    sidebarPanel(height=800,
                 h3('Input Address Information:'),
                 submitButton("Update View"),
                 br(),
                 textInput(inputId='customer', 
                           label='Name of Location',
                           value='Major Brands'),
                 
                 textInput(inputId='address', 
                           label='Street Address',
                           value='6701 Southwest Ave'),
                 
                 textInput(inputId='city', 
                           label='City',
                           value='Saint Louis'),
                 
                 textInput(inputId='state', 
                           label='State (Abbreviated)',
                           value='MO'),
                 
                 textInput(inputId='zip', 
                           label='Zip Code',
                           value='63143'),
                 
                 textInput(inputId='country', 
                           label='Country',
                           value='USA')),
    mainPanel(
      textOutput(outputId='text_out'),
      
      ## Interactive Map ###########################################
      
      leafletOutput('map_out',
                    width='100%', height=800)))
  
  
  
  ))





















