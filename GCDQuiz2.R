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

#### A1: 2013-11-07T13:25:07Z

#### Q2: The sqldf package allows for execution of SQL commands on R data frames. We will use the sqldf package to 
#### practice the queries we might send with the dbSendQuery command in RMySQL. 
#### Download the American Community Survey data and load it into an R object called 'acs'
#### https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv

getwd()
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileURL, destfile = "./data/ACS.csv", method = "curl")
list.files("./data")
file.exists("./data/ACS.csv")
dateDownloaded <- date()
dateDownloaded

acs <- read.csv.sql("./data/ACS.csv")
class(acs)
sqldf("select * from acs where AGEP < 50 and pwgtp1")
sqldf("select pwgtp1 from acs where AGEP < 50")
sqldf("select pwgtp1 from acs")
sqldf("select * from acs")


















