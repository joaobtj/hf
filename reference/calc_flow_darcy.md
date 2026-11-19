# Calculate Flow Rate using Darcy-Weisbach

Calculates the volumetric flow rate iteratively given a specific head
loss. This function uses a functional programming approach, allowing the
injection of any friction factor function (e.g., Colebrook-White).

## Usage

``` r
calc_flow_darcy(
  loss,
  length,
  diameter,
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

- diameter:

  Numeric. The internal diameter of the pipe (meters).

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

A numeric vector representing the volumetric flow rate in the unit
specified by `flow_unit` (default is `"m3/s"`).

## Examples

``` r
# Default: Returns flow rate in m3/s
calc_flow_darcy(loss = 5, length = 100, diameter = 0.1, roughness = 0.00026)
#> [1] 0.01527351

# Returning flow rate in L/s
calc_flow_darcy(loss = 5, length = 100, diameter = 0.1, roughness = 0.00026, flow_unit = "L/s")
#> [1] 15.27351
```
