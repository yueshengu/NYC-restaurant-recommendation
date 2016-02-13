library(data.table)
restaurant<-
  data.frame(fread('/Users/yueyingteng/Downloads/restaurant/DOHMH_New_York_City_Restaurant_Inspection_Results.csv'))

restaurant$DbaBoro<-paste0(restaurant$BUILDING,' ',restaurant$STREET,' ',restaurant$ZIPCODE)

uniqueDbaBoro<-unique(restaurant$DbaBoro)

system.time(DbaBoroLongLat<-t(sapply(1:length(uniqueDbaBoro),function(i){
  cat(i,'\n')
  addr<-uniqueDbaBoro[i]
  url = paste0('http://maps.google.com/maps/api/geocode/xml?address=',addr,'&sensor=false')
  #library(XML) 
  doc = xmlTreeParse(url) 
  root = xmlRoot(doc) 
  lat = xmlValue(root[['result']][['geometry']][['location']][['lat']]) 
  long = xmlValue(root[['result']][['geometry']][['location']][['lng']])
  return(c(addr,long,lat))
})))

head(DbaBoroLongLat)
DbaBoroLongLat2<-DbaBoroLongLat

longLat1<-DbaBoroLongLat2[!is.na(DbaBoroLongLat[,2]),]
tail(longLat1)
nrow(longLat1)
DbaBoroLongLat2NA<-DbaBoroLongLat2[is.na(DbaBoroLongLat[,2]),1]

save(longLat1,file='/Users/yueyingteng/Desktop/longLat1.RData')
save(DbaBoroLongLat2NA,file='/Users/yueyingteng/Desktop/DbaBoroLongLat2NA.RData')
