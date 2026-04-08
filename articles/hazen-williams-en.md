# Hazen-Williams Head Loss

## Introduction

The Hazen-Williams equation is an empirical formula widely used in
hydraulics to calculate the friction head loss in pipes. Developed in
the early 20th century by Allen Hazen and Gardner Williams, its primary
advantage over the Darcy-Weisbach equation is its simplicity: the
roughness coefficient ($C$) is relatively constant for a given pipe
material, regardless of the flow conditions (Reynolds number).

### Limitations

It is critical to note that the Hazen-Williams equation is valid only
for **water at ordinary temperatures** (typically between $5^{\circ}C$
and $25^{\circ}C$) flowing at standard velocities. It should not be used
for other fluids, very hot water, or extreme flow regimes.

### The Roughness Coefficient ($C$)

The $C$ factor represents the internal smoothness of the pipe. Higher
values indicate smoother pipes with less friction:

- **PVC or Smooth Plastic:** $C \approx 140$ to $150$
- **New Cast Iron or Steel:** $C \approx 130$
- **Old, Tuberculated Cast Iron:** $C \approx 100$

### Equations

The base mathematical equation for head loss ($h_{f}$) in the metric
system is:
$$h_{f} = \frac{10.67 \cdot L \cdot (Q/C)^{1.852}}{D^{4.87}}$$

Where:

- $h_{f}$: Friction head loss (m)
- $L$: Pipe length (m)
- $Q$: Volumetric flow rate ($m^{3}/s$)
- $C$: Hazen-Williams roughness coefficient (dimensionless)
- $D$: Internal diameter (m)

## 1. Calculating Head Loss

To calculate the friction head loss, use the
[`calc_head_loss_hw()`](https://joaobtj.github.io/hf/reference/calc_head_loss_hw.md)
function. Let’s calculate the expected head loss for a 150-meter PVC
pipe ($C = 150$) with an internal diameter of 0.1 meters (100 mm)
carrying a flow of 0.025 $m^{3}/s$ (25 L/s).

``` r
library(hf)
calc_head_loss_hw(length = 150, flow = 0.025, diameter = 0.1, coef = 150)
#> [1] 11.94317
```

## 2. Calculating Required Diameter

If you know the maximum allowable head loss for your hydraulic system,
you can determine the required minimum pipe diameter using
[`calc_diameter_hw()`](https://joaobtj.github.io/hf/reference/calc_diameter_hw.md).
Suppose the system allows a maximum head loss of 5 meters for the same
150m length and 0.025 $m^{3}/s$ flow rate.

``` r
library(hf)
calc_diameter_hw(loss = 5, length = 150, flow = 0.025, coef = 150)
#> [1] 0.1195773
```

## 3. Calculating Flow Rate

To find the maximum flow rate a pipe can deliver given an available
pressure head, use the
[`calc_flow_hw()`](https://joaobtj.github.io/hf/reference/calc_flow_hw.md)
function. Let’s find out how much water flows through a 100m pipe with a
0.15m diameter, a roughness coefficient of 140, and an available head of
3 meters.

``` r
library(hf)
calc_flow_hw(loss = 3, length = 100, diameter = 0.15, coef = 140)
#> [1] 0.04000673
```
