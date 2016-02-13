dbHeader<-dashboardHeader(title='NYC Restaurants')

dashboardPage(

    skin="green",
  
  dbHeader,

  dashboardSidebar(
#     selectInput("live","Live or Offline:",c('Live','Offline'),'Offline'),
#     conditionalPanel("input.live === 'Offline'",
#                      selectInput("wselect","Word Input:",names(tripdata),'')),
#     conditionalPanel("input.live === 'Live'",
#                      textInput("winput","Word Input:",textcontract('mountain')))
#     textInput("id2","Model:",textcontract('random forest')),
#     dateRangeInput('MonthTDateRange',label='Traveling Time:',
#                    start=as.Date('2016-02-07'),end=as.Date('2016-02-17')),
#     sliderInput("slider2", "Budget ($)",
#                 min = 100, max = 5000, value = c(100, 1000))
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