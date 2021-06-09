#' Download the MatchCountry tables from Github
#'
#' @param match Path to the master match csv file
#' @param countrydata Path to the master countrydata csv file
#'
#' This updates the Match Country files in the library to their current versions. It will overwrite
#' the existing files, so this should be used with care if reproducability of older analyses is
#' a priority. You can also use this to make your own custom files for matching.
#'
#' @examples
#' download.mc()
#' 
#' @export
download.mc <- function(match = "https://raw.githubusercontent.com/carolinebastian/matchcountry/master/inst/extdata/match.csv", 
                        countrydata = "https://raw.githubusercontent.com/carolinebastian/matchcountry/master/inst/extdata/countrydata.csv") {
  
  download.file(match, system.file("extdata", "match.csv", package = "matchcountry"), quiet = TRUE, mode = "wb")
  download.file(countrydata, system.file("extdata", "countrydata.csv", package = "matchcountry"), quiet = TRUE, mode = "wb")
  
  read.mc()
}
