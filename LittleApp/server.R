
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(ggplot2)
library(shiny)
library(DT)

shinyServer(function(input, output) {
  
  # Filter data based on selections
  output$table <- DT::renderDataTable(DT::datatable({
    data <- restaurant2
    if (input$zip != "All") {
      data <- data[data$Zipcode == input$zip,]
    }
    if (input$boro != "All") {
      data <- data[data$Borough == input$boro,]
    }
    if (input$des != "All") {
      data <- data[data$Description == input$des,]
    }
    data
  }))
  
})

