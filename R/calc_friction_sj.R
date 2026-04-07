#' @title Calculate Friction Factor using Swamee-Jain
#'
#' @description Calculates the Darcy friction factor using the explicit Swamee-Jain
#' equation. This is a highly accurate approximation of the Colebrook-White equation
#' that does not require iteration.
#'
#' @inheritParams calc_friction_cw
#'
#' @return A numeric vector representing the Darcy friction factor.
#' @export
#'
#' @examples
#' calc_friction_sj(reynolds = 100000, roughness = 0.00026, diameter = 0.1)
#'
calc_friction_sj <- function(reynolds, roughness, diameter) {
  # Handle laminar flow directly (handles vectorized inputs gracefully via ifelse)
  f <- ifelse(
    reynolds <= 2000,
    64 / reynolds,
    0.25 / (log10((roughness / (3.7 * diameter)) + (5.74 / reynolds^0.9)))^2
  )

  return(f)
}
