#setwd("~/NYCDSA/Data_Analysis_With_R/shinyProject")
library(tidyverse)
library(ggplot2)
library(googleVis)
 
 
# Reading the csv files into list of data frames
vax_names <- list.files(path = './immunization_coverage', pattern = '*.csv', full.names = FALSE)
vax_filepaths <- paste0('./immunization_coverage/', vax_names)
all_vax <- lapply(vax_filepaths, function(x){
  read.csv(x, header = TRUE, stringsAsFactors = FALSE, 
           check.names = FALSE)
})
# Name each data frame according to vaccination 
names(all_vax) <- str_replace_all(vax_names, ".csv", "") 

for(i in 1:length(all_vax)){
  all_vax[[i]]$vax <- names(all_vax)[i]
}


all_vax <- bind_rows(all_vax) # bind list of data frames into one data frame
names(all_vax) <-str_replace_all(names(all_vax), "^\\s|\\s$", "") # remove leading spaces
all_vax <- all_vax %>% gather(., key = "year",  value = "vax_rate", "2018":"1980", na.rm = TRUE) 
all_vax$year <- as.numeric(all_vax$year)

#Change some country names 
all_vax$Country <- gsub("Democratic People's Republic of Korea", "North Korea", all_vax$Country)
all_vax$Country <- gsub("Republic of Korea", "South Korea", all_vax$Country)
all_vax$Country <- gsub("United Kingdom of Great Britain and Northern Ireland", "United Kingdom", all_vax$Country)
all_vax$Country <- gsub("United States of America", "United States", all_vax$Country)
all_vax$Country <- gsub("Russian Federation", "Russia", all_vax$Country)
all_vax$Country <- gsub("Bolivia \\(Plurinational State of\\)", "Bolivia", all_vax$Country)
all_vax$Country <- gsub("Iran \\(Islamic Republic of\\)", "Iran", all_vax$Country)
all_vax$Country <- gsub("Venezuela \\(Bolivarian Republic of\\)", "Venezuela", all_vax$Country)
all_vax$Country <- gsub("United Republic of Tanzania", "Tanzania", all_vax$Country)
all_vax$Country <- gsub("Micronesia \\(Federated States of\\)", "Micronesia", all_vax$Country)
all_vax$Country <- gsub("Congo", "Republic of Congo", all_vax$Country)
all_vax$Country <- gsub("Republic of North Macedonia", "North Macedonia", all_vax$Country)
all_vax$Country <- gsub("Czechia", "Czech Republic", all_vax$Country)
all_vax$Country <- gsub("Republic of Moldova", "Moldova", all_vax$Country)
all_vax$Country <- gsub("Lao People's Democratic Republic", "Laos", all_vax$Country)
all_vax$Country <- gsub("Viet Nam", "Vietnam", all_vax$Country)
all_vax$Country <- gsub("Syrian Arab Republic", "Syria", all_vax$Country)

# Helper function to wrap multiple selectizeInputs in one tab
convertMenuItem <- function(mi,tabName) {
  mi$children[[1]]$attribs['data-toggle']="tab"
  mi$children[[1]]$attribs['data-value'] = tabName
  mi
}
