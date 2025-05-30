#' Get Country Data
#'
#' @param columns Columns to return (NULL returns all)
#' @param countries Which countries to return (list of ISO codes)
#' @param list Return a vector with all possible columns?
#'
#' This file provides data on countries, updated regularly. If list = TRUE,
#' other parameters will be overridden and it will return a list of columns.
#' Otherwise it will return a data frame that includes the selected countries
#' and columns.
#'
#' @examples
#' # All country data
#' mc <- country.data()
#' 
#' country.data("country", "DEU")
#' 
#' country.data(c("country", "region"), c("DEU", "USA", "BRA", "ZAF"))
#' 
#' @export

country.data <- function(columns = NULL, countries = NULL, list = FALSE) {
  countrydata <- tryCatch(get("countrydata", .mc), error = function(e) {
    read.mc()
    get("countrydata", .mc)
  })
  
  if(list) {
    return(names(countrydata))
  } else {
    if(is.null(countries)) countries <- countrydata$iso
    if(is.null(columns)) columns <- names(countrydata)
    
    row.names(countrydata) <- countrydata$iso
    return(countrydata[countries, columns]) 
  }
}
