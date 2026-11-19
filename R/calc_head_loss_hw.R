#' @title Calculate Head Loss using Hazen-Williams Equation
#'
#' @description Calculates the friction head loss in a pipe based on the empirical
#' Hazen-Williams (`hw`) equation. This is valid only for water at ordinary temperatures.
#'
#' @param length Numeric. The length of the pipe (meters).
#' @param flow Numeric. The volumetric flow rate in the unit specified by `flow_unit` (default is `"m3/s"`).
#' @param diameter Numeric. The internal diameter of the pipe (meters).
#' @param coef Numeric. The Hazen-Williams roughness coefficient (dimensionless).
#' Default is 140, which is typical for PVC pipes.
#' @param flow_unit Character. Unit of the volumetric flow rate. Options include `"m3/s"` (default), `"m3/min"`, `"m3/h"`, `"m3/d"`, `"L/s"`, `"L/min"`, `"L/h"`, and `"L/d"`.
#'
#' @return A numeric vector representing the head loss in meters.
#' @export
#'
#' @examples
#' # Calculate head loss for a 100m PVC pipe (C = 140) with 0.1m diameter and 20 L/s flow
#' calc_head_loss_hw(length = 100, flow = 0.02, diameter = 0.1)
#' calc_head_loss_hw(length = 100, flow = 20, diameter = 0.1, flow_unit = "L/s")
#'
calc_head_loss_hw <- function(length, flow, diameter, coef = 140, flow_unit = "m3/s") {
  flow <- convert_flow_unit(flow, flow_unit = flow_unit, to_m3s = TRUE)
  loss <- 10.67 * length * (flow / coef)^1.852 / (diameter^4.87)
  return(loss)
}
