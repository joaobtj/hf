test_that("convert_flow_unit converts correctly to and from m3/s", {
  # 1 m3/s equivale a:
  expect_equal(convert_flow_unit(1, "m3/s", to_m3s = TRUE), 1)
  expect_equal(convert_flow_unit(60, "m3/min", to_m3s = TRUE), 1)
  expect_equal(convert_flow_unit(3600, "m3/h", to_m3s = TRUE), 1)
  expect_equal(convert_flow_unit(86400, "m3/d", to_m3s = TRUE), 1)
  expect_equal(convert_flow_unit(1000, "L/s", to_m3s = TRUE), 1)
  expect_equal(convert_flow_unit(60000, "L/min", to_m3s = TRUE), 1)
  expect_equal(convert_flow_unit(3600000, "L/h", to_m3s = TRUE), 1)
  expect_equal(convert_flow_unit(86400000, "L/d", to_m3s = TRUE), 1)

  # Caminho inverso (de m3/s para a unidade escolhida):
  expect_equal(convert_flow_unit(1, "L/s", to_m3s = FALSE), 1000)
  expect_equal(convert_flow_unit(1, "m3/h", to_m3s = FALSE), 3600)
  expect_equal(convert_flow_unit(0.0002, "L/h", to_m3s = FALSE), 720)
})

test_that("convert_flow_unit accepts alternative string formats and rejects invalid ones", {
  # Formatos alternativos (maiúsculas/minúsculas, símbolo ³, abreviações)
  expect_equal(convert_flow_unit(20, "l/s", to_m3s = TRUE), 0.02)
  expect_equal(convert_flow_unit(20, "lps", to_m3s = TRUE), 0.02)
  expect_equal(convert_flow_unit(72, "m³/h", to_m3s = TRUE), 0.02)
  expect_equal(convert_flow_unit(720, "lph", to_m3s = TRUE), 0.0002)

  # Erros esperados para unidades inválidas
  expect_error(convert_flow_unit(10, "gal/min"), "Invalid 'flow_unit'")
  expect_error(convert_flow_unit(10, c("m3/s", "L/s")), "single character string")
})

test_that("Head loss functions yield identical results across equivalent flow units", {
  # Vazão equivalente: 0.02 m3/s = 20 L/s = 72 m3/h = 1200 L/min
  hl_dw_m3s <- calc_head_loss_darcy(100, 0.02, 0.1, 0.00026, flow_unit = "m3/s")
  hl_dw_ls <- calc_head_loss_darcy(100, 20, 0.1, 0.00026, flow_unit = "L/s")
  hl_dw_m3h <- calc_head_loss_darcy(100, 72, 0.1, 0.00026, flow_unit = "m3/h")
  expect_equal(hl_dw_ls, hl_dw_m3s)
  expect_equal(hl_dw_m3h, hl_dw_m3s)

  # Hazen-Williams
  hl_hw_m3s <- calc_head_loss_hw(100, 0.02, 0.1, coef = 140, flow_unit = "m3/s")
  hl_hw_ls <- calc_head_loss_hw(100, 20, 0.1, coef = 140, flow_unit = "L/s")
  expect_equal(hl_hw_ls, hl_hw_m3s)

  # Flamant (0.0002 m3/s = 0.2 L/s = 720 L/h)
  hl_fl_m3s <- calc_head_loss_flamant(50, 0.0002, 0.015, flow_unit = "m3/s")
  hl_fl_lh <- calc_head_loss_flamant(50, 720, 0.015, flow_unit = "L/h")
  expect_equal(hl_fl_lh, hl_fl_m3s)
})

test_that("Diameter functions yield identical diameters across equivalent flow units", {
  # Darcy-Weisbach
  d_dw_m3s <- calc_diameter_darcy(5, 100, 0.02, 0.00026, flow_unit = "m3/s")
  d_dw_ls <- calc_diameter_darcy(5, 100, 20, 0.00026, flow_unit = "L/s")
  expect_equal(d_dw_ls, d_dw_m3s, tolerance = 1e-6)

  # Hazen-Williams
  d_hw_m3s <- calc_diameter_hw(2, 100, 0.02, coef = 140, flow_unit = "m3/s")
  d_hw_m3h <- calc_diameter_hw(2, 100, 72, coef = 140, flow_unit = "m3/h")
  expect_equal(d_hw_m3h, d_hw_m3s)

  # Flamant
  d_fl_m3s <- calc_diameter_flamant(1.5, 50, 0.0002, flow_unit = "m3/s")
  d_fl_lh <- calc_diameter_flamant(1.5, 50, 720, flow_unit = "L/h")
  expect_equal(d_fl_lh, d_fl_m3s)
})

test_that("Flow functions return output scaled to the requested flow_unit", {
  # Darcy-Weisbach
  q_dw_m3s <- calc_flow_darcy(5, 100, 0.1, 0.00026, flow_unit = "m3/s")
  q_dw_ls <- calc_flow_darcy(5, 100, 0.1, 0.00026, flow_unit = "L/s")
  q_dw_m3h <- calc_flow_darcy(5, 100, 0.1, 0.00026, flow_unit = "m3/h")
  expect_equal(q_dw_ls, q_dw_m3s * 1000, tolerance = 1e-5)
  expect_equal(q_dw_m3h, q_dw_m3s * 3600, tolerance = 1e-5)

  # Hazen-Williams
  q_hw_m3s <- calc_flow_hw(2, 100, 0.1, coef = 140, flow_unit = "m3/s")
  q_hw_ls <- calc_flow_hw(2, 100, 0.1, coef = 140, flow_unit = "L/s")
  expect_equal(q_hw_ls, q_hw_m3s * 1000)

  # Flamant
  q_fl_m3s <- calc_flow_flamant(1.5, 50, 0.015, flow_unit = "m3/s")
  q_fl_lh <- calc_flow_flamant(1.5, 50, 0.015, flow_unit = "L/h")
  expect_equal(q_fl_lh, q_fl_m3s * 3600000)
})
