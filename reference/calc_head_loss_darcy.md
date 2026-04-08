# Calculate Head Loss using Darcy-Weisbach

Calculates the friction head loss in a pipe based on the universal
Darcy-Weisbach equation. This function allowing the user to inject any
friction factor calculation function (e.g., Colebrook-White or
Swamee-Jain). Alternatively, a pre-calculated friction factor can be
provided directly.

## Usage

``` r
calc_head_loss_darcy(
  length,
  flow,
  diameter,
  roughness = NULL,
  friction_factor = NULL,
  friction_fun = NULL,
  viscosity = 1.004e-06,
  gravity = 9.81
)
```

## Arguments

- length:

  Numeric. The length of the pipe (meters).

- flow:

  Numeric. The volumetric flow rate (cubic meters per second).

- diameter:

  Numeric. The internal diameter of the pipe (meters).

- roughness:

  Numeric. The absolute internal roughness of the pipe (meters).
  Required unless `friction_factor` is provided.

- friction_factor:

  Numeric. An optional pre-calculated Darcy friction factor. If
  provided, `roughness` and `friction_fun` are ignored.

- friction_fun:

  Function. A function to calculate the friction factor (must accept
  `reynolds`, `roughness`, and `diameter`). If `NULL` (the default), it
  uses `calc_friction_cw`.

- viscosity:

  Numeric. Kinematic viscosity of the fluid (sq. meters per sec).
  Default is 1.004e-6.

- gravity:

  Numeric. Acceleration due to gravity (meters per second squared).
  Default is 9.81.

## Value

A numeric vector representing the head loss in meters.

## Examples

``` r
# 1. Default: Uses Colebrook-White function automatically
calc_head_loss_darcy(length = 100, flow = 0.02, diameter = 0.1, roughness = 0.00026)
#> [1] 8.513127

# 2. Functional Injection: Pass the Swamee-Jain function as an argument
calc_head_loss_darcy(
  length = 100,
  flow = 0.02,
  diameter = 0.1,
  roughness = 0.00026,
  friction_fun = calc_friction_sj
)
#> [1] 8.55815

# 3. Direct Value: Provide the friction factor manually
calc_head_loss_darcy(length = 100, flow = 0.02, diameter = 0.1, friction_factor = 0.02)
#> [1] 6.610149
```
