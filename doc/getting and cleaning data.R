library(data.table)
restaurant<-
  data.frame(fread('C:/Users/ygu/Downloads/DOHMH_New_York_City_Restaurant_Inspection_Results.csv'))
restaurant$DBA<-factor(restaurant$DBA)
restaurant$BORO<-factor(restaurant$BORO)
restaurant$BUILDING<-factor(restaurant$BUILDING)
restaurant$STREET<-factor(restaurant$STREET)
restaurant$ZIPCODE<-factor(restaurant$ZIPCODE)
restaurant$PHONE<-factor(restaurant$PHONE)
restaurant$CUISINE.DESCRIPTION<-factor(restaurant$CUISINE.DESCRIPTION)
restaurant$INSPECTION.DATE<-as.Date(restaurant$INSPECTION.DATE,format='%m/%d/%Y')
restaurant$ACTION<-factor(restaurant$ACTION)
restaurant$VIOLATION.CODE<-factor(restaurant$VIOLATION.CODE)
restaurant$VIOLATION.DESCRIPTION<-factor(restaurant$VIOLATION.DESCRIPTION)
restaurant$CRITICAL.FLAG<-factor(restaurant$CRITICAL.FLAG)
restaurant$GRADE<-factor(restaurant$ GRADE)
restaurant$INSPECTION.TYPE<-factor(restaurant$INSPECTION.TYPE)
restaurant$GRADE.DATE<-as.Date(restaurant$GRADE.DATE,format='%m/%d/%Y')
restaurant$RECORD.DATE<-as.Date(restaurant$RECORD.DATE,format='%m/%d/%Y')
restaurant$CAMIS<-factor(restaurant$CAMIS)
restaurant$DbaBoro<-paste0(restaurant$BUILDING,' ',restaurant$STREET,' ',restaurant$ZIPCODE)

restaurant<-restaurant[rev(order(restaurant$INSPECTION.DATE)),]

latestInspection<-restaurant[!duplicated(restaurant$CAMIS),]
closedRestaurants<-latestInspection$CAMIS[grepl('close',tolower(latestInspection$ACTION))]

# remove all closed restaurants
restaurant2<-restaurant[!restaurant$CAMIS%in%closedRestaurants,]


# save(restaurant2,file='C:/Users/ygu/Desktop/columbia/project2-group9/restaurant2.RData')

summary(restaurant2)

# get newest inspection data
uniqueRestau<-restaurant2[!duplicated(restaurant2$CAMIS),]
uniqueRestau2<-merge(uniqueRestau,longLat,by='DbaBoro',all.x=T)
uniqueRestau2$longitude<-as.numeric(uniqueRestau2$longitude)
uniqueRestau2$latitude<-as.numeric(uniqueRestau2$latitude)
uniqueRestau3<-uniqueRestau2[uniqueRestau2$latitude>=40.477399&uniqueRestau2$latitude<=40.917577&
                               uniqueRestau2$longitude>=-74.25909&uniqueRestau2$longitude<=-73.700009,]
uniqueRestau4<-uniqueRestau3[uniqueRestau3$INSPECTION.DATE>=as.Date('2015-01-01'),]

# create cuisine
uniqueRestau4$Cuisine<-as.character(uniqueRestau4$CUISINE.DESCRIPTION)
uniqueRestau4$Cuisine[uniqueRestau4$CUISINE.DESCRIPTION%in%
                        c('Afghan','Armenian','Iranian','Pakistani','Turkish')]<-'Middle Eastern'
uniqueRestau4$Cuisine[uniqueRestau4$CUISINE.DESCRIPTION%in%c('African','Egyptian')]<-'African'
uniqueRestau4$Cuisine[uniqueRestau4$CUISINE.DESCRIPTION%in%c('Bagels/Pretzels','Pancakes/Waffles')]<-'Bakery'
uniqueRestau4$Cuisine[uniqueRestau4$CUISINE.DESCRIPTION%in%
                        c('Bangladeshi','Filipino','Indonesian','Vietnamese/Cambodian/Malaysia')]<-
  'South East Asia'
uniqueRestau4$Cuisine[uniqueRestau4$CUISINE.DESCRIPTION%in%
                        c('Bottled beverages, including water, sodas, juices, etc.',
                          'Juice, Smoothies, Fruit Salads')]<-'Juice'
uniqueRestau4$Cuisine[uniqueRestau4$CUISINE.DESCRIPTION%in%
                        c('Brazilian','Chilean','Peruvian',
                          'Latin (Cuban, Dominican, Puerto Rican, South & Central American)')]<-'Latin'
uniqueRestau4$Cuisine[grepl('coffee',tolower(uniqueRestau4$CUISINE.DESCRIPTION))]<-'Coffee/Tea'
uniqueRestau4$Cuisine[uniqueRestau4$CUISINE.DESCRIPTION%in%c('Cajun','Creole','Creole/Cajun')]<-'French'
uniqueRestau4$Cuisine[uniqueRestau4$CUISINE.DESCRIPTION%in%
                        c('Californian','Hawaiian','Hotdogs','Hotdogs/Pretzels','Southwestern','Steak',
                          'Barbecue')]<-'American'
uniqueRestau4$Cuisine[grepl('chinese',tolower(uniqueRestau4$CUISINE.DESCRIPTION))]<-'Chinese'
uniqueRestau4$Cuisine[uniqueRestau4$CUISINE.DESCRIPTION%in%
                        c('Continental','Eastern European','Czech','English','German','Polish','Portuguese',
                          'Russian','Scandinavian')]<-'European'
uniqueRestau4$Cuisine[uniqueRestau4$CUISINE.DESCRIPTION%in%
                        c('African','Ethiopian','Egyptian','Moroccan')]<-'African'
uniqueRestau4$Cuisine[uniqueRestau4$CUISINE.DESCRIPTION%in%c('Fruits/Vegetables','Salads')]<-'Vegetarian'
uniqueRestau4$Cuisine[uniqueRestau4$CUISINE.DESCRIPTION%in%
                        c('Not Listed/Not Applicable','Nuts/Confectionary','Soul Food',
                          'Polynesian','Hawaiian','Australian')]<-'Other'
uniqueRestau4$Cuisine[uniqueRestau4$CUISINE.DESCRIPTION%in%c('Pizza/Italian')]<-'Pizza'
uniqueRestau4$Cuisine[uniqueRestau4$CUISINE.DESCRIPTION%in%
                        c('Sandwiches/Salads/Mixed Buffet','Soups','Sandwiches')]<-'Soups & Sandwiches'
uniqueRestau4$Cuisine[uniqueRestau4$CUISINE.DESCRIPTION%in%c('Tapas')]<-'Spanish'
uniqueRestau4$Cuisine[uniqueRestau4$CUISINE.DESCRIPTION%in%c('Tex-Mex')]<-'Mexican'
uniqueRestau4$Cuisine[uniqueRestau4$CUISINE.DESCRIPTION%in%c('Delicatessen')]<-'Deli'
uniqueRestau4$Cuisine[uniqueRestau4$CUISINE.DESCRIPTION%in%c('Ice Cream, Gelato, Yogurt, Ices')]<-'Ice Cream'
uniqueRestau4$Cuisine<-factor(uniqueRestau4$Cuisine)

summary(uniqueRestau4$Cuisine)

save(uniqueRestau4,
     file='C:/Users/ygu/Desktop/columbia/project2-group9/nycRestaurantShiny/www/uniqueRestau4.RData')


# getting longitude and latitude
# uniqueDbaBoro<-unique(restaurant$DbaBoro)
# 
# system.time(longLat11s<-data.frame(t(sapply(1:length(missingLocation),function(i){
#   cat(i,'\n')
#   addr<-missingLocation[i]
#   url = paste0('http://maps.google.com/maps/api/geocode/xml?address=',addr,'&sensor=false')
#   #library(XML) 
#   doc = xmlTreeParse(url) 
#   root = xmlRoot(doc) 
#   lat = xmlValue(root[['result']][['geometry']][['location']][['lat']]) 
#   long = xmlValue(root[['result']][['geometry']][['location']][['lng']])
#   return(c(addr,long,lat))
# }))))
# 
# longLat.1<-rbind(longLat1,DbaBoroLongLat3)
# longLat.2<-rbind(longLat.1,DbaBoroLongLat5)
# longLat.3<-longLat.2[longLat.2[,1]%in%uniqueDbaBoro,]
# longLat4<-rbind(longLat.3,longLat1)
# longLat5<-rbind(longLat4,longLat7)
# longLat6<-longLat5
# longLat7<-rbind(longLat6,longLat6na)
# longLat7_1<-rbind(longLat7,longLat7c)
# longLat7_2<-rbind(longLat7_1,longLat7a)
# longLat7_3<-longLat7_2[!is.na(longLat7_2[,2]),]
# longLat7_4<-rbind(longLat7_3,longLat8)
# longLat8<-rbind(longLat7_4,longLat7_5)
# longLat9<-rbind(longLat8,longLat7g)
# longLat11<-rbind(longLat9,longLat10)
# longLat11b<-rbind(longLat11,longLat11a)
# longLat11d<-rbind(longLat11b,longLat11c)
# longLat11f<-rbind(longLat11d,longLat11e)
# longLat11h<-rbind(longLat11f,longLat11g)
# longLat11j<-rbind(longLat11h,longLat11i)
# longLat11l<-rbind(longLat11j,longLat11k)
# longLat11n<-rbind(longLat11l,longLat11m)
# longLat11p<-rbind(longLat11n,longLat11o)
# longLat11r<-rbind(longLat11p,longLat11q)
# longLat<-rbind(longLat11r,longLat11s)
# 
# head(longLat7_5)
# 
# # load('C:/Users/ygu/Desktop/columbia/project2-group9/longLat10_2.RData')
# # longLat11q<-longLat11q[!is.na(longLat11q[,2]),]
# 
# save(longLat,file='C:/Users/ygu/Desktop/columbia/project2-group9/longLat.RData')
# 
# # missingLocation<-uniqueDbaBoro[!uniqueDbaBoro%in%longLat11r[,1]]
# 
# # save(missingLocation,file='C:/Users/ygu/Desktop/columbia/project2-group9/missingLocation.RData')

#browser()
# require(httr)
# require(httpuv)
# require(jsonlite)
# require(base64enc)
# 
# 
# yelp_query <- function(path, query_args) {
#   # Use OAuth to authorize your request.
#   myapp <- oauth_app("YELP", key=consumerKey, secret=consumerSecret)
#   sig <- sign_oauth1.0(myapp, token=token, token_secret=token_secret)
#   
#   # Build Yelp API URL.
#   scheme <- "https"
#   host <- "api.yelp.com"
#   yelpurl <- paste0(scheme, "://", host, path)
#   
#   # Make request.
#   results <- GET(yelpurl, sig, query=query_args)
#   
#   # If status is not success, print some debugging output.
#   HTTP_SUCCESS <- 200
#   if (results$status != HTTP_SUCCESS) {
#     print(results)
#   }
#   return(results)
# }
# 
# yelp_search <- function(term, location, limit=10) {
#   # Search term and location go in the query string.
#   path <- "/v2/search/"
#   #browser()
#   query_args <- list(term=term, location=location, limit=limit)
#   # Make request.
#   results <- yelp_query(path, query_args)
#   locationdataContent = content(results)
#   #browser()
#   if(length(jsonlite::fromJSON(toJSON(locationdataContent))$business)<3)
#     return(rep(NA,7))
#   else{
#     info=data.frame(jsonlite::fromJSON(toJSON(locationdataContent)))
#     
#     if(names(locationdataContent)=='error')
#       return(rep(NA,7))
#     else
#       return(info[c(7,10,11,19,17,3,4)])
#   }
# }
# 
# system.time(yelpData5<-data.frame(t(sapply(4001:10000,function(i){
#   cat(i,'\n')
#   return(yelp_search(uniqueRestau4$DBA[i],uniqueRestau4$DbaBoro[i],1))
# }))))
# yelpData1
# yelpData2
# yelpData3
# yelpData4
# yelpData5
# yelpDataComb1<-rbind(yelpData1,yelpData2)
# yelpDataComb2<-rbind(yelpDataComb1,yelpData3)
# yelpDataComb3<-rbind(yelpDataComb2,yelpData4)
# yelpDataComb4<-rbind(yelpDataComb3,yelpData5)
# yelpDataComb5<-rbind(yelpDataComb4,yelpData10)
# yelpDataComb6<-rbind(yelpDataComb5,yelpData20)
# yelpDataComb7<-rbind(yelpDataComb6,yelpData30)
# yelpDataComb8<-rbind(yelpDataComb7,yelpData100)
# yelpDataComb9<-rbind(yelpDataComb8,yelpData200)
# yelpDataComb10<-rbind(yelpDataComb9,yelpData300)
# yelpDataComb11<-rbind(yelpDataComb10,yelpData400)
# yelpDataComb12<-rbind(yelpDataComb11,yelpData2000)
# yelpDataComb13<-rbind(yelpDataComb12,yelpData900)
# yelpDataComb14<-rbind(yelpDataComb13,yelpData4000)

yelpDataCombFinal<-yelpDataComb14[,c(1:3,6,7)]
yelpDataCombFinal$businesses.rating<-as.numeric(unlist(yelpDataCombFinal$businesses.rating))
yelpDataCombFinal$businesses.review_count<-as.numeric(unlist(yelpDataCombFinal$businesses.review_count))
yelpDataCombFinal$businesses.name<-factor(unlist(yelpDataCombFinal$businesses.name))
yelpDataCombFinal$region.center.latitude<-unlist(yelpDataCombFinal$region.center.latitude)
yelpDataCombFinal$region.center.longitude<-unlist(yelpDataCombFinal$region.center.longitude)
yelpDataCombFinal2<-cbind(yelpDataCombFinal,uniqueRestau4)
uniqueRestau5<-yelpDataCombFinal2[!is.na(yelpDataCombFinal2$businesses.rating),]
uniqueRestau5<-uniqueRestau5[uniqueRestau5$region.center.latitude>=40.477399&
                               uniqueRestau5$region.center.latitude<=40.917577&
                               uniqueRestau5$region.center.longitude>=-74.25909&
                               uniqueRestau5$region.center.longitude<=-73.700009,]
uniqueRestau5$GRADE<-as.character(uniqueRestau5$GRADE)
uniqueRestau5$GRADE[uniqueRestau5$GRADE%in%c('Not Yet Graded','','Z')]<-'No Grade'
uniqueRestau5$GRADE<-factor(uniqueRestau5$GRADE)
uniqueRestau5<-merge(uniqueRestau5,inspectionScore,all.x=T,by='CAMIS')

colors11<-heat.colors(4, alpha = 1)
uniqueRestau5$SafetyScoreColor<-factor(colors10[round(uniqueRestau5$SafetyScore/3*10,0)+1])
uniqueRestau5$NameId<-paste0(uniqueRestau5$businesses.name,' ',uniqueRestau5$CAMIS)
# load('C:/Users/ygu/Desktop/columbia/project2-group9/yelpData4000.RData')
# names(yelpData4000)<-names(yelpData1)

#save(yelpDataCombFinal,file='C:/Users/ygu/Desktop/columbia/project2-group9/yelpDataCombFinal.RData')
save(uniqueRestau5,
     file='C:/Users/ygu/Desktop/columbia/project2-group9/nycRestaurantShiny/www/uniqueRestau5.RData')


restaurant3<-restaurant2[restaurant2$CAMIS%in%uniqueRestau5$CAMIS,]
restaurant3$UncleanSurfaces<-0
restaurant3$UncleanSurfaces[grepl('\\-food contact surface',tolower(restaurant3$VIOLATION.DESCRIPTION))]<-1
restaurant3$Vermin<-0
restaurant3$Vermin[grepl('vermin|mice',tolower(restaurant3$VIOLATION.DESCRIPTION))]<-1
restaurant3$UncleanFoodContactSurfaces<-0
restaurant3$UncleanFoodContactSurfaces[
  grepl('^food contact surface',tolower(restaurant3$VIOLATION.DESCRIPTION))]<-1

head(summary(restaurant3$VIOLATION.DESCRIPTION))
levels(factor(restaurant3$VIOLATION.DESCRIPTION[
  grepl('^food contact surface',tolower(restaurant3$VIOLATION.DESCRIPTION))]))
save(restaurant3,file='C:/Users/ygu/Desktop/columbia/project2-group9/restaurant3.RData')


totalInspection<-aggregate(restaurant3$CAMIS,list(restaurant3$CAMIS),FUN=length)
names(totalInspection)<-c('CAMIS','TotalInspection')
restaurant3Crit<-restaurant3[restaurant3$CRITICAL.FLAG=='Critical',]
criticalInspection<-aggregate(restaurant3Crit$CAMIS,list(restaurant3Crit$CAMIS),FUN=length)
names(criticalInspection)<-c('CAMIS','CriticalInspection')
inspectionScore<-merge(totalInspection,criticalInspection,by='CAMIS',all.x=T)
inspectionScore[is.na(inspectionScore)]<-0
inspectionScore$SafetyScore<-1-inspectionScore$CriticalInspection/inspectionScore$TotalInspection









library(rvest)
query<-gsub(' ','\\+','POLLOS MARIO RESTAURANT AND SPORTS BAR')
location<-gsub(' ','\\+','37TH AVE 11372')
url<-read_html(paste0("http://www.yelp.com/search?find_desc=",query,"&find_loc=",location))

#html_text(html_nodes(url,xpath="//div[@data-key='1']//a[@class='biz-name']"))
gsub('.*src=\\\"|\".*','',
     as.character(html_nodes(url,xpath="//div[@data-key='1']//div[@class='photo-box pb-90s']")))
html_text(html_nodes(url,xpath="//div[@data-key='1']//span[@class='business-attribute price-range']"))













