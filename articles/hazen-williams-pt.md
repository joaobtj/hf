# Perda de Carga de Hazen-Williams

## Introdução

A equação de Hazen-Williams é uma fórmula empírica amplamente utilizada
na hidráulica para calcular a perda de carga distribuída em tubulações.
Desenvolvida no início do século XX por Allen Hazen e Gardner Williams,
sua principal vantagem sobre a equação de Darcy-Weisbach é a
simplicidade: o coeficiente de rugosidade ($`C`$) é relativamente
constante para um determinado material, independentemente das condições
de escoamento (Número de Reynolds).

### Limitações da Fórmula

É fundamental notar que a equação de Hazen-Williams é válida apenas para
**água em temperaturas ambientes** (tipicamente entre $`5^\circ C`$ e
$`25^\circ C`$) escoando a velocidades normais. Ela não deve ser
utilizada para outros fluidos, água muito quente ou regimes de
escoamento extremos.

### O Coeficiente de Rugosidade ($`C`$)

O fator $`C`$ representa a lisura interna da tubulação. Valores maiores
indicam tubos mais lisos e com menos atrito:

- **PVC ou Plástico liso:** $`C \approx 140`$ a $`150`$
- **Ferro Fundido Novo ou Aço:** $`C \approx 130`$
- **Ferro Fundido Antigo (com incrustações):** $`C \approx 100`$

### Equações

A equação matemática base para a perda de carga ($`h_f`$) no Sistema
Internacional é:
``` math
h_f = \frac{10.67 \cdot L \cdot (Q/C)^{1.852}}{D^{4.87}}
```

Em que:

- $`h_f`$: Perda de carga (m)
- $`L`$: Comprimento da tubulação (m)
- $`Q`$: Vazão volumétrica ($`m^3/s`$)
- $`C`$: Coeficiente de rugosidade de Hazen-Williams (adimensional)
- $`D`$: Diâmetro interno (m)

## 1. Calculando a Perda de Carga

Para calcular a perda de carga, utilize a função
[`calc_head_loss_hw()`](https://joaobtj.github.io/hf/reference/calc_head_loss_hw.md).
Vamos calcular a perda esperada para um tubo de PVC ($`C = 150`$) de 150
metros de comprimento, com diâmetro interno de 0,1 metros (100 mm),
transportando uma vazão de 0,025 $`m^3/s`$ (25 L/s).

``` r

library(hf)
calc_head_loss_hw(length = 150, flow = 0.025, diameter = 0.1, coef = 150)
#> [1] 11.94317
```

## 2. Calculando o Diâmetro Necessário

Se o projeto estipula uma perda de carga máxima permitida, você pode
determinar o diâmetro mínimo necessário utilizando
[`calc_diameter_hw()`](https://joaobtj.github.io/hf/reference/calc_diameter_hw.md).
Suponha que o sistema permite uma perda de carga máxima de 5 metros para
os mesmos 150m de comprimento e vazão de 0,025 $`m^3/s`$.

``` r

library(hf)
calc_diameter_hw(loss = 5, length = 150, flow = 0.025, coef = 150)
#> [1] 0.1195773
```

## 3. Calculando a Vazão

Para descobrir a vazão máxima que um tubo pode entregar dada uma pressão
disponível, use a função
[`calc_flow_hw()`](https://joaobtj.github.io/hf/reference/calc_flow_hw.md).
Vamos verificar quanta água flui por um tubo de 100m com 0,15m de
diâmetro, coeficiente de rugosidade de 140 e uma carga disponível
(perda) de 3 metros.

``` r

library(hf)
calc_flow_hw(loss = 3, length = 100, diameter = 0.15, coef = 140)
#> [1] 0.04000673
```
