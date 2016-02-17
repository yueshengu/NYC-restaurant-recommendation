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

system.time(longLat11s<-data.frame(t(sapply(1:length(missingLocation),function(i){
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
longLat11<-rbind(longLat9,longLat10)
longLat11b<-rbind(longLat11,longLat11a)
longLat11d<-rbind(longLat11b,longLat11c)
longLat11f<-rbind(longLat11d,longLat11e)
longLat11h<-rbind(longLat11f,longLat11g)
longLat11j<-rbind(longLat11h,longLat11i)
longLat11l<-rbind(longLat11j,longLat11k)
longLat11n<-rbind(longLat11l,longLat11m)
longLat11p<-rbind(longLat11n,longLat11o)
longLat11r<-rbind(longLat11p,longLat11q)
longLat<-rbind(longLat11r,longLat11s)

head(longLat7_5)

# load('C:/Users/ygu/Desktop/columbia/project2-group9/longLat10_2.RData')
# longLat11q<-longLat11q[!is.na(longLat11q[,2]),]

save(longLat,file='C:/Users/ygu/Desktop/columbia/project2-group9/longLat.RData')

# missingLocation<-uniqueDbaBoro[!uniqueDbaBoro%in%longLat11r[,1]]

# save(missingLocation,file='C:/Users/ygu/Desktop/columbia/project2-group9/missingLocation.RData')





