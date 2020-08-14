#### Getting and Cleaning Data Week 2 Quiz

### Q1. Register an application with the Github API here https://github.com/settings/applications. 
### Access the API to get information on your instructors repositories (hint: this is the url you want 
### "https://api.github.com/users/jtleek/repos"). Use this data to find the time that the datasharing repo was created. 
### What time was it created? 
### 
### This tutorial may be useful (https://github.com/hadley/httr/blob/master/demo/oauth2-github.r). 
### You may also need to run the code in the base R package and not R studio.

library(httr)

# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
oauth_endpoints("github")

# 2. To make your own application, register at
#    https://github.com/settings/developers. Use any URL for the homepage URL
#    (http://github.com is fine) and  http://localhost:1410 as the callback url
#
#    Replace your key and secret below.
myapp <- oauth_app("github",
                   key = "79821046b71b61a173b1",
                   secret = "eab957adefef401ed3931597e800bad6c009a0a6"
)

# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)
1

# 4. Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)
content(req)

### A1: 2013-11-07T13:25:07Z

### The sqldf package allows for execution of SQL commands on R data frames. We will use the sqldf package to 
### practice the queries we might send with the dbSendQuery command in RMySQL. 
### Download the American Community Survey data and load it into an R object called 'acs'
### https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv

getwd()
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileURL, destfile = "./data/ACS.csv", method = "curl")
list.files("./data")
file.exists("./data/ACS.csv")
dateDownloaded <- date()
dateDownloaded

library(sqldf)
acs <- read.csv("./data/ACS.csv")
class(acs)

### Q2. Which of the following commands will select only the data for the probability weights pwgtp1 with ages less than 50?
### A2. sqldf("select pwgtp1 from acs where AGEP < 50")
head(sqldf("select * from acs where AGEP < 50 and pwgtp1"))
head(sqldf("select pwgtp1 from acs where AGEP < 50"), 50)
head(sqldf("select pwgtp1 from acs"), 50)
head(sqldf("select * from acs"))

### Q3. Using the same data frame you created in the previous problem, what is the equivalent function to unique(acs$AGEP)
### A3. sqldf("select distinct AGEP from acs")
unique(acs$AGEP)
sqldf("select distinct AGEP from acs")
sqldf("select distinct pwgtp1 from acs")
sqldf("select unique * from acs")
sqldf("select AGEP where unique from acs")


### Q4. How many characters are in the 10th, 20th, 30th and 100th lines of HTML from this page: 
### http://biostat.jhsph.edu/~jleek/contact.html (Hint: the nchar() function in R may be helpful)
### A4. 45 31 7 25
library(XML)
library(RCurl)
fileURL <- "http://biostat.jhsph.edu/~jleek/contact.html"
xData <- getURL(fileURL)
doc <- readLines(fileURL)
head(doc)
str(doc)
nchar(doc[c(10,20,30,100)])

### Q5. Read this data set into R and report the sum of the numbers in the fourth of the nine columns. 
### https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for
### Original source of the data: http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for
### (Hint this is a fixed width file format)
### A5. 32426.7
fileURL2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"
doc2 <- read.fwf(fileURL2, skip = 4, widths = c(12, 7, 4, 9, 4, 9, 4, 9, 4))
head(doc2)
colSums(doc2[,c(4,9)])

