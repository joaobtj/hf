# Friction Factors in the hf Package

## Introduction

The Darcy friction factor ($f$) is a key parameter for calculating head
loss. The `hf` package uses a functional programming approach, allowing
users to “inject” different calculation methods into the Darcy-Weisbach
functions.

## Available Equations

### 1. Colebrook-White (`calc_friction_cw`)

The industry standard for turbulent flow in rough pipes. Being an
implicit equation, `hf` solves it using numerical root-finding
(`uniroot`).

$$\frac{1}{\sqrt{f}} = - 2\log_{10}\left( \frac{\epsilon}{3.7D} + \frac{2.51}{Re\sqrt{f}} \right)$$

### 2. Swamee-Jain (`calc_friction_sj`)

A highly accurate explicit approximation of the Colebrook-White
equation. Recommended for high-performance calculations where numerical
iteration is too slow.

$$f = \frac{0.25}{\left\lbrack \log_{10}\left( \frac{\epsilon}{3.7D} + \frac{5.74}{Re^{0.9}} \right) \right\rbrack^{2}}$$

### 3. Blasius (`calc_friction_blasius`)

An empirical formula for smooth pipes and Reynolds numbers up to
$10^{5}$. It provides a simpler alternative when relative roughness is
negligible.

$$f = \frac{0.3164}{Re^{0.25}}$$
