# Equações de Darcy-Weisbach

## Introdução

A equação de Darcy-Weisbach é a fórmula universal e teoricamente mais
rigorosa para o cálculo da perda de carga em condutos forçados. Ao
contrário de fórmulas empíricas como a de Hazen-Williams, a equação de
Darcy-Weisbach é aplicável a **qualquer fluido** e **qualquer regime de
escoamento** (laminar, transição ou turbulento).

No pacote `hf`, a equação baseia-se na vazão volumétrica ($Q$):

$$h_{f} = f\frac{8LQ^{2}}{\pi^{2}gD^{5}}$$

Em que:

- $h_{f}$: Perda de carga distribuída (m)
- $f$: Fator de atrito de Darcy (adimensional)
- $L$: Comprimento da tubulação (m)
- $Q$: Vazão volumétrica ($m^{3}/s$)
- $D$: Diâmetro interno (m)
- $g$: Aceleração da gravidade ($m/s^{2}$)

## 1. O Fator de Atrito ($f$)

O fator de atrito depende do Número de Reynolds e da rugosidade relativa
do tubo. O pacote `hf` fornece duas funções distintas para calculá-lo:

- [`calc_friction_cw()`](https://joaobtj.github.io/hf/reference/calc_friction_cw.md):
  Utiliza a equação implícita de **Colebrook-White** (padrão). Encontra
  a raiz exata iterativamente.
- [`calc_friction_sj()`](https://joaobtj.github.io/hf/reference/calc_friction_sj.md):
  Utiliza a equação explícita de **Swamee-Jain**, uma aproximação de
  alta precisão que não requer iteração.

``` r
# Parâmetros do escoamento
Re <- 100000        # Número de Reynolds
e <- 0.00026        # Rugosidade absoluta (m)
D <- 0.1            # Diâmetro (m)

# Comparando ambos os métodos
calc_friction_cw(reynolds = Re, roughness = e, diameter = D)
#> [1] 0.02657412
calc_friction_sj(reynolds = Re, roughness = e, diameter = D)
#> [1] 0.02681396
```

## 2. Calculando a Perda de Carga com Injeção Funcional

A função `calc_head_loss_darcy` calcula a perda, mas você pode “injetar”
a função de atrito que deseja utilizar através do argumento
`friction_fun`.

``` r
# 1. Padrão (Usa Colebrook-White automaticamente)
calc_head_loss_darcy(
  length = 100, flow = 0.02, diameter = 0.1, roughness = 0.00026
)
#> [1] 8.513127

# 2. Injeção Funcional (Usando Swamee-Jain)
calc_head_loss_darcy(
  length = 100, flow = 0.02, diameter = 0.1, roughness = 0.00026,
  friction_fun = calc_friction_sj
)
#> [1] 8.55815

# 3. Valor Direto (Se você já calculou o fator de atrito)
calc_head_loss_darcy(
  length = 100, flow = 0.02, diameter = 0.1, friction_factor = 0.025
)
#> [1] 8.262686
```

## 3. Calculando Diâmetro e Vazão

Como o fator de atrito cria uma dependência circular matemática, o
pacote `hf` utiliza solucionadores numéricos internos (`uniroot`) para
encontrar os valores exatos de diâmetro e vazão. A injeção funcional
também funciona nestas funções.

``` r
# Calcular o diâmetro necessário para uma perda de 8.56m
calc_diameter_darcy(
  loss = 8.56, length = 100, flow = 0.02, roughness = 0.00026
)
#> [1] 0.09989527

# Calcular a vazão máxima para a mesma perda de carga
calc_flow_darcy(
  loss = 8.56, length = 100, diameter = 0.1, roughness = 0.00026
)
#> [1] 0.02005564
```
