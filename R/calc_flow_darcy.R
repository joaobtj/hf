#' @title Calculate Flow Rate using Darcy-Weisbach
#'
#' @description Calculates the volumetric flow rate iteratively given a specific
#' head loss. This function uses a functional programming approach, allowing the
#' injection of any friction factor function (e.g., Colebrook-White).
#'
#' @param loss Numeric. The target friction head loss (meters).
#' @inheritParams calc_head_loss_darcy
#'
#' @return A numeric vector representing the volumetric flow rate in cubic meters per second.
#' @export
#'
#' @examples
#' # Default: Uses Colebrook-White to find the flow rate
#' calc_flow_darcy(loss = 5, length = 100, diameter = 0.1, roughness = 0.00026)
#'
#' # Injecting Swamee-Jain function
#' calc_flow_darcy(
#'   loss = 5, length = 100, diameter = 0.1, roughness = 0.00026,
#'   friction_fun = calc_friction_sj
#' )
#'
calc_flow_darcy <- Vectorize(
  function(loss, length, diameter, roughness,
           friction_fun = NULL,
           viscosity = 1.004e-6, gravity = 9.81) {

    # Default to Colebrook-White if no function is provided
    if (is.null(friction_fun)) {
      friction_fun <- calc_friction_cw
    }

    # Objective function: Calculates the difference between expected and actual head loss
    obj_fun <- function(q) {
      calc_head_loss_darcy(
        length = length,
        flow = q,
        diameter = diameter,
        roughness = roughness,
        friction_fun = friction_fun,
        viscosity = viscosity,
        gravity = gravity
      ) - loss
    }

    # Searches for a flow rate between near-zero and 100 m^3/s (100,000 L/s)
    result <- stats::uniroot(obj_fun, interval = c(1e-7, 100), tol = 1e-7)
    return(result$root)
  },
  vectorize.args = c("loss", "length", "diameter", "roughness") # <- PREVENTS 'friction_fun' FROM BEING VECTORIZED
)
