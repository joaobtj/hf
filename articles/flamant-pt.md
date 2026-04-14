# Perda de Carga de Flamant

## Introdução

A equação de Flamant é uma fórmula empírica amplamente utilizada na
hidráulica agrícola, especialmente em projetos de irrigação localizada
(gotejamento e microaspersão). Ela é altamente precisa para o cálculo da
perda de carga em **tubulações de pequeno diâmetro** (tipicamente
inferiores a 50 mm) feitas de materiais lisos como PVC e Polietileno
(PE).

### O Coeficiente de Rugosidade ($b$)

O fator $b$ representa a rugosidade interna da tubulação de acordo com
os experimentos de Flamant. Para tubos plásticos lisos (PVC, PE), o
valor padrão é **$0.000135$**.

### Equações

A equação matemática base para a perda de carga ($h_{f}$) no Sistema
Internacional é:
$$h_{f} = 6.107 \cdot b \cdot \frac{L \cdot Q^{1.75}}{D^{4.75}}$$

Em que:

- $h_{f}$: Perda de carga (m)
- $L$: Comprimento da tubulação (m)
- $Q$: Vazão volumétrica ($m^{3}/s$)
- $b$: Coeficiente de rugosidade de Flamant (adimensional)
- $D$: Diâmetro interno (m)

------------------------------------------------------------------------

## 1. Calculando a Perda de Carga

Para calcular a perda de carga, utilize a função
[`calc_head_loss_flamant()`](https://joaobtj.github.io/hf/reference/calc_head_loss_flamant.md).
Vamos calcular a perda esperada para um tubo de PE ($b = 0.000135$) de
50 metros de comprimento, com diâmetro interno de 0,015 metros (15 mm),
transportando uma vazão de $0.0002\ m^{3}/s$ (0,2 L/s).

``` r
library(hf)
calc_head_loss_flamant(length = 50, flow = 0.0002, diameter = 0.015)
#> [1] 6.389998
```

## 2. Calculando o Diâmetro Necessário

Se o projeto estipula uma perda de carga máxima permitida para a linha
lateral de irrigação, você pode determinar o diâmetro mínimo necessário
utilizando
[`calc_diameter_flamant()`](https://joaobtj.github.io/hf/reference/calc_diameter_flamant.md).
Suponha que o sistema permite uma perda de carga máxima de 1,5 metros
para 50m de comprimento e vazão de $0.0002\ m^{3}/s$.

``` r
library(hf)
calc_diameter_flamant(loss = 1.5, length = 50, flow = 0.0002)
#> [1] 0.0203516
```

## 3. Calculando a Vazão

Para descobrir a vazão máxima que um tubo de pequeno diâmetro pode
entregar dada uma pressão disponível, use a função
[`calc_flow_flamant()`](https://joaobtj.github.io/hf/reference/calc_flow_flamant.md).

``` r
library(hf)
calc_flow_flamant(loss = 1.5, length = 50, diameter = 0.015)
#> [1] 8.737103e-05
```
