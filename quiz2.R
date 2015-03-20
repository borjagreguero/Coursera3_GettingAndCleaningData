setwd("~/CURSOS/Data_Science_Programming/3-Getting_cleaning_data")

# 1 --------------------  API 
library(httr)
library(httpuv)
# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
oauth_endpoints("github")

# 2. Register an application at https://github.com/settings/applications;
#    Use any URL you would like for the homepage URL (http://github.com is fine)
#    and http://localhost:1410 as the callback url
#
#    Insert your client ID and secret below - if secret is omitted, it will
#    look it up in the GITHUB_CONSUMER_SECRET environmental variable.
myapp <- oauth_app("github","f1430e1942af5be616bf", "c9f2d21a853eabfe8612ffc423cf09b99a67e0b2")

# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# 4. Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/rate_limit", gtoken)
stop_for_status(req)
content(req)

# OR:
req <- with_config(gtoken, GET("https://api.github.com/rate_limit"))
stop_for_status(req)
content(req)


gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)
output<-content(req)
output[[5]]$name
list(output[[5]]$name, output[[5]]$created_at)

#[[30]]$created_at
#[1] "2013-12-30T17:43:29Z"


# 2 --------------------------   SQLDF
# load data 
setwd("~/CURSOS/Data_Science_Programming/3-Getting_cleaning_data")
acs <- read.csv("getdata-data-ss06pid.csv")

library(sqldf)
# library(tcltk) 
sqldf("select pwgtp1 from acs")
sqldf("select pwgtp1 from acs where AGEP < 50")
sqldf("select * from acs")
sqldf("select * from acs where AGEP < 50")
sqldf("select * from acs where AGEP < 50 and pwgtp1")

# 3 --------------------------   SQLDF 
sum(unique(acs$AGEP) == sqldf("select distinct AGEP from acs")) # TRUE = SOLUTION!
length(unique(acs$AGEP))

gold<-unique(acs$AGEP)
identical(gold,sqldf("select distinct AGEP from acs"))
identical(gold,sqldf("select unique AGEP from acs")) 
sqldf("select unique AGEP from acs") == unique(acs$AGEP)
sqldf("select unique * from acs")
sqldf("select AGEP where unique from acs")
identical(gold,sqldf("select distinct pwgtp1 from acs"))

# 4 --------------------------   HTML 
library(XML)
library(RCurl)

url<-"http://biostat.jhsph.edu/~jleek/contact.html"
#doc=getURL(url)
webpage <- getURL(url)
webpage <- readLines(tc <- textConnection(webpage)); close(tc)

#html <- htmlTreeParse(url,useInternalNodes = T)
#tables <- readHTMLTable(url)
#lapply(html, function(t) dim(t)[1])

inds=c(10,20,30,100)
lines <- webpage[inds]
lines
nchar(lines)

# SOLUTION = [45 31  7 25]


# 5------------------------- FOR 
url ="https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"
# tabs <- getURL(url)
# tabs <- readHTMLTable(tabs)

require(httr)
require(XML)
url <-"https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"

file<-"getdata-wksst8110.for"
lines <- readLines(file, n=10)
lines2<-readLines(url,n=10)
w <- c(1, 9, 5, 4, 1, 3, 5, 4, 1, 3, 5, 4, 1, 3, 5, 4, 1, 3)

colNames <- c("filler", "week", "filler", "sstNino12", "filler", "sstaNino12", "filler", "sstNino3", "filler", "sstaNino3", "filler", "sstNino34", "filler", "sstaNino34", "filler", "sstNino4", "filler", "sstaNino4")

d <- read.fwf(file, w, header=FALSE, skip=4, col.names=colNames)
d <- d[, grep("^[^filler]", names(d))]
sum(d[, 4])

