
library(stringr)
library(tibble)
library(dplyr)
library(httr)
require(jsonlite)
library (jsonlite)

get_api_data <- function(geo_level, metric, token){
  
  url <- stringr::str_c("https://api.cityhealthdashboard.com/api/data/", geo_level="tract", "-metric/",metric="housing-with-potential-lead-risk", "?token=", token="", sep = "")
  website <- httr::GET(url)
  output_list <- jsonlite::fromJSON(rawToChar(website$content))
  total_pages <- as.numeric(output_list$metrics$total_pages)
  iterate <- 1:total_pages
  output_df <- data.frame()
  
  for (i in iterate) {
    website_iterate <- httr::GET(stringr::str_c(url,"& page=", i, sep = ""))
    iterate_list <-jsonlite::fromJSON(rawToChar(website_iterate$content))
    iterate_output <- iterate_list[["rows"]]
    output_df <-dplyr::bind_rows(iterate_output, output_df)
  }
  return(output_df)
}

#example, with binge drinking (city-level):
leadd<- get_api_data(geo_level = "tract", metric = "housing-with-potential-lead-risk", token = "")
leadd