setOldClass("zoo")

#' Phenological amplitude
#'
#' Finds various measures of the amplitude of the annual cycle, or of some
#' specified season range.
#'
#' \code{phenoAmp} gives three measures of the amplitude of a seasonal cycle:
#' the range, the variance, and the median absolute deviation, along with the
#' mean and median to allow calculation of other statistics as well.
#'
#' These measures can be restricted to a subset of the year by giving the
#' desired range of season numbers. This can be useful for isolating measures
#' of, say, the spring and autumn phytoplankton blooms in temperate waters. In
#' the case of a monthly time series, for example, a non-missing value is
#' required for every month or the result will be \code{NA}, so using a period
#' shorter than one year can also help avoid any months that are typically not
#' covered by the sampling program. Similarly, in the case of dated
#' observations, a shorter period can help avoid times of sparse data. The
#' method for time series allows for other than monthly frequencies, but
#' \code{season.range} is always interpreted as months for \code{zoo} objects.
#'
#' Note that the amplitude is sensitive to the number of samples for small
#' numbers. This could be a problem for \code{zoo} objects if the sample number
#' is changing greatly from year to year, depending on the amplitude measure
#' and the underlying data distribution. So use \code{ts} objects or make sure
#' that the sample number stays more or less the same over time.
#'
#' \code{\link{tsMake}} can be used to produce \code{ts} and \code{zoo} objects
#' suitable as arguments to this function.
#'
#' @aliases phenoAmp,ts-method phenoAmp,zoo-method
#' @param x A seasonal time series, or a class \code{zoo} object.
#' @param season.range A vector of two numbers specifying the season range to
#' be considered.
#' @param ... Additional arguments passed to the method.
#' @return A matrix of class \code{ts} or \code{zoo} with individual series for
#' the range, variance, median absolute deviation, mean, median and -- in the
#' case of \code{zoo} objects -- number of samples.
#' @seealso \code{\link{phenoPhase}}, \code{\link{tsMake}}
#' @references Cloern, J.E. and Jassby, A.D. (2008) Complex seasonal patterns
#' of primary producers at the land-sea interface. \emph{Ecology Letters}
#' \bold{11,} 1294--1303.
#' @export
#' @keywords manip ts
#' @examples
#'
#' y <- sfbayChla[, "s27"]
#' phenoAmp(y) # entire year
#' # i.e., Jan-Jun only, which yields results for more years
#' phenoAmp(y, c(1, 6))
#'
setGeneric(
  name = 'phenoAmp',
  def = function(x, ...)
    standardGeneric("phenoAmp")
)

#' @rdname phenoAmp
setMethod(
  f = "phenoAmp",
  signature = "ts",
  definition = function(x, season.range = c(1, 12)) {

    # get series subset
    seasons <- season.range[1]:season.range[2]
    x1 <- tsSub(x, seas = seasons)

    # get statistics for each year
    range1 <- aggregate(x1, 1, max) - aggregate(x1, 1, min)
    var1 <- aggregate(x1, 1, var)
    mad1 <- aggregate(x1, 1, mad)
    mean1 <- aggregate(x1, 1, mean)
    median1 <- aggregate(x1, 1, median)

    # result
    cbind(range = range1, var = var1, mad = mad1, 
          mean = mean1, median = median1)
  }
)

#' @rdname phenoAmp
#' @param month.range A vector of two numbers specifying the month range to
#' be considered.
#' @importFrom stats mad var
setMethod(
  f = "phenoAmp",
  signature = "zoo",
  definition = function(x, month.range = c(1, 12)) {

    # validate args
    if (match(class(index(x)), c("Date", "POSIXct"), nomatch=0) == 0)
      stop('time index must be a Date or POSIXct object')

    # get series subset
    months1 <- month.range[1]:month.range[2]
    x1 <- x[as.numeric(format(index(x), "%m")) %in% months1]

    # get statistics for each year
    range1 <- aggregate(x1, years, max) - aggregate(x1, years, min)
    var1 <- aggregate(x1, years, var)
    mad1 <- aggregate(x1, years, mad)
    mean1 <- aggregate(x1, years, mean)
    median1 <- aggregate(x1, years, median)
    n <- aggregate(x1, years, length)

    #
    cbind(range = range1, var = var1, mad = mad1, mean = mean1,
          median = median1, n)
  }
)
