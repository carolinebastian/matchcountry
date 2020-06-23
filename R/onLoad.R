#' @export

.onLoad <- function(libname, pkgname) {
  .mc <<- new.env(parent = emptyenv())
  read.mc()
}