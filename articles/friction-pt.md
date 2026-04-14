# Fatores de Atrito no Pacote hf

## Introdução

O fator de atrito de Darcy ($f$) é um parâmetro adimensional essencial
para o cálculo da perda de carga pela equação de Darcy-Weisbach. No
pacote `hf`, adotamos uma abordagem de **injeção funcional**, permitindo
que o usuário escolha o método de cálculo de $f$ mais adequado ao seu
problema.

## Métodos Disponíveis

### 1. Colebrook-White (`calc_friction_cw`)

Considerada a equação de referência para escoamento turbulento em tubos
rugosos. Por ser implícita, o pacote utiliza o método de `uniroot` para
encontrar a solução exata.

$$\frac{1}{\sqrt{f}} = - 2\log_{10}\left( \frac{\epsilon}{3.7D} + \frac{2.51}{Re\sqrt{f}} \right)$$

### 2. Swamee-Jain (`calc_friction_sj`)

Uma das aproximações explícitas mais precisas para a equação de
Colebrook-White. É ideal para processamento de grandes volumes de dados
por não exigir iteração numérica.

$$f = \frac{0.25}{\left\lbrack \log_{10}\left( \frac{\epsilon}{3.7D} + \frac{5.74}{Re^{0.9}} \right) \right\rbrack^{2}}$$

### 3. Blasius (`calc_friction_blasius`)

Indicada para tubos perfeitamente lisos (como PVC novo ou vidro) e
números de Reynolds até $10^{5}$.

$$f = \frac{0.3164}{Re^{0.25}}$$
