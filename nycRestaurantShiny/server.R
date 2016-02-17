options(shiny.maxRequestSize=50*1024^2)

shinyServer(function(input, output, session) {

  output$Map <- renderLeaflet({
    leaflet() %>% addProviderTiles("Stamen.TonerLite") %>% setView(lng=-73.99, lat=40.73, zoom=13) %>%
      addCircleMarkers(data=uniqueRestau4, radius = ~5, color = 'red', 
                       stroke=FALSE, fillOpacity=0.5)#, layerId = ~location)
    
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
  })
  
  
#     mtdRev<-reactive({
#       #browser()
#       if(input$live=='Live'){
#         query<-strsplit(textcontract(input$winput),' ')
#         
#         scrapData<-lapply(1:50,function(i){  
#           #browser()
#           #trip<-read_html(paste0("http://www.tripadvisor.com/Search?q=sunny&geo=191#&ssrc=A&o=",i*30))
#           trip<-read_html(paste0("http://www.tripadvisor.com/Search?q=",query,"&geo=",state$stateCode[i]))
#           
#           a<-html_text(html_nodes(trip,xpath="//div[@class='result ATTRACTIONS']/div[@class='info poi-info']"))
#           includeID<-!grepl('the first to review',a)
#           
#           scrapDataTmp<-data.frame(
#             title=
#               html_text(
#                 html_nodes(trip,xpath="//div[@class='result ATTRACTIONS']//div[@class='title']"))[includeID],
#             address=
#               html_text(
#                 html_nodes(trip,xpath="//div[@class='result ATTRACTIONS']//div[@class='address']"))[includeID],
#             stateName=rep(state$StateName[i],sum(includeID)),
#             ranking=as.numeric(
#               gsub(' .*','',
#                    html_attr(
#                      html_nodes(
#                        trip,xpath="//div[@class='result ATTRACTIONS']//img[@class='sprite-ratings']"),'alt'))),
#             reviewNum=
#               as.numeric(
#                 gsub(',| .*','',
#                      html_text(html_nodes(
#                        trip,xpath="//div[@class='result ATTRACTIONS']//a[@class='review-count']"))))
#           )
#           
#           scrapDataTmp$rankReview=round(scrapDataTmp$ranking*scrapDataTmp$reviewNum,0)
#           return(scrapDataTmp)
#         })
#         scrapDataBinded<-rbind.fill(scrapData)
#       }else
#         scrapDataBinded<-tripdata[[input$wselect]]
# 
#       aggScrapData<-aggregate(scrapDataBinded$rankReview,list(scrapDataBinded$stateName),FUN=sum)
#       names(aggScrapData)<-c('StateName','rankReview')
#       
#       aggScrapData2<-aggregate(scrapDataBinded$reviewNum,list(scrapDataBinded$stateName),FUN=sum)
#       names(aggScrapData2)<-c('StateName','reviewNum')
#       
#       aggScrapData3<-merge(aggScrapData,aggScrapData2,by='StateName',all.x=T)
#       aggScrapData3$MeanRank<-round(aggScrapData3$rankReview/aggScrapData3$reviewNum,3)
#       
#       data<-merge(aggScrapData3,state,by='StateName',all.y=T)
#       data[is.na(data)]<-0
#       data$MeanRank<-jitter(data$MeanRank+0.1)/5.1*5
#       data$rankReview<-data$rankReview+1
#       data$reviewNum<-data$reviewNum+1
#       return(list(data,scrapDataBinded))
#     })
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