test_that("calc_diameter_darcy reverses head loss correctly", {
  # Calculate head loss for a known diameter (D = 0.1)
  known_loss <- calc_head_loss_darcy(
    length = 100, flow = 0.02, diameter = 0.1, roughness = 0.00026
  )

  # Use the loss to see if the iterative function finds the original diameter of 0.1
  calc_diam <- calc_diameter_darcy(
    loss = known_loss, length = 100, flow = 0.02, roughness = 0.00026
  )

  expect_equal(calc_diam, 0.1, tolerance = 1e-5)
})
