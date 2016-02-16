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
restaurant$ GRADE<-factor(restaurant$ GRADE)
restaurant$INSPECTION.TYPE<-factor(restaurant$INSPECTION.TYPE)
restaurant$GRADE.DATE<-as.Date(restaurant$GRADE.DATE,format='%m/%d/%Y')
restaurant$RECORD.DATE<-as.Date(restaurant$RECORD.DATE,format='%m/%d/%Y')


summary(restaurant)
head(restaurant)

summary(restaurant$ACTION)

restaurant$DbaBoro<-paste0(restaurant$BUILDING,' ',restaurant$STREET,' ',restaurant$ZIPCODE)

uniqueDbaBoro<-unique(restaurant$DbaBoro)

system.time(longLat7_5<-data.frame(t(sapply(1:3000,function(i){
  cat(i,'\n')
  addr<-missingLocation[i]
  url = paste0('http://maps.google.com/maps/api/geocode/xml?address=',addr,'&sensor=false')
  #library(XML) 
  doc = xmlTreeParse(url) 
  root = xmlRoot(doc) 
  lat = xmlValue(root[['result']][['geometry']][['location']][['lat']]) 
  long = xmlValue(root[['result']][['geometry']][['location']][['lng']])
  return(c(addr,long,lat))
}))))

longLat.1<-rbind(longLat1,DbaBoroLongLat3)
longLat.2<-rbind(longLat.1,DbaBoroLongLat5)
longLat.3<-longLat.2[longLat.2[,1]%in%uniqueDbaBoro,]
longLat4<-rbind(longLat.3,longLat1)
longLat5<-rbind(longLat4,longLat7)
longLat6<-longLat5
longLat7<-rbind(longLat6,longLat6na)
longLat7_1<-rbind(longLat7,longLat7c)
longLat7_2<-rbind(longLat7_1,longLat7a)
longLat7_3<-longLat7_2[!is.na(longLat7_2[,2]),]
longLat7_4<-rbind(longLat7_3,longLat8)
longLat8<-rbind(longLat7_4,longLat7_5)
longLat9<-rbind(longLat8,longLat7g)

head(longLat7_5)

# load('C:/Users/ygu/Desktop/columbia/project2-group9/longLat7g.RData')
# longLat7_5<-longLat7_5[!is.na(longLat7_5[,2]),]

save(longLat9,file='C:/Users/ygu/Desktop/columbia/project2-group9/longLat9.RData')

missingLocation<-uniqueDbaBoro[!uniqueDbaBoro%in%longLat9[,1]]

save(missingLocation,file='C:/Users/ygu/Desktop/columbia/project2-group9/missingLocation.RData')





