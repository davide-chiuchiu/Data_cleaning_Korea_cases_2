library(tidyverse)
library(data.table)


setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
datafile_to_import <- "datasets_527325_1296546_TimeProvince.csv"
Korea_cases <- fread(datafile_to_import) %>%
  select(time = date, province, cases = confirmed, deaths = deceased, recovered = released)

Korea_cases_by_province <- Korea_cases %>%
  nest(data = -c(province))

for (i in 1 : nrow(Korea_cases_by_province)){
  
  filename <- paste("KR-", Korea_cases_by_province[i,1], ".tsv", sep = '')
  print(filename)
  write.table(Korea_cases_by_province[i,2], file = filename, sep ='\t')
  
}