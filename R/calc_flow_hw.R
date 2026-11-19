#' @title Calculate Flow Rate using Hazen-Williams
#'
#' @description Calculates the volumetric flow rate in a pipe given a specific
#' head loss, length, internal diameter, and roughness coefficient based on the
#' Hazen-Williams (`hw`) equation.
#'
#' @param loss Numeric. The friction head loss (meters).
#' @inheritParams calc_head_loss_hw
#'
#' @return A numeric vector representing the volumetric flow rate in the unit specified by `flow_unit` (default is `"m3/s"`).
#' @export
#'
#' @examples
#' # Find flow rate for a 100m pipe with 0.1m diameter, C = 140, and 2m head loss
#' calc_flow_hw(loss = 2, length = 100, diameter = 0.1)
#' calc_flow_hw(loss = 2, length = 100, diameter = 0.1, flow_unit = "L/s")
#'
calc_flow_hw <- function(loss, length, diameter, coef = 140, flow_unit = "m3/s") {
  flow_m3s <- coef * ((loss * diameter^4.87) / (10.67 * length))^(1 / 1.852)
  return(convert_flow_unit(flow_m3s, flow_unit = flow_unit, to_m3s = FALSE))
}
