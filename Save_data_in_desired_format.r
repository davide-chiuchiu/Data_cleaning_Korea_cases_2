library(tidyverse)
library(data.table)

# set working directory to the one containing this script
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# create folder containing script output 
result_folder_name <- "provinces_files_folder"
dir.create(paste(getwd(), '/', result_folder_name, sep = ''))

# import the data from the csv dataset with korean prefecture data
datafile_to_import <- "datasets_527325_1296546_TimeProvince.csv"
Korea_cases <- fread(datafile_to_import) %>%
  mutate(hospitalized = NaN, icu = NaN) %>%
  select(province, time = date, cases = confirmed, deaths = deceased, hospitalized, icu, recovered = released)

# Create vector containing all Korean provinces
Korea_provinces <- Korea_cases %>%
  select(province) %>%
  unique()
  
# Create one file for each province containing the new infected people over time for that province
for (i in 1 : nrow(Korea_provinces)){
  
  # Create filename from Korea prefecture and build header
  filename <- paste(getwd(), '/', result_folder_name, '/', "KR-", Korea_provinces$province[i], ".tsv", sep = '')
  cat('# Data Source: https://www.kaggle.com/kimjihoo/coronavirusdataset/data?select=TimeProvince.csv', '\n',  file = filename)
  cat('# Data provenience: Korea Centers for Disease Control & Prevention', '\n',  file = filename, append = TRUE)
  cat('# License: CC BY-NC-SA 4.0', '\n',  file = filename, append = TRUE)
  
  # save data from province as separate file
  province_cases <- Korea_cases %>%
    filter(province == Korea_provinces$province[i]) %>%
    select(time, cases, deaths, hospitalized, icu, recovered) %>%
    arrange(time)
  
  write.table(province_cases, file = filename, sep ='\t', append = TRUE, row.names = FALSE)
  
}