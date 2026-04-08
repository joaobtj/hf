test_that("calc_flow_darcy reverses head loss correctly", {
  # First, calculate head loss for a known flow (Q = 0.02)
  known_loss <- calc_head_loss_darcy(
    length = 100, flow = 0.02, diameter = 0.1, roughness = 0.00026
  )

  # Use that loss to see if the function finds the original flow back
  calc_flow <- calc_flow_darcy(
    loss = known_loss, length = 100, diameter = 0.1, roughness = 0.00026
  )

  # The calculated flow should be exactly 0.02
  expect_equal(calc_flow, 0.02, tolerance = 1e-5)
})

test_that("calc_flow_darcy works with Swamee-Jain injection", {
  # Calculate known loss using Swamee-Jain
  known_loss_sj <- calc_head_loss_darcy(
    length = 100, flow = 0.02, diameter = 0.1, roughness = 0.00026,
    friction_fun = calc_friction_sj
  )

  # Inject Swamee-Jain to find the flow
  calc_flow_sj <- calc_flow_darcy(
    loss = known_loss_sj, length = 100, diameter = 0.1, roughness = 0.00026,
    friction_fun = calc_friction_sj
  )

  expect_equal(calc_flow_sj, 0.02, tolerance = 1e-5)
})
