# Calculate Friction Factor using Colebrook-White

Calculates the Darcy friction factor iteratively using the implicit
Colebrook-White equation for turbulent flow. For laminar flow (Re \<=
2000), it returns the exact solution (64 / Re).

## Usage

``` r
calc_friction_cw(reynolds, roughness, diameter)
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
calc_friction_cw(reynolds = 100000, roughness = 0.00026, diameter = 0.1)
#> [1] 0.02657412
```
