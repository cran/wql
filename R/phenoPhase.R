setOldClass("zoo")

#' Phenological phase
#'
#' Finds various measures of the phase of the annual cycle, or of some
#' specified month range.
#'
#' \code{phenoPhase} gives three measures of the phasing of a seasonal cycle:
#' the time of the maximum (Cloern and Jassby 2008), the \emph{fulcrum} or
#' center of gravity, and the weighted mean season (Colebrook 1979). The latter
#' has sometimes been referred to in the literature as \dQuote{centre of
#' gravity}, but it is not actually the same. These measures differ in their
#' sensitivity to changes in the seasonal pattern, and therefore also in their
#' susceptibility to sampling variability. The time of maximum is the most
#' sensitive, the weighted mean the least.
#'
#' These measures can be restricted to a subset of the year by giving the
#' desired range of seasons. This can be useful for isolating measures of, say,
#' the spring and autumn phytoplankton blooms in temperate waters. In the case
#' of a seasonal time series, a non-missing value is required for every season
#' or the result will be \code{NA}, so using a period shorter than one year can
#' also help avoid any seasons that are typically not covered by the sampling
#' program. Similarly, in the case of dated observations, a shorter period can
#' help avoid times of sparse data. The method for time series allows for other
#' than monthly frequencies, but \code{season.range} is always interpreted as
#' months for \code{zoo} objects. The method for time series requires data for
#' all seasons in \code{season.range}. The method for \code{zoo} objects will
#' provide a result regardless of number of sampling days, so make sure that
#' data are sufficient for a meaningful result.
#'
#' The measures are annum-centric, i.e., they reflect the use of calendar year
#' as the annum, which may not be appropriate for cases in which important
#' features occur in winter and span two calendar years. Such cases can be
#' handled by lagging the time series by an appropriate number of months, or by
#' subtracting an appropriate number of days from the individual dates.
#'
#' \code{\link{tsMake}} can be used to produce \code{ts} and \code{zoo} objects
#' suitable as arguments to this function.
#'
#' The default parameters used for the \code{integrate} function in
#' \code{phenoPhase} may fail for certain datasets. Try increasing the number
#' of subdivisions above its default of 100 by adding, for example,
#' \code{subdivisions = 1000} to the arguments of \code{phenoPhase}.
#'
#' @aliases phenoPhase,ts-method phenoPhase,zoo-method
#' @param x A seasonal time series, or a class \code{zoo} object.
#' @param season.range A vector of two numbers specifying the season range to
#' be considered.
#' @param ...  Additional arguments to be passed for changing integration
#' defaults.
#' @return A data frame with columns year, time of the maximum, fulcrum,
#' weighted mean time and -- in the case of \code{zoo} objects -- number of
#' observations. In the case of seasonal time series, the results are all given
#' as decimal seasons of the year. In the case of dated observations, the
#' results can be dates, day of the year, or julian day with an origin of
#' 1970-01-01, depending on the option \code{out}.
#' @seealso \code{\link{phenoAmp}}, \code{\link{tsMake}}
#' @references Cloern, J.E. and Jassby, A.D. (2008) Complex seasonal patterns
#' of primary producers at the land-sea interface. \emph{Ecology Letters}
#' \bold{11,} 1294--1303.
#'
#' Colebrook, J.M. (1979) Continuous plankton records - seasonal cycles of
#' phytoplankton and copepods in the North Atlantic ocean and the North Sea.
#' \emph{Marine Biology} \bold{51,} 23--32.
#' @keywords manip ts
#' @examples
#'
#' # ts example
#' y <- sfbayChla[, "s27"]
#' p1 <- phenoPhase(y)
#' p1
#' apply(p1, 2, sd, na.rm = TRUE)  # max.time > fulcrum > mean.wt
#' phenoPhase(y, c(3, 10))
#'
#' # zoo example
#' sfb <- wqData(sfbay, c(1, 3, 4), 5:12, site.order = TRUE, type = "wide",
#'   time.format = "%m/%d/%Y")
#' y <- tsMake(sfb, focus = "chl", layer = c(0, 5), type = "zoo")
#' phenoPhase(y[, "s27"])
#'
setGeneric(
  name = 'phenoPhase',
  def = function(x, ...)
    standardGeneric("phenoPhase")
)

#' @importFrom stats approxfun integrate optimize weighted.mean
setMethod(
  f = "phenoPhase",
  signature = "ts",
  definition = function(x, season.range = c(1, 12), ...) {

    d1 <- data.frame(yr = floor(time(x)), season = cycle(x), val =
    	as.numeric(x))
    seasons <- season.range[1]:season.range[2]
    d2 <- d1[d1$season %in% seasons, ]
    yrs <- unique(d2$yr)
    yrs.ok <- table(d2$yr, is.na(d2$val))[, 1] == length(seasons)

    # max season
    a1 <- aggregate(d2$val, list(d2$yr), which.max)
    max.time <- ifelse(yrs.ok, a1$x, NA)
    max.time <- unlist(max.time) + seasons[1] - 1

    # fulcrum
    fulc <- function(d) {
      if (sum(!is.na(d[,2])) < 2) {
        return(NA)
      } else {
        x <- d[, 1]
        y <- d[, 2]
        low <- min(x)
        up <- max(x)
        fun1 <- approxfun(x, y, rule = 2)
        fopt <- function(z) abs(integrate(fun1, low, z, ...)$value -
        	0.5*integrate(fun1, low, up, ...)$value)
        optimize(fopt, lower = low, upper = up)$minimum
      }
    }
    b1 <- by(d2[, c('season', 'val')], as.factor(d2$yr), fulc)
    fulcrum <- round(ifelse(yrs.ok, as.numeric(b1), NA), 2)

    # weighted mean season
    weighted.mean.df <- function(d) {
      d <- na.omit(d)
      if (nrow(d) == 0) {
        return(NA)
      } else {
        weighted.mean(d[,1], d[,2])
      }
    }
    b2 <- by(d2[, c('season', 'val')], as.factor(d2$yr), weighted.mean.df)
    mean.wt <- round(ifelse(yrs.ok, as.numeric(b2), NA), 2)

    as.data.frame(cbind(year = yrs, max.time, fulcrum, mean.wt),
    	row.names = seq_len(length(yrs)))
  }
)

#' @param out The form of the output.
#' @rdname phenoPhase
#' @importFrom zoo index
#' @export
setMethod(
  f = "phenoPhase",
  signature = "zoo",
  definition = function(x, season.range = c(1, 12), out = c('date', 'doy',
  	'julian'), ...) {

    # validate args
    if (!is(zoo::index(x), "DateTime"))
      stop('time index must be a DateTime object')
    indexx <- as.Date(index(x))
    out <- match.arg(out)

    d1 <- data.frame(julday = julian(indexx, origin =
    	as.Date("1970-01-01")), yr = years(indexx), season =
    	monthNum(indexx), val = as.numeric(x))
    seasons <- season.range[1]:season.range[2]
    d2 <- d1[d1$season %in% seasons, ]
    yrs <- unique(d2$yr)
    n <- table(d2$yr, is.na(d2$val))[, 1]

    # max day
    maxDay <- function(d)
      d[, 1][which.max(d[, 2])]
    b1 <- by(d2[, c('julday', 'val')], as.factor(d2$yr), maxDay)
    max.time <- as.numeric(b1)

    # fulcrum
    fulc <- function(d, m1 = season.range[1], m2 = season.range[2]) {
      if (sum(!is.na(d[,2])) < 2) {
        return(NA)
      } else {
        x <- d[, 1]
        y <- d[, 2]
        yr <- d[1, 3]
        season.length <- c(31, ifelse(leapYear(yr), 29, 28), 31, 30, 31,
        	30, 31, 31, 30, 31, 30, 31)
        lo <- julian(as.Date(paste(yr, m1, 1, sep = '-')), origin =
        	as.Date("1970-01-01"))
        up <- julian(as.Date(paste(yr, m2, season.length[m2], sep = '-')),
        	origin = as.Date("1970-01-01"))
        fun1 <- approxfun(x, y, rule = 2)
        fopt <- function(z) abs(integrate(fun1, lo, z, ...)$value -
        	0.5*integrate(fun1, lo, up, ...)$value)
        optimize(fopt, lower = lo, upper = up)$minimum
      }
    }
    b2 <- by(d2[, c('julday', 'val', 'yr')], as.factor(d2$yr), fulc)
    fulcrum <- ceiling(as.numeric(b2))

    # weighted mean day
    weighted.mean.df <- function(d) {
      d <- na.omit(d)
      if (nrow(d) == 0) {
        return(NA)
      } else {
        weighted.mean(d[,1], d[,2])
      }
    }
    b3 <- by(d2[, c('julday', 'val')], as.factor(d2$yr),
    	weighted.mean.df)
    mean.wt <- ceiling(as.numeric(b3))

    switch(match(out, c('date', 'doy', 'julian')),
      data.frame(year = yrs, max.time = as.Date(max.time), fulcrum =
      	as.Date(fulcrum), mean.wt = as.Date(mean.wt), n, row.names =
      	NULL),
      data.frame(year = yrs, max.time =
      	as.POSIXlt(as.Date(max.time))$yday + 1, fulcrum =
      	as.POSIXlt(as.Date(fulcrum))$yday + 1, mean.wt =
      	as.POSIXlt(as.Date(mean.wt))$yday + 1, n, row.names = NULL),
      as.data.frame(cbind(year = yrs, max.time, fulcrum, mean.wt, n),
      	row.names = seq_len(length(yrs)))
    )
  }
)
