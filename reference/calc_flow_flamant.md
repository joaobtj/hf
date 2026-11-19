# Calculate Flow Rate using Flamant

Calculates the volumetric flow rate in a pipe given a specific head
loss, length, internal diameter, and Flamant coefficient.

## Usage

``` r
calc_flow_flamant(loss, length, diameter, coef = 0.000135, flow_unit = "m3/s")
```

## Arguments

- loss:

  Numeric. The friction head loss (meters).

- length:

  Numeric. The length of the pipe (meters).

- diameter:

  Numeric. The internal diameter of the pipe (meters).

- coef:

  Numeric. The Flamant roughness coefficient (`b`). Default is 0.000135,
  which is typical for smooth plastic pipes (e.g., PVC, PE).

- flow_unit:

  Character. Unit of the volumetric flow rate. Options include `"m3/s"`
  (default), `"m3/min"`, `"m3/h"`, `"m3/d"`, `"L/s"`, `"L/min"`,
  `"L/h"`, and `"L/d"`.

## Value

A numeric vector representing the volumetric flow rate in the unit
specified by `flow_unit` (default is `"m3/s"`).

## Examples

``` r
# Find maximum flow rate for a 50m pipe with 15mm diameter and 1.5m head loss
calc_flow_flamant(loss = 1.5, length = 50, diameter = 0.015)
#> [1] 8.737103e-05
calc_flow_flamant(loss = 1.5, length = 50, diameter = 0.015, flow_unit = "L/h")
#> [1] 314.5357
```
