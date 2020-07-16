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









