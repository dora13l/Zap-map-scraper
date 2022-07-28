library(rvest)
library(dplyr)
install.packages("tidyverse")

scrape_url <- read_html("https://www.zap-map.com/statistics/")

# Get the date
Date <- scrape_url %>% 
  html_nodes(".xi_box h2") %>% 
  html_text2()

Date <- as.data.frame(Date)

# Reduce to just the date
Date <- Date[2,1]
Date <- gsub("Rapid/Ultra-rapid Chargers – " ,"", Date)
Date <- gsub("th" ,"", Date)
Date <- gsub(" " ,"-", Date)

# Table values
table_values <- scrape_url %>% 
  html_nodes(".cols_section h4") %>% 
  html_text2()

table_values <- as.data.frame(table_values)
