#' Reads the MatchCountry tables into memory
#'
#' @param match Local path to the match csv file
#' @param countrydata Local path to the countrydata csv file
#'
#' This is mostly used behind the scenes (on package loading or when update.mc is called). It loads the 
#' csv files with country data into memory.
#'
#' @examples
#' read.mc()
#' 
#' @export

read.mc <- function(match = read.csv(system.file("extdata", "match.csv", package = "matchcountry"), 
                                     na.strings = "", stringsAsFactors = FALSE, encoding = "UTF-8"),
                    countrydata = read.csv(system.file("extdata", "countrydata.csv", package = "matchcountry"),
                                           na.strings = "", stringsAsFactors = FALSE, encoding = "UTF-8")) {
  tryCatch(.mc, error = function(e) {
    .mc <<- new.env(parent = emptyenv())
  })
  
  names(countrydata)[1] <- "iso"
  names(match)[1] <- "language"
  
  assign("match", match, .mc)
  assign("countrydata", countrydata, .mc)
  
  ret <- .mc
}
