#' @title Calculate Required Pipe Diameter using Flamant
#'
#' @description Calculates the required internal pipe diameter given a specific
#' target head loss, length, flow rate, and Flamant roughness coefficient.
#'
#' @param loss Numeric. The target friction head loss (meters).
#' @inheritParams calc_head_loss_flamant
#'
#' @return A numeric vector representing the required internal diameter in meters.
#' @export
#'
#' @examples
#' # Find diameter for a 50m pipe with 1.5m allowable head loss and 0.0002 m^3/s flow
#' calc_diameter_flamant(loss = 1.5, length = 50, flow = 0.0002)
#'
calc_diameter_flamant <- function(loss, length, flow, coef = 0.000135) {
  diameter <- ((6.107 * coef * length * flow^1.75) / loss)^(1 / 4.75)
  return(diameter)
}
