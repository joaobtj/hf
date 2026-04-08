# Darcy-Weisbach Equations

## Introduction

The Darcy-Weisbach equation is the universal and most theoretically
rigorous formula for calculating friction head loss in pipe flow. Unlike
empirical formulas like Hazen-Williams, Darcy-Weisbach applies to **any
fluid** and **any flow regime** (laminar, transitional, or turbulent).

In the `hf` package, the equation is expressed using the volumetric flow
rate ($Q$) for consistency:

$$h_{f} = f\frac{8LQ^{2}}{\pi^{2}gD^{5}}$$

Where:

- $h_{f}$: Friction head loss (m)
- $f$: Darcy friction factor (dimensionless)
- $L$: Pipe length (m)
- $Q$: Volumetric flow rate ($m^{3}/s$)
- $D$: Internal diameter (m)
- $g$: Acceleration due to gravity ($m/s^{2}$)

## 1. The Friction Factor ($f$)

The friction factor depends on the Reynolds number and the relative
roughness of the pipe. The `hf` package provides two distinct functions
to calculate it:

- [`calc_friction_cw()`](https://joaobtj.github.io/hf/reference/calc_friction_cw.md):
  Uses the implicit **Colebrook-White** equation (default). It finds the
  exact root iteratively.
- [`calc_friction_sj()`](https://joaobtj.github.io/hf/reference/calc_friction_sj.md):
  Uses the explicit **Swamee-Jain** equation, a highly accurate
  approximation that runs faster on massive datasets.

``` r
# Flow parameters
Re <- 100000        # Reynolds number
e <- 0.00026        # Absolute roughness (m)
D <- 0.1            # Diameter (m)

# Compare both methods
calc_friction_cw(reynolds = Re, roughness = e, diameter = D)
#> [1] 0.02657412
calc_friction_sj(reynolds = Re, roughness = e, diameter = D)
#> [1] 0.02681396
```

## 2. Calculating Head Loss with Functional Injection

The `calc_head_loss_darcy` function calculates the head loss, but you
can *inject* the friction function you want to use via the
`friction_fun` argument.

``` r
# 1. Default approach (Uses Colebrook-White automatically)
calc_head_loss_darcy(
  length = 100, flow = 0.02, diameter = 0.1, roughness = 0.00026
)
#> [1] 8.513127

# 2. Functional Injection (Using Swamee-Jain)
calc_head_loss_darcy(
  length = 100, flow = 0.02, diameter = 0.1, roughness = 0.00026,
  friction_fun = calc_friction_sj
)
#> [1] 8.55815

# 3. Direct Value (If you already know the friction factor)
calc_head_loss_darcy(
  length = 100, flow = 0.02, diameter = 0.1, friction_factor = 0.025
)
#> [1] 8.262686
```

## 3. Calculating Diameter and Flow Rate

Because the friction factor creates a circular dependency for diameter
and flow rate, the `hf` package uses internal numerical solvers
(`uniroot`) to find the exact values. Functional injection works here as
well.

``` r
# Calculate the required diameter for a target head loss of 8.56m
calc_diameter_darcy(
  loss = 8.56, length = 100, flow = 0.02, roughness = 0.00026
)
#> [1] 0.09989527

# Calculate the maximum flow rate for the same head loss
calc_flow_darcy(
  loss = 8.56, length = 100, diameter = 0.1, roughness = 0.00026
)
#> [1] 0.02005564
```
