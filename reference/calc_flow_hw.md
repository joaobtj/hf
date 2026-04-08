# Calculate Flow Rate using Hazen-Williams

Calculates the volumetric flow rate in a pipe given a specific head
loss, length, internal diameter, and roughness coefficient based on the
Hazen-Williams (`hw`) equation.

## Usage

``` r
calc_flow_hw(loss, length, diameter, coef = 140)
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

## Value

A numeric vector representing the volumetric flow rate in cubic meters
per second.

## Examples

``` r
# Find flow rate for a 100m pipe with 0.1m diameter, C = 140, and 2m head loss
calc_flow_hw(loss = 2, length = 100, diameter = 0.1)
#> [1] 0.01106633
```
