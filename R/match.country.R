#' Match country
#'
#' @param country A vector of country names or ISO 3 digit alpha codes
#' @param output A column of the MatchCountry table (mc) to return
#' @param language The language of the inputs (by default, English; NULL will match on all)
#' languages)
#' @param match A csv file to use for matching
#' @param countrydata A csv file to use
#'
#' @return A vector with the same length as country with the matching results
#' @details This function is designed to recognize different variations of country names and 
#' standardize them. For example, "St. Kitts & Nevis", "Saint Kitts & Nevis" and "St Kitts and 
#' Nevis" all refer to the same place, but a simple merge with a table would fail to match them
#' all. The database has a table of common alternative names. Further, the algorithm removes 
#' extended characters that might lead to confusion (St. vs. Saint, for example). Where a match
#' cannot be found, NA is returned in its place.
#' 
#' If no language is specified, the algorithm will match on all languages, but this is less 
#' efficient and could be prone to errors.
#' 
#' The default output is the iso field of the countrydata data frame; any column of the countrydata
#' can be used, however.
#'
#' @examples
#' 
#' match.country("United Republic of Tanzania")
#' match.country("Tanzania")
#' 
#' @export

match.country <- function(country, output = "iso", language = "english") {
  suppressWarnings({
    match <- tryCatch(get("match", .mc), error = function(e) {
      read.mc()
      get("match", .mc)
    })
    countrydata <- get("countrydata", .mc)
    
    removepunctuation <- function(input) {
      replace <- c("&" = "AND", "SAINT" = "ST", "ISDS" = "ISLANDS", "REPUBLIC OF" = "")

      # Replace accent marks with English letters
      tryCatch({
        input <- gsub("\ue1|\uc1|\ue0|\uc0|\ue2|\uc2|\ue4|\uc4|\ue3|\uc3|\ue5|\uc5", "a", input)
        input <- gsub("\ue7|\uc7", "c", input)
        input <- gsub("\ue9|\uc9|\ue8|\uc8|\uea|\uca|\ueb|\ucb", "e", input)
        input <- gsub("\ued|\ucd|\uec|\ucc|\uee|\uce|\uef|\ucf", "i", input)
        input <- gsub("\uf1|\ud1", "n", input)
        input <- gsub("\uf3|\ud3|\uf2|\ud2|\uf4|\ud4|\uf6|\ud6|\uf5|\ud5|\uf8|\ud8", "o", input)
        input <- gsub("\ufa|\uda|\uf9|\ud0|\ufb|\udb|\ufc|\udc", "u", input)
        input <- gsub("\udf", "ss", input)  
      }, error = function(e) {})
      
      input <- gsub("[^ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz]", "", input)
      
      for(a in 1:length(replace)) input <- gsub(names(replace)[a], replace[a], toupper(input))
      
      input
    }
    
    m1 <- match
    
    if(!is.null(language)) if(language == "iso") {
      m1 <- data.frame(language = "iso", iso = countrydata$iso, name = unlist(countrydata[grep("^iso", names(countrydata))]))
      m1 <- m1[!is.na(m1$name),]
      m1 <- rbind(m1, language = "iso", iso = "GBR", name = "UK")
    } else {
      m1 <- m1[toupper(match$language) == toupper(language),]
    } 
    
    m1$match <- removepunctuation(m1$name)
    m1 <- m1[!duplicated(m1$match),]
    
    row.names(m1) <- m1$match
    
    rpc <- removepunctuation(country)
    isos <- m1[rpc, ]
    isos$iso[isos$match != rpc] <- NA
        
    if(length(output) > 1 | output[1] != "iso") {
      output_a <- output
      output_a[output_a %in% "country"] <- "english"
      output_a[output_a %in% c("imf.official", "imf", "advem")] <- "imf.advem"
      output_a[output_a %in% "hdi"] <- "undp.hdi"
      
      m2 <- countrydata[c("iso", output_a)]
      row.names(m2) <- m2[[1]]
      names(m2)[2:length(m2)] <- output
      m2[[1]] <- NULL
      
      isos$iso[is.na(isos$iso)] <- "Missing"
      
      isos[output] <- m2[isos$iso,] #ifelse(is.na(isos[[1]]), NA, m2[isos$iso, output])
      row.names(isos) <- NULL
    }
  })
  
  if(length(output) == 1) {
    return(isos[[output]])
  } else return(isos[output])
}
