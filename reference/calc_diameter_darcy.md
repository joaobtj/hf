# Calculate Required Pipe Diameter using Darcy-Weisbach

Calculates the required internal pipe diameter iteratively given a
specific head loss and flow rate. By taking a functional approach, it
supports any friction factor calculation function.

## Usage

``` r
calc_diameter_darcy(
  loss,
  length,
  flow,
  roughness,
  friction_fun = NULL,
  viscosity = 1.004e-06,
  gravity = 9.81,
  flow_unit = "m3/s"
)
```

## Arguments

- loss:

  Numeric. The target friction head loss (meters).

- length:

  Numeric. The length of the pipe (meters).

- flow:

  Numeric. The volumetric flow rate in the unit specified by `flow_unit`
  (default is `"m3/s"`).

- roughness:

  Numeric. The absolute internal roughness of the pipe (meters).
  Required unless `friction_factor` is provided.

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

- flow_unit:

  Character. Unit of the volumetric flow rate. Options include `"m3/s"`
  (default), `"m3/min"`, `"m3/h"`, `"m3/d"`, `"L/s"`, `"L/min"`,
  `"L/h"`, and `"L/d"`.

## Value

A numeric vector representing the required internal diameter in meters.

## Examples

``` r
# Find diameter using the default Colebrook-White function
calc_diameter_darcy(loss = 5, length = 100, flow = 0.02, roughness = 0.00026)
#> [1] 0.1107086

# Find diameter passing flow in m3/h
calc_diameter_darcy(loss = 5, length = 100, flow = 72, roughness = 0.00026, flow_unit = "m3/h")
#> [1] 0.1107086
```
