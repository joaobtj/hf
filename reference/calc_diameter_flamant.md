# Calculate Required Pipe Diameter using Flamant

Calculates the required internal pipe diameter given a specific target
head loss, length, flow rate, and Flamant roughness coefficient.

## Usage

``` r
calc_diameter_flamant(loss, length, flow, coef = 0.000135, flow_unit = "m3/s")
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

  Numeric. The Flamant roughness coefficient (`b`). Default is 0.000135,
  which is typical for smooth plastic pipes (e.g., PVC, PE).

- flow_unit:

  Character. Unit of the volumetric flow rate. Options include `"m3/s"`
  (default), `"m3/min"`, `"m3/h"`, `"m3/d"`, `"L/s"`, `"L/min"`,
  `"L/h"`, and `"L/d"`.

## Value

A numeric vector representing the required internal diameter in meters.

## Examples

``` r
# Find diameter for a 50m pipe with 1.5m allowable head loss and 0.2 L/s flow
calc_diameter_flamant(loss = 1.5, length = 50, flow = 0.0002)
#> [1] 0.0203516
calc_diameter_flamant(loss = 1.5, length = 50, flow = 0.2, flow_unit = "L/s")
#> [1] 0.0203516
```
