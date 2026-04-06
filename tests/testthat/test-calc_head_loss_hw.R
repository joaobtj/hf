test_that("calc_head_loss_hw calculates correctly based on formula", {
  # Expected value calculated manually/formulaic approach
  # L = 100, Q = 0.02, D = 0.1, C = 140
  expected_loss <- 10.67 * 100 * (0.02 / 140)^1.852 / (0.1^4.87)

  result <- calc_head_loss_hw(
    length = 100,
    flow = 0.02,
    diameter = 0.1,
    coef = 140
  )

  # Tolerance is important for floating-point arithmetic
  expect_equal(result, expected_loss, tolerance = 1e-5)
})

test_that("calc_head_loss_hw handles vectorized inputs", {
  lengths <- c(50, 100)
  results <- calc_head_loss_hw(length = lengths, flow = 0.02, diameter = 0.1)
  expect_length(results, 2)
})
