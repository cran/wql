#' date2decyear
#' @param w A vector of class \code{"Date"}.
#' @author 
#' Alan Jassby, James Cloern
#' @export
#' @examples
#'
#' dates <- as.Date(c("1996-01-01", "1999-12-31", "2004-02-29", "2005-03-01"))
#' date2decyear(dates)
#'
#' decyear2date(c(1996.0014, 1999.9986, 2004.1626, 2005.1630))
#'
date2decyear <- 
function(w) {
  old_ops <- options(digits = 8)
  on.exit(options(old_ops))
  posx <- as.POSIXlt(w)
  yr <- 1900 + posx$year
  dy <- posx$yday + 0.5
  yr + dy/ifelse(leapYear(yr), 366, 365)
}
