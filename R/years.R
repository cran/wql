#' Converts dates to the corresponding numeric years
#' 
#' @param y A vector of class \code{"Date"} or \code{"POSIX"} date-time.
#' @export
#' @examples
#'
#' y <- Sys.time()
#' years(y)
#'
years <-
function(y) as.numeric(format(y, "%Y"))
