#' @export

.onLoad <- function() {
  .mc <<- new.env(parent = emptyenv())
  read.mc()
}