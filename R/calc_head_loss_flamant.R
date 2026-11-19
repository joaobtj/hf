#' @title Calculate Head Loss using Flamant Equation
#'
#' @description Calculates the friction head loss in a pipe based on the empirical
#' Flamant equation. This formula is highly recommended for small-diameter plastic
#' pipes (typically < 50 mm) commonly used in micro-irrigation systems.
#'
#' @param length Numeric. The length of the pipe (meters).
#' @param flow Numeric. The volumetric flow rate in the unit specified by `flow_unit` (default is `"m3/s"`).
#' @param diameter Numeric. The internal diameter of the pipe (meters).
#' @param coef Numeric. The Flamant roughness coefficient (`b`).
#' Default is 0.000135, which is typical for smooth plastic pipes (e.g., PVC, PE).
#' @param flow_unit Character. Unit of the volumetric flow rate. Options include `"m3/s"` (default), `"m3/min"`, `"m3/h"`, `"m3/d"`, `"L/s"`, `"L/min"`, `"L/h"`, and `"L/d"`.
#'
#' @return A numeric vector representing the head loss in meters.
#' @export
#'
#' @examples
#' # Calculate head loss for a 50m PE pipe with 15mm diameter and 0.2 L/s flow
#' calc_head_loss_flamant(length = 50, flow = 0.0002, diameter = 0.015)
#' calc_head_loss_flamant(length = 50, flow = 0.2, diameter = 0.015, flow_unit = "L/s")
#'
calc_head_loss_flamant <- function(length, flow, diameter, coef = 0.000135, flow_unit = "m3/s") {
  flow <- convert_flow_unit(flow, flow_unit = flow_unit, to_m3s = TRUE)
  loss <- 6.107 * coef * length * (flow^1.75) / (diameter^4.75)
  return(loss)
}
