# Calculate Flow Rate using Hazen-Williams

Calculates the volumetric flow rate in a pipe given a specific head
loss, length, internal diameter, and roughness coefficient based on the
Hazen-Williams (`hw`) equation.

## Usage

``` r
calc_flow_hw(loss, length, diameter, coef = 140, flow_unit = "m3/s")
```

## Arguments

- loss:

  Numeric. The friction head loss (meters).

- length:

  Numeric. The length of the pipe (meters).

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

A numeric vector representing the volumetric flow rate in the unit
specified by `flow_unit` (default is `"m3/s"`).

## Examples

``` r
# Find flow rate for a 100m pipe with 0.1m diameter, C = 140, and 2m head loss
calc_flow_hw(loss = 2, length = 100, diameter = 0.1)
#> [1] 0.01106633
calc_flow_hw(loss = 2, length = 100, diameter = 0.1, flow_unit = "L/s")
#> [1] 11.06633
```
