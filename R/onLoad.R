#' @export

.onLoad <- function(libname, pkgname) {
  .mc <<- new.env(parent = emptyenv())
  tryCatch(download.mc(), error = function(e) read.mc())
}