dbHeader<-dashboardHeader(title='NYC Restaurants')

dashboardPage(

    skin="green",
  
  dbHeader,

  dashboardSidebar(
    sidebarMenu(id='sidebarmenu',
                menuItem("Cuisine Overview",tabName="overview",icon=icon("pie-chart")),
                menuItem("Restaurant Locator",tabName="locator",icon=icon("beer"))
    ),
    
    textInput("location","Your location:",'Columbia University NY, NYC'),
    sliderInput("distance","Max dist from your location (mi)",
                min = 1, max = 21, value = 1),
    
    selectInput("cuisine","Cuisine:",levels(uniqueRestau5$Cuisine),'Ice Cream',multiple=T),
    sliderInput("minReview","Minimum # of reviews on Yelp",min = 1, max = 100, value = 1),
    sliderInput("minStar","Minimum # of stars on Yelp",min = 1, max = 5, value = 1),
    sliderInput("minSafetyScore","Minimum safety score",min = 0, max = 1, value = 0),
    submitButton("Submit",width='100%')
   
    
    ),
              
  dashboardBody(
    includeCSS('./www/custom.css'),
    tabItems(
      
      tabItem(tabName = "overview",
              fluidRow(
                column(width=12,
                       box(width=NULL,
                           title=tagList(shiny::icon("pie-chart"),"Cuisine distribution at your location"),
                           status='primary',
                           collapsible=T,
                           showOutput("pieChart","Highcharts")
                       )))),
      
      tabItem(tabName='locator',
              fluidRow(
                column(width = 7,
                       box(width = NULL, solidHeader = TRUE,
                           leafletOutput("Map"))),
                column(width=5,
                       box(title = "Selected Restaurant", status = "primary",
                           width=NULL,solidHeader=T,
                           textOutput("clickedName"),
                           br(),
                           uiOutput('image'),
                           br(),
                           textOutput("clickedNameAddress"),
                           textOutput("clickedNameGrade"),
                           textOutput("clickedNameCritical"),
                           textOutput("clickedNameRating"),
                           textOutput("clickedNameReviewCount"),
                           #textOutput("clickedNamePriceRange"),
                           textOutput("clickedNamePhone")))),
              fluidRow(column(width=5,
                              selectInput("nameId","Restaurant Id",c("",sort(uniqueRestau5$NameId)),
                                          selected="",multiple=F,width="100%")))
              )
      )
    #,
#     fluidRow(column(width=12,tabBox(title="Histogram", 
#                                     id = "tabset1", height = "250px",
#                                     tabPanel("Tab1", "First tab content",verbatimTextOutput("clickedName"))
#     )))

  )
)

#       column(width=12,
#              infoBoxOutput('bestOption')
#       )),
    #column(width=2,img(src="wordcloud.png", height = 200, width = 300))),
