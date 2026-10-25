#' monthNum
#' @description Converts dates to the corresponding numeric month.
#' @param y date
#' @author 
#' Alan Jassby, James Cloern
#' @export
#' @examples
#'
#' monthNum(as.Date(c("2007-03-17", "2003-06-01")))
#'
monthNum <- 
function(y) {
  match(months(y, abbreviate = TRUE), month.abb)
}
