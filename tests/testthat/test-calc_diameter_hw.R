test_that("calc_diameter_hw inverses head loss correctly", {
  # If we use the exact head loss from the previous test,
  # the diameter should return to exactly 0.1
  loss_val <- calc_head_loss_hw(length = 100, flow = 0.02, diameter = 0.1, coef = 140)

  calc_diam <- calc_diameter_hw(
    loss = loss_val,
    length = 100,
    flow = 0.02,
    coef = 140
  )

  expect_equal(calc_diam, 0.1, tolerance = 1e-5)
})
