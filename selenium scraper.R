library('RSelenium')
library(googlesheets4)

# I have downloaded google chrome beta as rsDriver does not accept lower versions of Google
# And replaced that in the file C:\Users\doreen.lam\AppData\Local\Google\Chrome\Application

# kills current servers
system("taskkill /im java.exe /f", intern=FALSE, ignore.stdout=FALSE)
# opens up a new chrome page
driver<- rsDriver()
remote_driver <- driver[["client"]]

# Open up the link
remote_driver$navigate("https://www.zap-map.com/statistics/")

# If you want to find the first element text use this
out <- remote_driver$findElement(using = "tag name", value="text")
one_el <- out$getElementText()
one_el

# Grabbing all tag names with 'text' this will create a list
els <- remote_driver$findElements(using = "tag name", value="text")

# Zapmap text for the charger split by UK
zapmap_text <- data.frame(text = unlist(sapply(els, function(x){x$getElementText()})))

# Some values do not have the <text> tag. 
Regions <- as.data.frame(zapmap_text[36:49,])
names(Regions)[1] <- "Region"

percentages <- as.data.frame(zapmap_text[50:55,])
names(percentages)[1] <- "percentages"

Regions$Region = gsub("North East", "North East (England)", Regions$Region)
Regions$Region = gsub("North West", "North West (England)", Regions$Region)
Regions$Region = gsub("Yorkshire and t…", "Yorkshire and The Humber", Regions$Region)
Regions$Region = gsub("East Midlands", "East Midlands (England)", Regions$Region)
Regions$Region = gsub("West Midlands", "West Midlands (England)", Regions$Region)
Regions$Region = gsub("Greater London", "London", Regions$Region)
Regions$Region = gsub("South East", "South East (England)", Regions$Region)
Regions$Region = gsub("South West", "South West (England)", Regions$Region)
Regions$Region = gsub("Wales", "Wales", Regions$Region)
Regions$Region = gsub("Northern Ireland", "Northern Ireland", Regions$Region)
Regions$Region = gsub("Scotland", "Scotland", Regions$Region)

Regions <- as.data.frame(Regions[-c(13,14),])
names(Regions)[1] <- "Region"
percentages$Region <- NA

percentages[1,2] <- "London"
percentages[2,2] <- "South East (England)"
percentages[3,2] <- "North West (England)"
percentages[4,2] <- "East of England"
percentages[5,2] <- "South West (England)"
percentages[6,2] <- "Scotland"

Regions <- merge(Regions, percentages, by="Region", all = TRUE)


#===============================
# You can get the numbers in the tables this way but you end up with very long values in one cell
# Havent found out how to split this, but you can use rvest in this situation
#===============================
table <- remote_driver$findElements(using = "class", value="cols_section")
table_text <- data.frame(text = unlist(sapply(table, function(x){x$getElementText()})))



