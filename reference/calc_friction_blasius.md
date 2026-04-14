# Calculate Friction Factor using Blasius

Calculates the Darcy friction factor using the empirical Blasius
equation. This formula is highly accurate for smooth pipes (e.g., PVC,
glass) and turbulent flows with Reynolds numbers up to 100,000.

## Usage

``` r
calc_friction_blasius(reynolds, roughness, diameter)
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
# Calculate friction factor for a Reynolds number of 50,000
calc_friction_blasius(reynolds = 50000, roughness = 0, diameter = 0.1)
#> [1] 0.02115894
```
