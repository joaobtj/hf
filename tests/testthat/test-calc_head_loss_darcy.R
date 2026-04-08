test_that("calc_head_loss_darcy calculates correctly with default method (Colebrook-White)", {
  # L = 100, Q = 0.02, D = 0.1, roughness = 0.00026
  result <- calc_head_loss_darcy(
    length = 100, flow = 0.02, diameter = 0.1, roughness = 0.00026
  )

  # The expected head loss for these values is approximately 8.56 meters
  expect_type(result, "double")
  expect_true(result > 8.5 && result < 8.6)
})

test_that("calc_head_loss_darcy accepts Swamee-Jain function injection", {
  # Test with Swamee-Jain through functional injection
  result_sj <- calc_head_loss_darcy(
    length = 100, flow = 0.02, diameter = 0.1, roughness = 0.00026,
    friction_fun = calc_friction_sj
  )

  # The result with Swamee-Jain should be very close to Colebrook-White
  expect_type(result_sj, "double")
  expect_true(result_sj > 8.5 && result_sj < 8.6)
})

test_that("calc_head_loss_darcy accepts friction factor directly", {
  # Passing f = 0.02 directly, the loss should be exactly the calculated math
  f <- 0.02
  expected <- f * (8 * 100 * 0.02^2) / (pi^2 * 9.81 * 0.1^5)

  result <- calc_head_loss_darcy(
    length = 100, flow = 0.02, diameter = 0.1, friction_factor = f
  )

  expect_equal(result, expected, tolerance = 1e-5)
})
