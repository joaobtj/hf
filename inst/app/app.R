# Configure repositories for WebAssembly (Shinylive)
options(repos = c(
  joaobtj = "https://joaobtj.r-universe.dev",
  CRAN = "https://cloud.r-project.org"
))

library(shiny)
library(bslib)
library(hf)

ui <- page_sidebar(
  title = "hf: Hydraulic Calculator",
  theme = bs_theme(bootswatch = "flatly", primary = "#2C3E50"),

  sidebar = sidebar(
    width = 350,
    title = "Calculation Settings",

    selectInput("target_var", "Target Variable",
                choices = c("Head Loss" = "loss",
                            "Flow Rate" = "flow",
                            "Diameter" = "diameter")),

    selectInput("eq_type", "Equation",
                choices = c("Darcy-Weisbach" = "dw", "Hazen-Williams" = "hw"),
                selected = "dw"),

    conditionalPanel(
      condition = "input.eq_type == 'dw'",
      selectInput("f_method", "Friction Factor Method",
                  choices = c("Colebrook-White (Exact)" = "cw",
                              "Swamee-Jain (Fast)" = "sj"))
    ),

    hr(),

    numericInput("length", "Length (m)", value = 100, min = 1),

    conditionalPanel(
      condition = "input.target_var != 'loss'",
      numericInput("head_loss", "Head Loss (m)", value = 8.5, min = 0.01)
    ),

    conditionalPanel(
      condition = "input.target_var != 'diameter'",
      numericInput("diameter", "Diameter (m)", value = 0.1, min = 0.01)
    ),

    conditionalPanel(
      condition = "input.target_var != 'flow'",
      numericInput("flow", "Flow Rate (m³/s)", value = 0.02, min = 0.001)
    ),

    conditionalPanel(
      condition = "input.eq_type == 'hw'",
      numericInput("c_coef", "Roughness Coefficient (C)", value = 140)
    ),

    conditionalPanel(
      condition = "input.eq_type == 'dw'",
      numericInput("roughness", "Absolute Roughness (m)", value = 0.00026, step = 0.00001)
    )
  ),

  layout_columns(
    col_widths = c(4, 8),

    # Left column: Calculation Result Box
    div(
      value_box(
        title = uiOutput("box_title"),
        value = textOutput("calc_result"),
        showcase = bsicons::bs_icon("calculator"),
        theme = "primary"
      )
    ),

    # Right column: Stacked Plots using a nested layout
    layout_columns(
      col_widths = 12,
      card(
        card_header("System Curve (Head Loss vs. Flow Rate)"),
        plotOutput("plot_sys", height = "350px")
      ),
      card(
        card_header("Friction Sensitivity (Head Loss vs. Pipe Diameter)"),
        plotOutput("plot_diam", height = "350px")
      )
    )
  )
)

server <- function(input, output, session) {

  output$box_title <- renderUI({
    switch(input$target_var,
           "loss" = "Calculated Head Loss",
           "flow" = "Calculated Flow Rate",
           "diameter" = "Required Diameter")
  })

  sys_calc <- reactive({
    req(input$length)
    if (input$target_var != "loss") req(input$head_loss)
    if (input$target_var != "diameter") req(input$diameter)
    if (input$target_var != "flow") req(input$flow)

    if (input$eq_type == "hw") {
      req(input$c_coef)
      val <- switch(input$target_var,
                    "loss" = calc_head_loss_hw(length = input$length, flow = input$flow, diameter = input$diameter, coef = input$c_coef),
                    "flow" = calc_flow_hw(loss = input$head_loss, length = input$length, diameter = input$diameter, coef = input$c_coef),
                    "diameter" = calc_diameter_hw(loss = input$head_loss, length = input$length, flow = input$flow, coef = input$c_coef))
    } else {
      req(input$roughness)
      f_fun <- if (input$f_method == "cw") calc_friction_cw else calc_friction_sj
      val <- switch(input$target_var,
                    "loss" = calc_head_loss_darcy(length = input$length, flow = input$flow, diameter = input$diameter, roughness = input$roughness, friction_fun = f_fun),
                    "flow" = calc_flow_darcy(loss = input$head_loss, length = input$length, diameter = input$diameter, roughness = input$roughness, friction_fun = f_fun),
                    "diameter" = calc_diameter_darcy(loss = input$head_loss, length = input$length, flow = input$flow, roughness = input$roughness, friction_fun = f_fun))
    }

    list(
      result = val,
      op_flow = if(input$target_var == "flow") val else input$flow,
      op_loss = if(input$target_var == "loss") val else input$head_loss,
      op_diam = if(input$target_var == "diameter") val else input$diameter
    )
  })

  output$calc_result <- renderText({
    res <- sys_calc()$result
    unit <- switch(input$target_var, "loss" = " m", "flow" = " m³/s", "diameter" = " m")
    paste0(round(res, 4), unit)
  })

  # PLOT 1: System Curve (Flow vs. Head Loss)
  output$plot_sys <- renderPlot({
    req(sys_calc())
    op <- sys_calc()

    flow_seq <- seq(0.001, op$op_flow * 2, length.out = 100)

    if (input$eq_type == "hw") {
      y_seq <- calc_head_loss_hw(length = input$length, flow = flow_seq, diameter = op$op_diam, coef = input$c_coef)
    } else {
      f_fun <- if (input$f_method == "cw") calc_friction_cw else calc_friction_sj
      y_seq <- calc_head_loss_darcy(length = input$length, flow = flow_seq, diameter = op$op_diam, roughness = input$roughness, friction_fun = f_fun)
    }

    par(mar = c(5, 5, 2, 2))
    plot(flow_seq, y_seq, type = "l", lwd = 3, col = "#2C3E50",
         xlab = expression("Flow Rate" ~ (m^3/s)), ylab = "Head Loss (m)",
         bty = "l", las = 1, cex.lab = 1.2, cex.axis = 1.1)

    points(op$op_flow, op$op_loss, pch = 19, col = "#E74C3C", cex = 2)
    text(op$op_flow, op$op_loss, labels = "Operating Point", pos = 3, offset = 1, col = "#E74C3C", font = 2)
  })

  # PLOT 2: Friction Sensitivity (Diameter vs. Head Loss)
  output$plot_diam <- renderPlot({
    req(sys_calc())
    op <- sys_calc()

    diam_seq <- seq(op$op_diam * 0.5, op$op_diam * 2, length.out = 100)

    if (input$eq_type == "hw") {
      y_seq <- calc_head_loss_hw(length = input$length, flow = op$op_flow, diameter = diam_seq, coef = input$c_coef)
    } else {
      f_fun <- if (input$f_method == "cw") calc_friction_cw else calc_friction_sj
      y_seq <- calc_head_loss_darcy(length = input$length, flow = op$op_flow, diameter = diam_seq, roughness = input$roughness, friction_fun = f_fun)
    }

    par(mar = c(5, 5, 2, 2))
    plot(diam_seq, y_seq, type = "l", lwd = 3, col = "#8E44AD",
         xlab = "Pipe Diameter (m)", ylab = "Head Loss (m)",
         bty = "l", las = 1, cex.lab = 1.2, cex.axis = 1.1)

    points(op$op_diam, op$op_loss, pch = 19, col = "#E74C3C", cex = 2)
    text(op$op_diam, op$op_loss, labels = "Operating Point", pos = 3, offset = 1, col = "#E74C3C", font = 2)
  })
}

shinyApp(ui, server)
