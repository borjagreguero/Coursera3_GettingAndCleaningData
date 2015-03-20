setwd("~/CURSOS/Data_Science_Programming/3-Getting_cleaning_data")

# quiz 3 ----------------------- 
if(!file.exists("./data")){dir.create("./data")}

# q.1. -----------------------
file1="https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(file1,destfile = "./data/housing.csv",method="curl")
data  <- read.csv("./data/housing.csv")

# households on greater than 10 acres who sold more than $10,000 worth
str(data) 
head(data)
# sales = AGS / ACR = lot size 
table(data$AGS %in% c("6") & data$ACR %in% c("3")) # EQUIVALENT TO: table(resData$zipcode==c("21212))

agricultureLogical  <- (data$AGS==6 & data$ACR==3)
agricultureLogical
which(agricultureLogical)
length(agricultureLogical)

# q.2. -----------------------
library(jpeg)

file1="https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
f="./data/image.jpg"
download.file(file1,f,method="curl")
img <- readJPEG(f, native=TRUE)
#30th and 80th quantiles
quantile(img,probs = c(0.3, 0.8))

#q.3. -----------------------
url1="https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
url2="https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
f1 = "./data/gdp.csv"
f2 = "./data/educationl.csv"
download.file(url1,f1,method = "curl")
download.file(url2,f2,method = "curl")

gdp=read.csv(f1,skip=4,nrows=215)
education=read.csv(f2)

names(gdp)
names(education)
head(gdp) 

gdp=gdp[,c(1,2,4,5)]
names(gdp)=c("CountryCode","rankingGdp","longname","value")

mergedData=merge(gdp,education,by="CountryCode",all=TRUE)
head(mergedData)
tail(mergedData)
names(mergedData)

sum(!is.na(unique(mergedData$rankingGdp)))

sorted <- mergedData[order(mergedData$value),] # order rest of columns by one column!!!! 
sorted <- mergedData[order(mergedData$rankingGdp),] # order rest of columns by one column!!!! 
sorted[13,]

x <- mergedData[order(mergedData$rankingGdp, decreasing=TRUE), c("CountryCode", "rankingGdp", "value")]
x[13,]

packages <- c("data.table", "jpeg")
sapply(packages, require, character.only=TRUE, quietly=TRUE)

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
f <- file.path(getwd(), "GDP.csv")
download.file(url, f,method="curl")
dtGDP <- data.table(read.csv(f, skip=4, nrows=215))
dtGDP <- dtGDP[X != ""]
dtGDP <- dtGDP[, list(X, X.1, X.3, X.4)]
setnames(dtGDP, c("X", "X.1", "X.3", "X.4"), c("CountryCode", "rankingGDP", "Long.Name", "gdp"))
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
f <- file.path(getwd(), "EDSTATS_Country.csv")
download.file(url, f,method="curl")
dtEd <- data.table(read.csv(f))
dt <- merge(dtGDP, dtEd, all=TRUE, by=c("CountryCode"))
sum(!is.na(unique(dt$rankingGDP)))
dt[order(rankingGDP, decreasing=TRUE), list(CountryCode, Long.Name.x, Long.Name.y, rankingGDP, gdp)][13]

#q.4. -----------------------
library(data.table)
mergedData[,mean(rankingGdp,na.rm=TRUE),by=Income.Group]

tapply(mergedData$rankingGdp,mergedData$Income.Group,function(x) mean(x,na.rm=TRUE)) 

#q.5. -----------------------
groups = cut(mergedData$rankingGdp, breaks = quantile(mergedData$rankingGdp,na.rm=TRUE))
table(groups)

library(Hmisc)
groups = cut2(mergedData$rankingGdp, g=5)
table(groups,mergedData$Income.Group)
