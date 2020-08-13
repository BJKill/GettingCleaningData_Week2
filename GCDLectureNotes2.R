#### Getting and Cleaning Data - Week 2 ####

### MySQL ("my sequal")
# - Free and widely used open source database software
# - Widely used in internet based applications
# - Data are structured in
#       - Databases
#       - Tables within databases
#       - Fields within tables
# - Each row is called a record
# httb://en.wikipedia.org/wiki/MySQL
# hppt://www.mysql.com/

## Example Structure
# http://dev.mysql.com/doc/employee/en/sakila-structure.html

library(RMySQL)

### Connecting and listing databases
ucscDB <- dbConnect(MySQL(), user = "genome", host = "genome-mysql.cse.ucsc.edu")
result <- dbGetQuery(ucscDB, "show databases;")
dbDisconnect(ucscDB) ### vERY IMPORTANT TO DISCONNECT AFTER YOU GET DATA
result

## Connecting to hg19 and listing tables
hg19 <- dbConnect(MySQL(), user="genome",db="hg19",host="genome-mysql.cse.ucsc.edu")
allTables <- dbListTables(hg19)
length(allTables)
allTables[1:5]

## Get dimensions of a specific table
dbListFields(hg19,"affyU133Plus2") #list fileds (cols) in table with funky name
dbGetQuery(hg19, "select count(*) from affyU133Plus2") # returns number of records (rows) in table

## Read from the table
affyData <- dbReadTable(hg19, "affyU133Plus2")
head(affyData)

## Select a specific subset. can send ANY MySQL query to the database
query <- dbSendQuery(hg19, "select * from affyU133Plus2 where misMatches between 1 and 3")
affyMis <- fetch(query)
quantile(affyMis$misMatches)
# just fetch a small amount of data (first 10 rows). Must clear query afterwards
affyMisSmall <- fetch(query, n=10)
dbClearResult(query)
dim(affyMisSmall)

## Don't frorget to close the connetion!!
dbDisconnect(hg19)

## Further resources
# - RMySQL vignette: http://cran.r-project.org/web/packages/RMySQL/RMySQL.pdf
# - List of commands: http://www.pantz.org/software/mysql/mysqlcommands.html
#       - DO NOT, DO NOT, delete, add, or join things from ensembl. Only select.
#       - In general, be careful with mysql commands
# - A nice blog post summarizing some other commands: http://www.r-bloggers.com/mysql-and-r/
# 





### HDF5 - Heirarchical data format
# - Used for storing large data sets
# - Supports storing a range of data types
# - 'groups' - containing zero or more data sets and metadata
#       - Have a 'group header' with group name and list of attributes
#       - Have a 'group symbol table' with a list of objects in group
# - 'datasets' - multidimensional array of data elements with metadata
#       - Have a 'header' with name, datatype, dataspace, and storage layout
#       - Have a 'data array' with the data
# - http://www.hdfgroup.org/

##source("https://bioconductor.org/bioLite.R")
## Install R's HDF5 package
if (!requireNamespace("BiocManager", quietly = TRUE))
        install.packages("BiocManager")
BiocManager::install(version = "3.11")
BiocManager::install("rhdf5")
BiocManager::install() ## gave me error

## Create file
library(rhdf5)
created = h5createFile("example.h5")
created

## Create groups
created = h5createGroup("example.h5", "foo")
created = h5createGroup("example.h5", "baa")
created = h5createGroup("example.h5","foo/foobaa")
h5ls("example.h5")

## Write to groups
A = matrix(1:10, nrow = 5, ncol = 2)
h5write(A, "example.h5", "foo/A")
B = array(seq(0.1, 2.0, by = 0.1), dim = c(5,2,2))
attr(B, "scale") <- "liter"
h5write(B, "example.h5", "foo/foobaa/B")
h5ls("example.h5")

## Write a data set
df <- data.frame(1L:5L, seq(0, 1, length.out = 5), 
                        c("ab", "cde", "fghi", "a", "s"), stringsAsFactors = FALSE)
h5write(df, "example.h5", "df")
h5ls("example.h5")

## Reading data
readA = h5read("example.h5", "foo/A")
readB = h5read("example.h5", "foo/foobaa/B")
readdf = h5read("example.h5", "df")
readA
readB
readdf

## Writing and reading chunks
# write these 3 numbers to the first 3 rows and first column of this dataset
h5write(c(12,13,14), "example.h5", "foo/A", index = list(1:3,1)) 
h5read("example.h5", "foo/A")

## Notes and further resources
# - hdf5 can be used to optimize reading/writing from disc in R
# - extra help at https://bioconductor.org
# - HDF group site at https://www.hdfgroup.org/



### Reading Data from the Web

## Webscraping - Programatically extracting data from the HTML code of websites
# - It can be a great way to get data
# - Many websites have information you may want to programatically read
# - In some cases this is against the terms of service for the website
# - Attempting to read too many pages too quickly can get your IP address blocked
# - http://en.wikipedia.org/wiki/Web_scraping

## Example: Google Scholar
# - http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en

con = url("https://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
htmlCode = readLines(con)
close(con)
htmlCode

## Parsing with XML
library(XML)
library(httr)
url <- "https://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
url2 <- GET(url)
html <- htmlTreeParse(url2, useInternalNodes = T)
xpathSApply(html, "//title", xmlValue)                 # returns "Jeff Leek - Google Scholar"
xpathSApply(html, "//td[@id='col-citedby']", xmlValue) # returns empty list - outdated code again!

## GET from the httr package - NEEDED IT ABOVE - OUTDATED AGAIN
library(httr)
html2 = GET(url)
content2 = content(html2, as="text")
parsedHtml = htmlParse(content2, asText = TRUE)
xpathSApply(parsedHtml, "//title", xmlValue)          # returns "Jeff Leek - Google Scholar"

## Accessing websites with passwords
pg2 = GET("http://httpbin.org/basic-auth/user/passwd", authenticate("user", "passwd"))
pg2
names(pg2)

## Using handles
google = handle("http://google.com")
pg1 = GET(handle = google, path = "/")
pg2 = GET(handle = google, path = "search")

## Notes and further resources
# - R Bloggers search for web scraping
# - httr help file - http://cran.r-project.org/web/packages/httr/httr.pdf
# - See later lectures on APIs


### Reading data from APIs
## Application programming interfaces
# - https://developer.twitter.com/docs/api/1/get/blocks/blocking - BAD LINK AGAIN
# - HAD TO APPLY FOR DEVELOPER ACCESS TO TWITTER. WAITING FOR THAT.

## Accessing Twitter from R
library(httr)
myapp = oauth_app("twitter", key = "yourConsumerKeyHere", secret = "yourConsumerSecretHere")
sig = sign_oauth1.0(myapp, token = "yourTokenHere", token_secret = "yourTokenSecretHere")
homeTL = GET("https://api.twitter.com/1.1/statuses/home_timeline.json", sig)


## Converting the json object
json1 = content(homeTL)
json2 = jsonlite::fromJSON(toJSON(json1))
json2[1,1:4]

# https://dev.twitter.com/docs/api/1.1/get/search/tweets
# https://dev.twitter.com/docs/api/1.1/overview

## In general, look at the documentation
# - httr allows GET, POST, PUT, DELETE requests if you are authorized
# - You can authenticate with a user name or a password
# - Most modern APIs use something like oauth
# - httr works well with Facebook, Google, Twitter, Github, etc.
# - httr demos on Github








