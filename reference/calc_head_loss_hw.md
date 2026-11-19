# Calculate Head Loss using Hazen-Williams Equation

Calculates the friction head loss in a pipe based on the empirical
Hazen-Williams (`hw`) equation. This is valid only for water at ordinary
temperatures.

## Usage

``` r
calc_head_loss_hw(length, flow, diameter, coef = 140, flow_unit = "m3/s")
```

## Arguments

- length:

  Numeric. The length of the pipe (meters).

- flow:

  Numeric. The volumetric flow rate in the unit specified by `flow_unit`
  (default is `"m3/s"`).

- diameter:

  Numeric. The internal diameter of the pipe (meters).

- coef:

  Numeric. The Hazen-Williams roughness coefficient (dimensionless).
  Default is 140, which is typical for PVC pipes.

- flow_unit:

  Character. Unit of the volumetric flow rate. Options include `"m3/s"`
  (default), `"m3/min"`, `"m3/h"`, `"m3/d"`, `"L/s"`, `"L/min"`,
  `"L/h"`, and `"L/d"`.

## Value

A numeric vector representing the head loss in meters.

## Examples

``` r
# Calculate head loss for a 100m PVC pipe (C = 140) with 0.1m diameter and 20 L/s flow
calc_head_loss_hw(length = 100, flow = 0.02, diameter = 0.1)
#> [1] 5.984706
calc_head_loss_hw(length = 100, flow = 20, diameter = 0.1, flow_unit = "L/s")
#> [1] 5.984706
```
