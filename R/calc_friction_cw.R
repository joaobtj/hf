#' @title Calculate Friction Factor using Colebrook-White
#'
#' @description Calculates the Darcy friction factor iteratively using the implicit
#' Colebrook-White equation for turbulent flow. For laminar flow (Re <= 2000),
#' it returns the exact solution (64 / Re).
#'
#' @param reynolds Numeric. The Reynolds number of the flow (dimensionless).
#' @param roughness Numeric. The absolute internal roughness of the pipe (meters).
#' @param diameter Numeric. The internal diameter of the pipe (meters).
#'
#' @return A numeric vector representing the Darcy friction factor.
#' @export
#'
#' @examples
#' calc_friction_cw(reynolds = 100000, roughness = 0.00026, diameter = 0.1)
#'
calc_friction_cw <- Vectorize(function(reynolds, roughness, diameter) {
  if (reynolds <= 2000) {
    return(64 / reynolds)
  }

  # Implicit Colebrook-White equation
  cw_eq <- function(f) {
    1 / sqrt(f) + 2 * log10((roughness / (3.7 * diameter)) + (2.51 / (reynolds * sqrt(f))))
  }

  # Find root (friction factor usually falls between 0.008 and 0.1)
  result <- stats::uniroot(cw_eq, interval = c(1e-5, 0.2))
  return(result$root)
})
