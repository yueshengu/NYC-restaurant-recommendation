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
  addr<-DbaBoroLongLat2NA[i]
  url = paste0('http://maps.google.com/maps/api/geocode/xml?address=',addr,'&sensor=false')
  #library(XML) 
  doc = xmlTreeParse(url) 
  root = xmlRoot(doc) 
  lat = xmlValue(root[['result']][['geometry']][['location']][['lat']]) 
  long = xmlValue(root[['result']][['geometry']][['location']][['lng']])
  return(c(addr,long,lat))
}))))

DbaBoroLongLat3<-DbaBoroLongLat2

DbaBoroLongLat3NA<-DbaBoroLongLat3[is.na(DbaBoroLongLat2[,2]),1]
DbaBoroLongLat3<-DbaBoroLongLat2[!is.na(DbaBoroLongLat2[,2]),]

save(DbaBoroLongLat3,file='C:/Users/Eric/Desktop/project2-group9/DbaBoroLongLat3.RData')
save(DbaBoroLongLat3NA,file='C:/Users/Eric/Desktop/project2-group9/DbaBoroLongLat3NA.RData')


head(DbaBoroLongLat3)

length(DbaBoroLongLat3NA)

DbaBoroLongLat2<-DbaBoroLongLat

DbaBoroLongLat[,1]<-factor(DbaBoroLongLat[,1])
DbaBoroLongLat[,2]<-as.numeric(DbaBoroLongLat[,2])
DbaBoroLongLat[,3]<-as.numeric(DbaBoroLongLat[,3])
summary(DbaBoroLongLat)


load('C:/Users/ygu/Desktop/columbia/project2-group9/longLat1.RData')
load('C:/Users/ygu/Desktop/columbia/project2-group9/longLat1.RData')
load('C:/Users/ygu/Desktop/columbia/project2-group9/longLat1.RData')
a<-data.frame(head(longLat1))
names(a)<-c('v1','v2','v3')
mutate_geocode(a,v1)
