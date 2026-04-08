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
  gravity = 9.81
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

## Value

A numeric vector representing the volumetric flow rate in cubic meters
per second.

## Examples

``` r
# Default: Uses Colebrook-White to find the flow rate
calc_flow_darcy(loss = 5, length = 100, diameter = 0.1, roughness = 0.00026)
#> [1] 0.01527351

# Injecting Swamee-Jain function
calc_flow_darcy(
  loss = 5, length = 100, diameter = 0.1, roughness = 0.00026,
  friction_fun = calc_friction_sj
)
#> [1] 0.01522819
```
