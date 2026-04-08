#' @title Calculate Head Loss using Darcy-Weisbach
#'
#' @description Calculates the friction head loss in a pipe based on the universal
#' Darcy-Weisbach equation. This function allowing the user to inject any friction
#' factor calculation function (e.g., Colebrook-White or Swamee-Jain). Alternatively,
#' a pre-calculated friction factor can be provided directly.
#'
#' @param length Numeric. The length of the pipe (meters).
#' @param flow Numeric. The volumetric flow rate (cubic meters per second).
#' @param diameter Numeric. The internal diameter of the pipe (meters).
#' @param roughness Numeric. The absolute internal roughness of the pipe (meters). Required unless `friction_factor` is provided.
#' @param friction_factor Numeric. An optional pre-calculated Darcy friction factor. If provided, `roughness` and `friction_fun` are ignored.
#' @param friction_fun Function. A function to calculate the friction factor (must accept `reynolds`, `roughness`, and `diameter`). If `NULL` (the default), it uses `calc_friction_cw`.
#' @param viscosity Numeric. Kinematic viscosity of the fluid (sq. meters per sec). Default is 1.004e-6.
#' @param gravity Numeric. Acceleration due to gravity (meters per second squared). Default is 9.81.
#'
#' @return A numeric vector representing the head loss in meters.
#' @export
#'
#' @examples
#' # 1. Default: Uses Colebrook-White function automatically
#' calc_head_loss_darcy(length = 100, flow = 0.02, diameter = 0.1, roughness = 0.00026)
#'
#' # 2. Functional Injection: Pass the Swamee-Jain function as an argument
#' calc_head_loss_darcy(
#'   length = 100,
#'   flow = 0.02,
#'   diameter = 0.1,
#'   roughness = 0.00026,
#'   friction_fun = calc_friction_sj
#' )
#'
#' # 3. Direct Value: Provide the friction factor manually
#' calc_head_loss_darcy(length = 100, flow = 0.02, diameter = 0.1, friction_factor = 0.02)
#'
calc_head_loss_darcy <- function(length, flow, diameter, roughness = NULL,
                                 friction_factor = NULL,
                                 friction_fun = NULL,
                                 viscosity = 1.004e-6, gravity = 9.81) {
  # Default to Colebrook-White if no function is provided
  if (is.null(friction_fun)) {
    friction_fun <- calc_friction_cw
  }

  # Calculate friction factor dynamically if not directly provided
  if (is.null(friction_factor)) {
    if (is.null(roughness)) {
      stop("You must provide either 'roughness' or 'friction_factor'.", call. = FALSE)
    }

    # Calculate Reynolds Number: Re = 4*Q / (pi*D*nu)
    reynolds <- (4 * flow) / (pi * diameter * viscosity)

    # Apply the injected function
    friction_factor <- friction_fun(
      reynolds = reynolds,
      roughness = roughness,
      diameter = diameter
    )
  }

  # Universal Darcy-Weisbach calculation
  loss <- friction_factor * (8 * length * flow^2) / (pi^2 * gravity * diameter^5)
  return(loss)
}
