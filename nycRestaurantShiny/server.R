options(shiny.maxRequestSize=50*1024^2)

shinyServer(function(input, output, session) {

    Data<-reactive({
      result<-list()
      result[[1]]<-uniqueRestau5[uniqueRestau5$Cuisine%in%input$cuisine&
                                   uniqueRestau5$businesses.review_count>=input$minReview&
                                   uniqueRestau5$businesses.rating>=input$minStar&
                                   uniqueRestau5$SafetyScore>=input$minSafetyScore,]
      if(!is.null(input$location)){
        url = paste0('http://maps.google.com/maps/api/geocode/xml?address=',input$location,'&sensor=false')
        doc = xmlTreeParse(url) 
        root = xmlRoot(doc) 
        lat = xmlValue(root[['result']][['geometry']][['location']][['lat']]) 
        long = xmlValue(root[['result']][['geometry']][['location']][['lng']])
        result[[2]]<-c(lat,long)
        subdata<-uniqueRestau5[uniqueRestau5$businesses.review_count>=input$minReview&
                                 uniqueRestau5$businesses.rating>=input$minStar&
                                 uniqueRestau5$SafetyScore>=input$minSafetyScore,]
        #browser()
        subdata2<-subdata[sqrt((subdata$longitude-as.numeric(long))^2+
                                 (subdata$latitude-as.numeric(lat))^2)*59.38<=input$distance,]
        result[[1]]<-subdata2[subdata2$Cuisine%in%input$cuisine,]
        result[[3]]<-subdata2
      }
      #browser()
      return(result)
    })
    
    yelpData<-reactive({
      if(is.null(input$Map_marker_click))
        return(NULL)
      else{
        data<-Data()[[1]]
        query<-gsub(' ','\\+',data$businesses.name[data$NameId==input$Map_marker_click$id])
        location<-gsub(' ','\\+',data$DbaBoro[data$NameId==input$Map_marker_click$id])
        url<-read_html(paste0("http://www.yelp.com/search?find_desc=",query,"&find_loc=",location))
        
        src=gsub('.*src=\\\"|\".*','',
                 as.character(html_nodes(url,xpath="//div[@data-key='1']//div[@class='photo-box pb-90s']")))
        price<-html_text(
          html_nodes(url,xpath="//div[@data-key='1']//span[@class='business-attribute price-range']"))
        return(list(src,price))
      }
    })
    
    output$pieChart <- renderChart2({
      data<-Data()[[3]]
      #browser()
      aggData<-aggregate(data$Cuisine,list(data$Cuisine),FUN=length)
      names(aggData)<-c('Cuisine','Count')
      aggData<-aggData[rev(order(aggData$Count)),]
      
      aggData2<-aggData[1:8,]
      aggData2$Cuisine[8]<-'Other'
      aggData2$Count[8]<-sum(aggData$Count[8:nrow(aggData)])
      aggData2$Perc<-round(aggData2$Count/sum(aggData2$Count),2)
      
      a<-Highcharts$new()
      a$data(x=aggData2$Cuisine,y=aggData2$Perc,type="pie",name='Accounts for')#name of cuisine
      a$set(dom='pieChart')
      #a$show("inline", include_assets = FALSE)
      return(a)
    })
    
    output$Map <- renderLeaflet({
      leaflet() %>% addProviderTiles("Stamen.TonerLite") %>% 
        setView(lng=Data()[[2]][2], lat=Data()[[2]][1], zoom=13) %>%
        addCircleMarkers(data=Data()[[1]],radius=~businesses.rating*2,fillColor=~pal(SafetyScore), 
                         stroke=FALSE, fillOpacity=0.5,layerId=~NameId)  %>% 
        addCircleMarkers(Data()[[2]][2],Data()[[2]][1],radius=10,color="blue",fillColor="orange",
                         fillOpacity=1,opacity=1,stroke=TRUE,layerId="Selected")
    })
    
    observeEvent(input$Map_marker_click, {
      #browser()
      p <- input$Map_marker_click
      if(!is.null(p$id)){
        if(is.null(input$nameId)) updateSelectInput(session, "nameId", selected=p$id)
        if(!is.null(input$nameId) && input$nameId!=p$id) updateSelectInput(session,"nameId",selected=p$id)
      }
    })
    
    output$clickedName<-renderText({
      #browser()
      if(is.null(input$Map_marker_click))
        return(NULL)
      else{
        data<-Data()[[1]]
        return(as.character(data$businesses.name[data$NameId==input$Map_marker_click$id]))
      }
    })
    
    output$image = renderUI({
      if(is.null(input$Map_marker_click))
        return(NULL)
      else{
        src<-yelpData()[[1]]
        return(tags$img(src=src))
      }
    })
    
    output$clickedNameAddress<-renderText({
      #browser()
      if(is.null(input$Map_marker_click))
        return(NULL)
      else{
        data<-Data()[[1]]
        return(paste0('Address: ',data$DbaBoro[data$NameId==input$Map_marker_click$id]))
      }
    })
    
    output$clickedNameGrade<-renderText({
      #browser()
      if(is.null(input$Map_marker_click))
        return(NULL)
      else{
        data<-Data()[[1]]
        return(paste0('Grade: ',as.character(data$GRADE[data$NameId==input$Map_marker_click$id])))
      }
    })
    
    output$clickedNameCritical<-renderText({
      #browser()
      if(is.null(input$Map_marker_click))
        return(NULL)
      else{
        data<-Data()[[1]]
        return(paste0(data$CriticalInspection[data$NameId==input$Map_marker_click$id],
                      ' critical(s) out of ',data$TotalInspection[data$NameId==input$Map_marker_click$id],
                      ' inspections'))
      }
    })
    
    output$clickedNameRating<-renderText({
      #browser()
      if(is.null(input$Map_marker_click))
        return(NULL)
      else{
        data<-Data()[[1]]
        return(paste0(data$businesses.rating[data$NameId==input$Map_marker_click$id],
                      ' stars out of 5 on Yelp'))
      }
    })
    
    output$clickedNameReviewCount<-renderText({
      #browser()
      if(is.null(input$Map_marker_click))
        return(NULL)
      else{
        data<-Data()[[1]]
        return(paste0(data$businesses.review_count[data$NameId==input$Map_marker_click$id],
                      ' reveiews on Yelp'))
      }
    })
    
    output$clickedNamePriceRange<-renderText({
      #browser()
      if(is.null(input$Map_marker_click))
        return(NULL)
      else{
        price<-yelpData()[[2]]
        return(paste0('Price range: ',price))
      }
    })
    
    output$clickedNamePhone<-renderText({
      #browser()
      if(is.null(input$Map_marker_click))
        return(NULL)
      else{
        data<-Data()[[1]]
        if(nchar(as.character(data$PHONE[data$NameId==input$Map_marker_click$id]))==10){
          phone<-data$PHONE[data$NameId==input$Map_marker_click$id]
          return(paste0('Phone #: (',substr(phone,1,3),')',substr(phone,4,6),'-',substr(phone,7,10)))
        }
        else
          return(paste0('Phone #: ',data$PHONE[data$NameId==input$Map_marker_click$id]))
      }
    })
#     
#     output$chart1<-renderChart2({
#       #browser()
#       data<-mtdRev()[[1]]
#       choro<-ichoropleth(MeanRank ~ State,legend=F,pal='YlOrRd',data=data)
#       choro$set(geographyConfig = list(
#         popupTemplate = "#! function(geography, data){
#             return '<div class=hoverinfo><strong>' + geography.properties.name + 
#             ': ' + data.MeanRank + ' out of 5 stars on average' + '</strong></div>';
#         } !#" 
#       ))
#     
#       choro
#     })
#     
#     
#     
#     output$bestOption<-renderInfoBox({
#       data<-mtdRev()[[1]]
#       #browser()
#       bestState<-as.character(data[rev(order(data$MeanRank)),'StateName'][1])
#       scrapDataBinded<-mtdRev()[[2]]
#       scrapDataBinded2<-scrapDataBinded[scrapDataBinded$stateName==bestState,]
#       bestattraction<-scrapDataBinded2[rev(order(scrapDataBinded2$ranking)),]
#       bestattraction2<-bestattraction[rev(order(bestattraction$reviewNum)),][1,]
#       return(infoBox(
#         paste0('Best State is'),
#         bestState,
#         paste0('Famous attraction: ',bestattraction2$title,' (',bestattraction2$ranking,
#                ' stars out of 5 ; ',bestattraction2$reviewNum,' reviews on tripadvisor.com)'),
#         icon=icon("trophy"),color="yellow"
#       ))
#     })

  })