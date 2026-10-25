setGeneric(
  name = "tsMake",
  def = function(object, ...)
    standardGeneric("tsMake")
)

#' Create time series from water quality data
#'
#' Creates a matrix time series object from an object of class \code{"WqData"},
#' either all variables for a single site or all sites for a single variable.
#'
#' When \code{qprob = NULL}, the function averages all included depths for each
#' day, the implicit assumption being that the layer is well-mixed and/or the
#' samples are evenly distributed with depth in the layer. If \code{layer =
#' "max.depths"}, then only the value at the maximum depth for each time, site
#' and variable combination will be used. If no layer is specified, all depths
#' will be used.
#'
#' The function produces a matrix time series of all variables for the
#' specified site or all sites for the specified variable. If \code{type =
#' "ts.mon"}, available daily data are averaged to produce a monthly time
#' series, from which a quarterly or annual series can be created if needed. If
#' you want values for the actual dates of observation, then set \code{type =
#' "zoo"}.
#'
#' When \code{qprob} is a number from 0 to 1, it is interpreted as a
#' probability and the corresponding quantile is used to aggregate observations
#' within the specified layer. So to get the maximum, for example, use qprob =
#' 1. If \code{type = "ts.mon"}, the same quantile is used to aggregate all the
#' available daily values.
#' @name tsMake
#' @aliases tsMake,WqData-method
#' @export
#' @importFrom reshape2 dcast
#' @importFrom zoo zoo as.yearmon
#' @importFrom stats as.ts
#' @param object Object of class \code{"WqData"}.
#' @param focus Name of a site or water quality variable.
#' @param layer Number specifying a single depth; a numeric vector of length 2
#' specifying top and bottom depths of layer; a list specifying multiple depths
#' and/or layers; or just the string \code{"max.depths"}.
#' @param type \code{ts.mon} to get a monthly time series, \code{zoo} to get an
#' object of class \code{"zoo"} with individual observation dates.
#' @param qprob quantile probability, a number between 0 and 1.
#' @return A matrix of class \code{"mts"} or \code{"zoo"}.
#' @note The layer list is allowed to include negative numbers, which may have
#' been used in the \code{WqData} object to denote variables that apply to the
#' water column as a whole, such as, say, -1 for light attenuation coefficient.
#' This enables \code{focus = 's27'} and \code{layer = list(-1, c(0, 5))} to
#' produce a time series matrix for station 27 that includes both attenuation
#' coefficient and chlorophyll averaged over the top 5 m. Negative numbers may
#' also have been used in the \code{WqData} object to identify qualitative
#' depths such as \dQuote{near bottom}, which is not uncommon in historical
#' data sets. So data from such depths can be aggregated easily with other data
#' to make these time series.
#' @seealso \code{\link{WqData-class}}
#' @keywords ts
#' @examples
#'
#' # Create new WqData object
#' sfb <- wqData(sfbay, c(1, 3:4), 5:12, site.order = TRUE,
#'   time.format = "%m/%d/%Y", type = "wide")
#'
#' # Find means in the 0-10 m layer
#' y <- tsMake(sfb, focus = "s27", layer = c(0, 10))
#' plot(y, main = "Station 27")
#' # Or select medians in the same layer
#' y1 <- tsMake(sfb, focus = "s27", layer = c(0, 10), qprob = 0.5)
#' plot(y1, main = "Station 27")
#' # Compare means:medians
#' apply(y / y1, 2, mean, na.rm = TRUE)
#'
#' # Combine a layer with a single additional depth
#' y <- tsMake(sfb, focus = "chl", layer = list(c(0, 2), 5))
#' plot(y, main = "Chlorophyll a, ug/L")
#'
#' # Use values from the deepest samples
#' y <- tsMake(sfb, focus = "dox", layer = "max.depths", type = "zoo")
#' head(y)
#' plot(y, type = "h", main = "'Bottom' DO, mg/L")
#'
setMethod(
  f = "tsMake",
  signature = "WqData",
  definition = function(object, focus, layer, type = c("ts.mon", "zoo"),
    qprob = NULL)
  {

    # Validate args
    d <- data.frame(object)
    if ( missing(focus) || length(focus) > 1 )
      stop("'focus' must be the name of a single site or variable.")
    if (match(focus, d$site, nomatch = 0) > 0) {
      d <- d[d$site == focus, ]
      if (nrow(d) == 0) 
        stop("No data for this site.")
    } else {
      if (match(focus, d$variable, nomatch = 0) > 0) {
        d <- d[d$variable == focus, ]
        if (nrow(d) == 0) 
          stop("No data for this variable.")
      } else {
        stop("'focus' does not match any sites or variables")
      }
    }
    type <- match.arg(type)

    # Assemble all depths
    depths <- NULL
    if (missing(layer))
      layer <- list(c(-Inf, Inf))
    if (identical(layer, 'max.depths')) {
      ans <- aggregate(depth ~ time + site + variable, 
                       data = d, max, na.rm = TRUE)
      d <- merge(d, ans)
      d$depth <- depths <- max(d$depth, na.rm=TRUE) + 1
    } else {
      if (!is(layer, "list"))
        layer <- list(layer)
      for (el in layer) {
        if ( !is(el, "numeric") || length(el) > 2 )
          stop("layer is not specified correctly")
        if (length(el) > 1) {
          depths1 <- unique(d[d$depth >= el[1] & d$depth <= el[2], "depth"])
          depths <- c(depths, depths1)
        } else {
          depths <- c(depths, el)
        }
      }
    }
    d <- d[d$depth %in% depths, ]
    if (nrow(d) == 0) 
      stop("No data for this layer.")

    # Define aggregation function
    if (is.null(qprob)) {
      f <- mean
    } else {
      f <- function(x, ...) quantile(x, probs = qprob, ...)
    }

    # Reshape data
    if (match(focus, d$site, nomatch = 0) > 0) {
      c1 <- dcast(d, time ~ variable, fun.aggregate = f, na.rm = TRUE)
    } else {
      c1 <- dcast(d, time ~ site, fun.aggregate = f, na.rm = TRUE)
    } 

    # Create zoo or ts object
    z1 <- zoo(c1[, -1], c1[, 1])
    if (type == 'ts.mon') {
      z1 <- aggregate(z1, as.yearmon, f, na.rm = TRUE)
      z1names <- colnames(z1)
      z1 <- as.ts(z1)
      colnames(z1) <- z1names
    }
    z1
  }
)
