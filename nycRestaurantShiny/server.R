options(shiny.maxRequestSize=50*1024^2)

shinyServer(function(input, output, session) {

  
    
#     L1 <- leaflet()
#     L1$tileLayer(provider = 'Stamen.TonerLite')
#     L1$set(height = 800, width = 1600)
#     L1$setView(c(40.73, -73.99), 14)
#     L1$geoJson(toGeoJSON(bike2), 
#                onEachFeature = '#! function(feature, layer){
#            layer.bindPopup(feature.properties.popup)
#            } !#',
#                pointToLayer =  "#! function(feature, latlng){
#            return L.circleMarker(latlng, {
#            radius: 4,
#            fillColor: feature.properties.fillColor || 'red',    
#            color: '#000',
#            weight: 1,
#            fillOpacity: 0.8
#            })
#            } !#"
#     )
#     L1
  
  
  
    Data<-reactive({
      result<-list()
      result[[1]]<-uniqueRestau4[uniqueRestau4$Cuisine%in%input$cuisine,]
      if(!is.null(input$location)){
        url = paste0('http://maps.google.com/maps/api/geocode/xml?address=',input$location,'&sensor=false')
        doc = xmlTreeParse(url) 
        root = xmlRoot(doc) 
        lat = xmlValue(root[['result']][['geometry']][['location']][['lat']]) 
        long = xmlValue(root[['result']][['geometry']][['location']][['lng']])
        result[[2]]<-c(lat,long)
        subdata<-uniqueRestau4[uniqueRestau4$Cuisine%in%input$cuisine,]
        #browser()
        subdata2<-subdata[sqrt((subdata$longitude-as.numeric(long))^2+
                                 (subdata$latitude-as.numeric(lat))^2)*59.38<=input$distance,]
        result[[1]]<-subdata2
      }
        
      #browser()
      return(result)
    })
    
#     output$Map <- renderLeaflet({
#       leaflet() %>% addProviderTiles("Stamen.TonerLite") %>% setView(lng=-73.99, lat=40.73, zoom=13) %>%
#         addCircleMarkers(data=Data()[[1]], radius = ~5, color = 'red', 
#                          stroke=FALSE, fillOpacity=0.5)#, layerId = "restaurant")
#     })
#     
#     observeEvent(input$location, {
#       
#       leafletProxy("Map") %>% removeMarker(layerId="Selected")
#       leafletProxy("Map") %>% setView(lng=Data()[[2]][2], lat=Data()[[2]][1], zoom=13) %>% 
#         addCircleMarkers(Data()[[2]][2],Data()[[2]][1],radius=10,color="blue",fillColor="orange",
#                          fillOpacity=1,opacity=1,stroke=TRUE,layerId="Selected")
#     })
    
    
    output$Map <- renderLeaflet({
      leaflet() %>% addProviderTiles("Stamen.TonerLite") %>% 
        setView(lng=Data()[[2]][2], lat=Data()[[2]][1], zoom=13) %>%
        addCircleMarkers(data=Data()[[1]], radius = ~5, color = 'red', 
                         stroke=FALSE, fillOpacity=0.5)  %>% 
        addCircleMarkers(Data()[[2]][2],Data()[[2]][1],radius=10,color="blue",fillColor="orange",
                         fillOpacity=1,opacity=1,stroke=TRUE,layerId="Selected")
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