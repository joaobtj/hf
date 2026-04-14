# Flamant Head Loss

## Introduction

The Flamant equation is an empirical formula widely used in agricultural
hydraulics, particularly for micro-irrigation systems (drip and
micro-sprinkler irrigation). It is highly accurate for calculating
friction head loss in **small-diameter pipes** (typically under 50 mm)
made of smooth materials like PVC and Polyethylene (PE).

### The Roughness Coefficient ($b$)

The $b$ factor represents the internal roughness of the pipe according
to Flamant’s experiments. For smooth plastic pipes (PVC, PE), the
standard value is **$0.000135$**.

### Equations

The base mathematical equation for head loss ($h_{f}$) in the metric
system is:
$$h_{f} = 6.107 \cdot b \cdot \frac{L \cdot Q^{1.75}}{D^{4.75}}$$

Where:

- $h_{f}$: Friction head loss (m)
- $L$: Pipe length (m)
- $Q$: Volumetric flow rate ($m^{3}/s$)
- $b$: Flamant roughness coefficient (dimensionless)
- $D$: Internal diameter (m)

------------------------------------------------------------------------

## 1. Calculating Head Loss

To calculate the friction head loss, use the
[`calc_head_loss_flamant()`](https://joaobtj.github.io/hf/reference/calc_head_loss_flamant.md)
function. Let’s calculate the expected head loss for a 50-meter PE pipe
($b = 0.000135$) with an internal diameter of 0.015 meters (15 mm)
carrying a flow of $0.0002\ m^{3}/s$ (0.2 L/s).

``` r
library(hf)
calc_head_loss_flamant(length = 50, flow = 0.0002, diameter = 0.015)
#> [1] 6.389998
```

## 2. Calculating Required Diameter

If you know the maximum allowable head loss for your lateral irrigation
line, you can determine the required minimum pipe diameter using
[`calc_diameter_flamant()`](https://joaobtj.github.io/hf/reference/calc_diameter_flamant.md).
Suppose the system allows a maximum head loss of 1.5 meters for a 50m
length and a $0.0002\ m^{3}/s$ flow rate.

``` r
library(hf)
calc_diameter_flamant(loss = 1.5, length = 50, flow = 0.0002)
#> [1] 0.0203516
```

## 3. Calculating Flow Rate

To find the maximum flow rate a small pipe can deliver given an
available pressure head, use the
[`calc_flow_flamant()`](https://joaobtj.github.io/hf/reference/calc_flow_flamant.md)
function.

``` r
library(hf)
calc_flow_flamant(loss = 1.5, length = 50, diameter = 0.015)
#> [1] 8.737103e-05
```
