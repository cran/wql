#' Dissolved oxygen at saturation
#' 
#' Finds dissolved oxygen concentration in equilibrium with water-saturated
#' air.
#' 
#' Calculations are based on the approach of Benson and Krause (1984), using
#' Green and Carritt's (1967) equation for dependence of water vapor partial
#' pressure on \code{t} and \code{S}. Equations are valid for temperature in
#' the range 0-40 C and salinity in the range 0-40.
#' 
#' @param t temperature, degrees C
#' @param S salinity, on the Practical Salinity Scale
#' @param P pressure, atm
#' @return Dissolved oxygen concentration in mg/L at 100\% saturation. If
#' \code{P = NULL}, saturation values at 1 atm are calculated.
#' @references Benson, B.B. and Krause, D. (1984) The concentration and
#' isotopic fractionation of oxygen dissolved in fresh-water and seawater in
#' equilibrium with the atmosphere. \emph{Limnology and Oceanography}
#' \bold{29,} 620-632.
#' 
#' Green, E.J. and Carritt, D.E. (1967) New tables for oxygen saturation of
#' seawater. \emph{Journal of Marine Research} \bold{25,} 140-147.
#' @keywords manip
#' @author 
#' Alan Jassby, James Cloern
#' @export
#' @examples
#' 
#' # Convert DO into % saturation for 1-m depth at Station 32.
#' # Use convention of expressing saturation at 1 atm.
#' sfb1 <- subset(sfbay, depth == 1 & stn == 32)
#' dox.pct <- with(sfb1, 100 * dox/oxySol(temp, sal))
#' summary(dox.pct)
#' 
oxySol <-
function (t, S, P = NULL) {

  temp <- t + 273.15  # deg K
  lnCstar <- -139.34411 + 157570.1/temp - 66423080/temp^2 + 1.2438e+10/temp^3 -
    862194900000/temp^4 - S * (0.017674 - 10.754/temp + 2140.7/temp^2)
  Cstar1 <- exp(lnCstar)
  if (is.null(P)) {
    # equilibrium DO Cstar at P = 1 atm
    Cstar1
  } else {   
    # transform for nonstandard pressure
    Pwv <- (1 - 0.000537 * S) * exp(18.1973 * (1 - 373.16/temp) +
            3.1813e-07 * (1 - exp(26.1205 * (1 - temp/373.16))) - 0.018726 *
            (1 - exp(8.03945 * (1 - 373.16/temp))) + 5.02802 * log(373.16/temp))
    theta <- 0.000975 - 1.426e-05 * t + 6.436e-08 * t^2
    Cstar1 * P * (1 - Pwv/P) * (1 - theta * P)/((1 - Pwv) * (1 - theta))
  }
}
