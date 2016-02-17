dbHeader<-dashboardHeader(title='NYC Restaurants')

dashboardPage(

    skin="green",
  
  dbHeader,

  dashboardSidebar(
    textInput("location","Your location:",'Columbia University NY, NYC'),
    sliderInput("distance","Max dist from your location (mi)",
                min = 1, max = 21, value = 1),
    selectInput("cuisine","Cuisine:",levels(uniqueRestau4$Cuisine),'Ice Cream',multiple=T),
    submitButton("Submit")
#     conditionalPanel("input.live === 'Offline'",
#                      selectInput("wselect","Word Input:",names(tripdata),'')),
#     conditionalPanel("input.live === 'Live'",
#                      textInput("winput","Word Input:",textcontract('mountain')))
#     
#     dateRangeInput('MonthTDateRange',label='Traveling Time:',
#                    start=as.Date('2016-02-07'),end=as.Date('2016-02-17')),
    ),
              
  dashboardBody(
    
    
    fluidRow(
#       column(width=12,
#              infoBoxOutput('bestOption')
#       )),
    #column(width=2,img(src="wordcloud.png", height = 200, width = 300))),
      leafletOutput("Map")
    )
  )
)