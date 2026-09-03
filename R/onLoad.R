#' @export

.onLoad <- function(libname, pkgname) {
  .mc <<- new.env(parent = emptyenv())
  ty <- tryCatch(download.mc(), 
                 error = function(e) {
                   tryCatch(download.mc(), error = function(e) {
                     NULL
                   })
                 })
  
  if(is.null(ty)) read.mc()
}
