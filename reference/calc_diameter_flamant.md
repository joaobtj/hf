# Calculate Required Pipe Diameter using Flamant

Calculates the required internal pipe diameter given a specific target
head loss, length, flow rate, and Flamant roughness coefficient.

## Usage

``` r
calc_diameter_flamant(loss, length, flow, coef = 0.000135)
```

## Arguments

- loss:

  Numeric. The target friction head loss (meters).

- length:

  Numeric. The length of the pipe (meters).

- flow:

  Numeric. The volumetric flow rate (cubic meters per second).

- coef:

  Numeric. The Flamant roughness coefficient (`b`). Default is 0.000135,
  which is typical for smooth plastic pipes (e.g., PVC, PE).

## Value

A numeric vector representing the required internal diameter in meters.

## Examples

``` r
# Find diameter for a 50m pipe with 1.5m allowable head loss and 0.0002 m^3/s flow
calc_diameter_flamant(loss = 1.5, length = 50, flow = 0.0002)
#> [1] 0.0203516
```
