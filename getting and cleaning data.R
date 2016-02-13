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

system.time(DbaBoroLongLat<-data.frame(t(sapply(1:length(uniqueDbaBoro),function(i){
  cat(i,'\n')
  addr<-uniqueDbaBoro[i]
  url = paste0('http://maps.google.com/maps/api/geocode/xml?address=',addr,'&sensor=false')
  #library(XML) 
  doc = xmlTreeParse(url) 
  root = xmlRoot(doc) 
  lat = xmlValue(root[['result']][['geometry']][['location']][['lat']]) 
  long = xmlValue(root[['result']][['geometry']][['location']][['lng']])
  return(c(addr,long,lat))
}))))

DbaBoroLongLat2<-DbaBoroLongLat

DbaBoroLongLat[,1]<-factor(DbaBoroLongLat[,1])
DbaBoroLongLat[,2]<-as.numeric(DbaBoroLongLat[,2])
DbaBoroLongLat[,3]<-as.numeric(DbaBoroLongLat[,3])
summary(DbaBoroLongLat)

