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
#' update.mc()
#' 
#' @export
update.mc <- function(match = "https://raw.githubusercontent.com/philbastian/matchcountry/master/inst/extdata/match.csv", 
                      countrydata = "https://raw.githubusercontent.com/philbastian/matchcountry/master/inst/extdata/countrydata.csv") {
  
  i <- readLines(ii <- url(match), encoding = "UTF-8", warn = FALSE) 
  j <- readLines(jj <- url(countrydata), encoding = "UTF-8", warn = FALSE)
  
  close(ii)
  close(jj)
  
  writeLines(i, system.file("extdata", "match.csv", package = "matchcountry"))
  writeLines(j, system.file("extdata", "countrydata.csv", package = "matchcountry"))
  
  read.mc()
}
