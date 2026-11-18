#' @title Calculate Required Pipe Diameter using Hazen-Williams
#'
#' @description Calculates the required internal pipe diameter given a specific
#' target head loss, length, flow rate, and roughness coefficient based on the
#' Hazen-Williams (`hw`) equation.
#'
#' @param loss Numeric. The target friction head loss (meters).
#' @inheritParams calc_head_loss_hw
#'
#' @return A numeric vector representing the required internal diameter in meters.
#' @export
#'
#' @examples
#' # Find diameter for a 100m pipe with 2m allowable head loss, 20 L/s flow (C = 140)
#' calc_diameter_hw(loss = 2, length = 100, flow = 0.02)
#' calc_diameter_hw(loss = 2, length = 100, flow = 20, flow_unit = "L/s")
#'
calc_diameter_hw <- function(loss, length, flow, coef = 140, flow_unit = "m3/s") {
  flow <- convert_flow_unit(flow, flow_unit = flow_unit, to_m3s = TRUE)
  diameter <- ((10.67 * length * (flow / coef)^1.852) / loss)^(1 / 4.87)
  return(diameter)
}
