#' @title Calculate Head Loss using Hazen-Williams Equation
#'
#' @description Calculates the friction head loss in a pipe based on the empirical
#' Hazen-Williams (`hw`) equation. This is valid only for water at ordinary temperatures.
#'
#' @param length Numeric. The length of the pipe (meters).
#' @param flow Numeric. The volumetric flow rate (cubic meters per second).
#' @param diameter Numeric. The internal diameter of the pipe (meters).
#' @param coef Numeric. The Hazen-Williams roughness coefficient (dimensionless).
#' Default is 140, which is typical for PVC pipes.
#'
#' @return A numeric vector representing the head loss in meters.
#'
#' @examples
#' # Calculate head loss for a 100m PVC pipe (C = 140) with 0.1m diameter and 0.02 m^3/s flow
#' calc_head_loss_hw(length = 100, flow = 0.02, diameter = 0.1)
#'
#' @export

calc_head_loss_hw <- function(length, flow, diameter, coef = 140) {
  loss <- 10.67 * length * (flow / coef)^1.852 / (diameter^4.87)
  return(loss)
}
