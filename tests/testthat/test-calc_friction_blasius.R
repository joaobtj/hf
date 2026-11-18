test_that("calc_friction_blasius calcula regime laminar corretamente", {
  # Para Re = 1000, f = 64 / 1000 = 0.064
  result <- calc_friction_blasius(reynolds = 1000, roughness = 0, diameter = 0.1)
  expect_equal(result, 0.064)
})

test_that("calc_friction_blasius calcula regime turbulento corretamente", {
  # Para Re = 10000, f = 0.3164 / (10000^0.25) = 0.3164 / 10 = 0.03164
  result <- calc_friction_blasius(reynolds = 10000, roughness = 0, diameter = 0.1)
  expect_equal(result, 0.03164, tolerance = 1e-5)
})

test_that("calc_friction_blasius lida com inputs vetorizados", {
  re_seq <- c(1000, 10000)
  expected <- c(0.064, 0.03164)

  result <- calc_friction_blasius(reynolds = re_seq, roughness = 0, diameter = 0.1)

  expect_length(result, 2)
  expect_equal(result, expected, tolerance = 1e-5)
})

test_that("calc_friction_blasius ignora rugosidade e diâmetro matematicamente", {
  # Como Blasius assume tubo liso, alterar a rugosidade ou diâmetro
  # não deve mudar o fator de atrito resultante para o mesmo Reynolds.
  res_liso <- calc_friction_blasius(reynolds = 50000, roughness = 0, diameter = 0.1)
  res_rugoso <- calc_friction_blasius(reynolds = 50000, roughness = 0.005, diameter = 0.5)

  expect_equal(res_liso, res_rugoso)
})
