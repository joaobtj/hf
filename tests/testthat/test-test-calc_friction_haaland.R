test_that("calc_friction_haaland calcula regime laminar corretamente", {
  # Para Re = 1000, f = 64 / 1000 = 0.064
  result <- calc_friction_haaland(reynolds = 1000, roughness = 0.00026, diameter = 0.1)
  expect_equal(result, 0.064)
})

test_that("calc_friction_haaland calcula regime turbulento corretamente", {
  # Teste de consistência em regime turbulento
  # O resultado deve ser uma aproximação muito próxima ao de Colebrook-White
  result <- calc_friction_haaland(reynolds = 100000, roughness = 0.00026, diameter = 0.1)

  expect_type(result, "double")
  # O valor esperado para estes parâmetros gira em torno de 0.026 ~ 0.027
  expect_true(result > 0.026 && result < 0.027)
})

test_that("calc_friction_haaland lida com inputs vetorizados", {
  re_seq <- c(1000, 100000)
  result <- calc_friction_haaland(reynolds = re_seq, roughness = 0.00026, diameter = 0.1)

  expect_length(result, 2)
  expect_equal(result[1], 0.064)
})
