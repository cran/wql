#' leapYear
#' @description \code{TRUE} if \code{x} is a leap year, \code{FALSE}
#' otherwise.
#' @param x integer year
#' @author 
#' Alan Jassby, James Cloern
#' @export
#' @examples
#'
#' leapYear(seq(1500, 2000, 100))
#' leapYear(c(1996.9, 1997))
#'
leapYear <- 
function(x) {
  if (!is.numeric(x))
    stop('x must be numeric')
  x <- floor(x)
  x%%4 == 0 & (x%%100 != 0 | x%%400 == 0)
}
