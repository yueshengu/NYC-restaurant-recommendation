
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(ggplot2)
library(shiny)
library(DT)


#UI part
shinyUI(
  fluidPage(
    titlePanel("Find Your Restaurant!"),
    
    # Create new Rows in the UI
    fluidRow(
      column(4,
             selectInput("zip",
                         "Zipcode:",
                         c("All",
                           unique(as.character(restaurant2$Zipcode))))
      ),
      column(4,
             selectInput("boro",
                         "Borough:",
                         c("All",
                           unique(as.character(restaurant2$Borough))))
      ),
      column(4,
             selectInput("des",
                         "Description:",
                         c("All",
                           unique(as.character(restaurant2$Description))))
      )
    ),
    fluidRow(
      DT::dataTableOutput("table")
    )
  )
)

