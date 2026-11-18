#' @title Calculate Flow Rate using Flamant
#'
#' @description Calculates the volumetric flow rate in a pipe given a specific
#' head loss, length, internal diameter, and Flamant coefficient.
#'
#' @param loss Numeric. The friction head loss (meters).
#' @inheritParams calc_head_loss_flamant
#'
#' @return A numeric vector representing the volumetric flow rate in the unit specified by `flow_unit` (default is `"m3/s"`).
#' @export
#'
#' @examples
#' # Find maximum flow rate for a 50m pipe with 15mm diameter and 1.5m head loss
#' calc_flow_flamant(loss = 1.5, length = 50, diameter = 0.015)
#' calc_flow_flamant(loss = 1.5, length = 50, diameter = 0.015, flow_unit = "L/h")
#'
calc_flow_flamant <- function(loss, length, diameter, coef = 0.000135, flow_unit = "m3/s") {
  flow_m3s <- ((loss * diameter^4.75) / (6.107 * coef * length))^(1 / 1.75)
  return(convert_flow_unit(flow_m3s, flow_unit = flow_unit, to_m3s = FALSE))
}
