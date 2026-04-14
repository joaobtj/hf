#' @title Calculate Friction Factor using Blasius
#'
#' @description Calculates the Darcy friction factor using the empirical Blasius
#' equation. This formula is highly accurate for smooth pipes (e.g., PVC, glass)
#' and turbulent flows with Reynolds numbers up to 100,000.
#'
#' @inheritParams calc_friction_cw
#'
#' @return A numeric vector representing the Darcy friction factor.
#' @export
#'
#' @examples
#' # Calculate friction factor for a Reynolds number of 50,000
#' calc_friction_blasius(reynolds = 50000, roughness = 0, diameter = 0.1)
#'
calc_friction_blasius <- function(reynolds, roughness, diameter) {
  # Handle laminar flow directly. For turbulent, apply Blasius.
  # Note: Blasius assumes a smooth pipe, so 'roughness' and 'diameter'
  # are not mathematically used, but they are required in the signature
  # for compatibility with the 'calc_head_loss_darcy' injection.
  f <- ifelse(
    reynolds <= 2000,
    64 / reynolds,
    0.3164 / (reynolds^0.25)
  )

  return(f)
}
