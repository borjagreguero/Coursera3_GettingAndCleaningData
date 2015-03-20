setwd("~/CURSOS/Data_Science_Programming/3-Getting_cleaning_data")

filename<- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(filename,destfile = "microdata_survey.csv",method="curl")
dateDownloaded<-date()

data <- read.csv("microdata_survey.csv")
str(data)
subset2 <- subset(data,is.na(data$VAL)==FALSE & data$VAL==24); dim(subset2)
subset<- data[is.na(data$VAL)==FALSE & data$VAL==24,] ; dim(subset)
head(subset)
# subset2<- data[data$VAL==24,] 

subset <- data$FES
str(subset)
head(subset)

# Q2 ---------- 
filename <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx "
download.file(filename,destfile = "nat_gas.xlsx",method="curl")
dateDownloaded<-date()

# XLSX 
library(xlsx)
colindex<-7:15
rowindex<-18:23
dat <- read.xlsx("nat_gas.xlsx",sheetIndex=1, colIndex=colindex, rowIndex=rowindex)
str(dat)
sum(dat$Zip*dat$Ext,na.rm=T) 

# Q3 ---------- 
# XML 
# library(XML)
# fileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml "
# doc <- xmlTreeParse(fileurl,useInternal=TRUE)

library(XML)
library(RCurl)
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
xData <- getURL(fileURL)
doc <- xmlParse(xData)

# library(XML)
# fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
# fileURL2 <- sub('https', 'http', fileURL)
# doc <- xmlTreeParse(fileURL2, useInternal = TRUE)
# class(doc)

rootNode <- xmlRoot(doc)
xmlName(rootNode)

zipcode<-xpathSApply(rootNode,"//zipcode",xmlValue)
restaurants<- sum(zipcode==21231)
restaurants

# Q4 ----------------------------------------
file1<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv "
fileout<-"microdata.csv"
download.file(file1,fileout,method="curl")

library(data.table)

DT<-fread(fileout)

system.time(mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15))
system.time( tapply(DT$pwgtp15,DT$SEX,mean) )
system.time( mean(DT$pwgtp15,by=DT$SEX) )
system.time( DT[,mean(pwgtp15),by=SEX] )
system.time( sapply(split(DT$pwgtp15,DT$SEX),mean) )
system.time( mean(DT[DT$SEX==1,]$pwgtp15))
system.time( rowMeans(DT)[DT$SEX==2])







