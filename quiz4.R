setwd("~/CURSOS/Data_Science_Programming/3-Getting_cleaning_data")

# quiz4
if(!file.exists("./data")){dir.create("./data")}

# q.1. -----------------------
f1="https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
f2="./data/2006microdata.csv"
download.file(f1,destfile = f2 ,method="curl")
data  <- read.csv(f2)

?strsplit()
varnames=names(data)
varnames 
wgtp=strsplit(varnames,"wgtp")
wgtp[[123]]

# q.2. -----------------------
# Remove the commas from the GDP numbers in millions of dollars and average them. What is the average? 
f1="https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
f2="./data/gdp.csv"
download.file(f1,destfile = f2 ,method="curl")
gdp=read.csv(f2,skip=4,nrows=215, stringsAsFactors=FALSE)

library(data.table)
dtGDP <- data.table(gdp)
dtGDP <- dtGDP[X != ""]
dtGDP <- dtGDP[, list(X, X.1, X.3, X.4)]
setnames(dtGDP, c("X", "X.1", "X.3", "X.4"), c("CountryCode", "rankingGDP", "Long.Name", "gdp"))

values = as.numeric(gsub(",","",dtGDP$gdp))
mean(values,na.rm=TRUE)

# q3.---------------------
countryNames = dtGDP$Long.Name

grep("^United",countryNames)
grep("*United",countryNames) 
grep("United$",countryNames) 

isUnited <- grepl("^United", dtGDP$Long.Name)
summary(isUnited)

# q4 --------------------- 
f1 = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
f2 = "./data/fedstats.csv"   
download.file(f1,destfile = f2,method="curl")
fedstats = read.csv(f2)
fedstats=data.table(dt)

names(dtGDP)
names(fedstats)

dt <- merge(x=dtGDP, y=fedstats,by= "CountryCode")
dt

# Of the countries for which the end of the fiscal year is available, how many end in June? 
isFiscal <- grep("fiscal year end",tolower(dt$Special.Notes)) # lines
isJune  <- grep("june",tolower(dt$Special.Notes))

isFiscallog <- grepl("fiscal year end",tolower(dt$Special.Notes)) # lines
isJunelog <- grepl("june",tolower(dt$Special.Notes))

fiscals = dt$Special.Notes[isFiscal]
junes = dt$Special.Notes[isJune]
junes

table(isFiscallog,isJunelog)

# q5. ----------------
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)
# How many values were collected in 2012? How many values were collected on Mondays in 2012?
years=year(sampleTimes)
days = weekdays(sampleTimes)

table (years,days)
length(which(years==2012))
length(which(years==2012 & tolower(days)=="monday"))

# addmargins - add the sums 
addmargins(table(year(sampleTimes), weekdays(sampleTimes)))
