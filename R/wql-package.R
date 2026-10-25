

#' Class "DateTime"
#'
#' A class union of \code{"Date"} and \code{"POSIXct"} classes.
#'
#'
#' @name DateTime-class
#' @docType class
#' @section Objects from the Class: A virtual Class: No objects may be created
#' from it.
#' @seealso \code{\link{WqData-class}}
#' @keywords classes
#' @examples
#'
#' showClass("DateTime")
#'
NULL





#' Methods for Function phenoAmp
#'
#' Finds various measures of the amplitude of the annual cycle.
#'
#'
#' @name phenoAmp-methods
#' @docType methods
#' @section Methods: \describe{ \item{list("signature(x = \"ts\")")}{See
#' \code{\link{phenoAmp,ts-method}}} \item{list("signature(x = \"zoo\")")}{See
#' \code{\link{phenoAmp,zoo-method}}} }
#' @keywords methods
NULL






#' Methods for Function phenoPhase
#'
#' Finds various measures of the phase of the annual cycle.
#'
#'
#' @name phenoPhase-methods
#' @docType methods
#' @section Methods: \describe{ \item{list("signature(x = \"ts\")")}{See
#' \code{\link{phenoPhase,ts-method}}} \item{list("signature(x =
#' \"zoo\")")}{See \code{\link{phenoPhase,zoo-method}}} }
#' @keywords methods
NULL





#' San Francisco Bay water quality data
#'
#' Selected observations and variables from U.S. Geological Survey water
#' quality stations in south San Francisco Bay. Data include \acronym{CTD} and
#' nutrient measurements.
#'
#' The original downloaded dataset was modified by taking a subset of six
#' well-sampled stations and the period 1985--2004. Variable names were also
#' simplified. The data frames \code{sfbayStns} and \code{sfbayVars} describe
#' the stations and water quality variables in more detail; they were created
#' from information at the same web site. Note that the station numbers in
#' \code{sfbayStns} have been prefixed with \code{s} to make station codes into
#' legal variable names. \code{sfbayChla} was constructed from the entire
#' downloaded sfbay dataset and encompasses the period 1969--2009.
#'
#' @name sfbay
#' @aliases sfbay sfbayStns sfbayVars sfbayChla
#' @docType data
#' @format \code{sfbay} is a data frame with 23207 observations (rows) of 12
#' variables (columns):
#'
#' \tabular{rll}{ \code{[, 1]} \tab \code{date} \tab date\cr \code{[, 2]} \tab
#' \code{time} \tab time\cr \code{[, 3]} \tab \code{stn} \tab station code\cr
#' \code{[, 4]} \tab \code{depth} \tab measurement depth\cr \code{[, 5]} \tab
#' \code{chl} \tab chlorophyll \emph{a}\cr \code{[, 6]} \tab \code{dox.pct}
#' \tab dissolved oxygen\cr \code{[, 7]} \tab \code{spm} \tab suspended
#' particulate matter\cr \code{[, 8]} \tab \code{ext} \tab extinction
#' coefficient\cr \code{[, 9]} \tab \code{sal} \tab salinity\cr \code{[, 10]}
#' \tab \code{temp} \tab water temperature\cr \code{[, 11]} \tab \code{nox}
#' \tab nitrate + nitrite\cr \code{[, 12]} \tab \code{nhx} \tab ammonium\cr }
#'
#' \code{sfbayStns} is a data frame with 16 observations of 6 variables:
#'
#' \tabular{rll}{ \code{[, 1]} \tab \code{site} \tab station code\cr \code{[,
#' 2]} \tab \code{description} \tab station description\cr \code{[, 3]} \tab
#' \code{lat} \tab latitude\cr \code{[, 4]} \tab \code{long} \tab longitude\cr
#' \code{[, 5]} \tab \code{depthMax} \tab maximum depth, in m\cr \code{[, 6]}
#' \tab \code{distFrom36} \tab distance from station 36, in km\cr }
#'
#' \code{sfbayVars} is a data frame with 7 observations of 3 variables:
#'
#' \tabular{rll}{ \code{[, 1]} \tab \code{variable} \tab water quality variable
#' code\cr \code{[, 2]} \tab \code{description} \tab description\cr \code{[,
#' 3]} \tab \code{units} \tab measurement units\cr }
#'
#' \code{sfbayChla} is a time series matrix (380 months \code{x} 16 stations)
#' of average 0-5 m chlorophyll \emph{a} concentrations calculated from the
#' data in \code{sfbay}.
#' @source Downloaded from USGS on 2009-11-17.
#' @keywords datasets
#' @examples
#'
#' data(sfbay)
#' str(sfbay)
#' str(sfbayStns)
#' str(sfbayVars)
#' plot(sfbayChla[, 1:10], main = "SF Bay Chl-a")
#'
NULL





#' Methods for Function tsMake
#'
#' Creates a matrix of observations indexed by time.
#'
#'
#' @name tsMake-methods
#' @docType methods
#' @section Methods: \describe{ \item{list("signature(x = \"WqData\")")}{See
#' \code{\link{tsMake,WqData-method}}} }
#' @keywords methods
NULL





#' Miscellaneous utility functions
#'
#' A variety of small utilities used in other functions.
#'
#' \code{date2decyear}: Converts object of class \code{"Date"} to decimal year
#' assuming time of day is noon.
#'
#' \code{decyear2date}: Converts decimal year to object of class \code{"Date"}.
#'
#' \code{layerMean}: Acts on a matrix or data frame with depth in the first
#' column and observations for different variables (or different sites, or
#' different times) in each of the remaining columns. The trapezoidal mean over
#' the given depths is calculated for each of the variables. Replicate depths
#' are averaged, and missing values or data with only one unique depth are
#' handled. Data are not extrapolated to cover missing values at the top or
#' bottom of the layer. The result can differ markedly from the simple mean
#' even for equal spacing of depths, because the top and bottom values are
#' weighted by 0.5 in a trapezoidal mean.
#'
#' \code{leapYear}: \code{TRUE} if \code{x} is a leap year, \code{FALSE}
#' otherwise.
#'
#' \code{meanSub}: Mean of a subset of a vector.
#'
#' \code{monthNum}: Converts dates to the corresponding numeric month.
#'
#' \code{tsSub}: Drops seasons from a matrix or vector time series.
#'
#' \code{years}: Converts dates to the corresponding numeric years.
#'
#' @name misc
#' @rdname misc
#' @keywords manip
NULL





#' Class "WqData"
#'
#' A simple extension or subclass of the \code{"data.frame"} class for typical
#' \dQuote{discrete} water quality monitoring programs that examine phenomena
#' on a time scale of days or longer. It requires water quality data to be in a
#' specific \dQuote{long} format, although a generating function
#' \code{\link{wqData}} can be used for different forms of data.
#'
#'
#' @name WqData-class
#' @aliases WqData-class [,WqData-method summary,WqData-method plot,WqData-method
#' @docType class
#' @section Objects from the Class: Objects can be created by calls of the form
#' \code{new("WqData", d)}, where \code{d} is a data.frame. \code{d} should
#' have columns named \code{time, site, depth, variable, value} of class
#' \code{"DateTime", "factor", "numeric", "factor", "numeric"}, respectively.
#' @seealso \code{\link{DateTime-class}}, \code{\link{tsMake,WqData-method}},
#' \code{\link{wqData}}
#' @keywords classes
#' @examples
#'
#' showClass("WqData")
#' # Construct the WqData object sfb as shown in the wqData examples.
#' sfb <- wqData(sfbay, c(1, 3, 4), 5:12, site.order = TRUE, type = "wide",
#'   time.format = "%m/%d/%Y")
#' # Summarize the data
#' summary(sfb)
#' # Create boxplot summary of data
#' plot(sfb, vars = c("chl", "dox", "spm"), num.col = 2)
#' # Extract some of the data as a WqData object
#' sfb[1:10, ]  # first 10 observations
#' sfb[sfb$depth == 20, ]  # all observations at 20 m
#'
NULL





#' The main purpose of \pkg{wql} is to explore seasonal time series through
#' plots and nonparametric trend tests. It was created originally to examine
#' water quality data sets (hence, \dQuote{wql}) but is suitable as a more
#' general purpose set of tools for looking at annual or seasonal time series.
#'
#' One of the more tedious tasks in exploring environmental data sets is
#' creating usable time series from the original complex data sets, especially
#' when you want many series at will that group data in different ways. So
#' \pkg{wql} also provides a way of transforming data sets to a common format
#' that then allows a diversity of time series to be created quickly. A few
#' functions are specific to the fields of limnology and oceanography.
#'
#' The plots are designed for easy use, not for publication-quality graphs.
#' Nonetheless, extensive customization is possible by passing options through
#' \code{\ldots{}}, adding annotations in the case of base graphics, and adding
#' layers in the case of \pkg{ggplot2} objects.
#'
#' Two functions are used mainly for preparing the times series:
#'
#' \itemize{ \item a function that transforms incoming data to a common data
#' structure in the form of the \code{WqData} class \item a function that
#' easily prepares time series objects from this class }
#'
#' The \code{WqData} class can be easily adapted to non-aquatic data.
#' Obviously, the \code{depth} field can be used for elevation in atmospheric
#' studies. But more generally, the \code{site} and \code{depth} fields can be
#' used for many two-way classifications and don't need to refer to spatial
#' location.
#'
#' Some of the time series functions include:
#'
#' \itemize{ \item a variety of plots to examine changes in seasonal patterns
#' \item nonparametric trend tests \item time series interpolation and related
#' manipulations \item a simple decomposition of a series into different time
#' scales \item phenological analyses \item the use of empirical orthogonal
#' functions to detect multiple independent mechanisms underlying temporal
#' change }
#'
#' A few functions are specialized for the aquatic sciences:
#'
#' \itemize{ \item converting between oxygen concentrations and percent
#' saturation \item converting between salinity and conductivity }
#'
#' The capabilities of \pkg{wql} are more fully explained in the accompanying
#' vignette: \dQuote{wql: Exploring environmental monitoring data}.
#'
#' @name wql-package
#' @aliases wql-package wql
#' @keywords package
"_PACKAGE"





#' Class "zoo"
#'
#' Registration of S3 class \code{"zoo"} as a formally defined class. Used here
#' to allow the \code{"zoo"} class to appear in method signatures.
#'
#'
#' @name zoo-class
#' @docType class
#' @section Objects from the Class: A virtual Class: No objects may be created
#' from it.
#' @seealso \code{\link{phenoAmp}}, \code{\link{phenoPhase}}
#' @keywords classes
#' @examples
#'
#' showClass("zoo")
#'
NULL
