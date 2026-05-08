# Calculate Friction Factor using Haaland

Calculates the Darcy friction factor using the explicit Haaland
equation. This formula is a highly accurate explicit approximation of
the Colebrook-White equation for turbulent flows.

## Usage

``` r
calc_friction_haaland(reynolds, roughness, diameter)
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
# Calculate friction factor for a Reynolds number of 100,000
calc_friction_haaland(reynolds = 100000, roughness = 0.00026, diameter = 0.1)
#> [1] 0.02647516
```
