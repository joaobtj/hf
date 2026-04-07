#' @title Calculate Required Pipe Diameter using Darcy-Weisbach
#'
#' @description Calculates the required internal pipe diameter iteratively given a
#' specific head loss and flow rate. By taking a functional approach, it supports
#' any friction factor calculation function.
#'
#' @param loss Numeric. The target friction head loss (meters).
#' @inheritParams calc_head_loss_darcy
#'
#' @return A numeric vector representing the required internal diameter in meters.
#' @export
#'
#' @examples
#' # Find diameter using the default Colebrook-White function
#' calc_diameter_darcy(loss = 5, length = 100, flow = 0.02, roughness = 0.00026)
#'
#' # Find diameter by injecting Swamee-Jain
#' calc_diameter_darcy(
#'   loss = 5, length = 100, flow = 0.02, roughness = 0.00026,
#'   friction_fun = calc_friction_sj
#' )
#'
calc_diameter_darcy <- Vectorize(
  function(loss, length, flow, roughness,
           friction_fun = calc_friction_cw,
           viscosity = 1.004e-6, gravity = 9.81) {
    # Objective function: Calculates the difference between expected and actual head loss
    obj_fun <- function(d) {
      calc_head_loss_darcy(
        length = length,
        flow = flow,
        diameter = d,
        roughness = roughness,
        friction_fun = friction_fun,
        viscosity = viscosity,
        gravity = gravity
      ) - loss
    }

    # Searches for a diameter between 1 mm and 10 meters
    result <- stats::uniroot(obj_fun, interval = c(0.001, 10), tol = 1e-7)
    return(result$root)
  },
  vectorize.args = c("loss", "length", "flow", "roughness") # <- PREVENTS 'friction_fun' FROM BEING VECTORIZED
)
