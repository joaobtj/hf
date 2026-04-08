# Calculate Friction Factor using Swamee-Jain

Calculates the Darcy friction factor using the explicit Swamee-Jain
equation. This is a highly accurate approximation of the Colebrook-White
equation that does not require iteration.

## Usage

``` r
calc_friction_sj(reynolds, roughness, diameter)
```

## Arguments

- reynolds:

  Numeric. The Reynolds number of the flow (dimensionless).

- roughness:

  Numeric. The absolute internal roughness of the pipe (meters).

- diameter:

  Numeric. The internal diameter of the pipe (meters).

## Value

A numeric vector representing the Darcy friction factor.

## Examples

``` r
calc_friction_sj(reynolds = 100000, roughness = 0.00026, diameter = 0.1)
#> [1] 0.02681396
```
