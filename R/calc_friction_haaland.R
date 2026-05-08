#' @title Calculate Friction Factor using Haaland
#'
#' @description Calculates the Darcy friction factor using the explicit Haaland
#' equation. This formula is a highly accurate explicit approximation of the
#' Colebrook-White equation for turbulent flows.
#'
#' @inheritParams calc_friction_cw
#'
#' @return A numeric vector representing the Darcy friction factor.
#' @export
#'
#' @examples
#' # Calculate friction factor for a Reynolds number of 100,000
#' calc_friction_haaland(reynolds = 100000, roughness = 0.00026, diameter = 0.1)
#'
calc_friction_haaland <- function(reynolds, roughness, diameter) {
  # Handle laminar flow directly. For turbulent, apply Haaland explicit equation.
  f <- ifelse(
    reynolds <= 2000,
    64 / reynolds,
    (-1.8 * log10(((roughness / (3.7 * diameter))^1.11) + (6.9 / reynolds)))^(-2)
  )

  return(f)
}
