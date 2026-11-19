# Calculate Required Pipe Diameter using Hazen-Williams

Calculates the required internal pipe diameter given a specific target
head loss, length, flow rate, and roughness coefficient based on the
Hazen-Williams (`hw`) equation.

## Usage

``` r
calc_diameter_hw(loss, length, flow, coef = 140, flow_unit = "m3/s")
```

## Arguments

- loss:

  Numeric. The target friction head loss (meters).

- length:

  Numeric. The length of the pipe (meters).

- flow:

  Numeric. The volumetric flow rate in the unit specified by `flow_unit`
  (default is `"m3/s"`).

- coef:

  Numeric. The Hazen-Williams roughness coefficient (dimensionless).
  Default is 140, which is typical for PVC pipes.

- flow_unit:

  Character. Unit of the volumetric flow rate. Options include `"m3/s"`
  (default), `"m3/min"`, `"m3/h"`, `"m3/d"`, `"L/s"`, `"L/min"`,
  `"L/h"`, and `"L/d"`.

## Value

A numeric vector representing the required internal diameter in meters.

## Examples

``` r
# Find diameter for a 100m pipe with 2m allowable head loss, 20 L/s flow (C = 140)
calc_diameter_hw(loss = 2, length = 100, flow = 0.02)
#> [1] 0.1252402
calc_diameter_hw(loss = 2, length = 100, flow = 20, flow_unit = "L/s")
#> [1] 0.1252402
```
