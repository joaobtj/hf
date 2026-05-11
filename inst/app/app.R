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
                choices = c("Darcy-Weisbach" = "dw",
                            "Hazen-Williams" = "hw",
                            "Flamant" = "fl"),
                selected = "dw"),

    conditionalPanel(
      condition = "input.eq_type == 'dw'",
      selectInput("f_method", "Friction Factor Method",
                  choices = c("Colebrook-White (Exact)" = "cw",
                              "Haaland (Approximation)" = "ha",
                              "Swamee-Jain (Fast)" = "sj",
                              "Blasius (Smooth Pipes)" = "bl"))
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
      condition = "input.eq_type == 'fl'",
      numericInput("b_coef", "Flamant Coefficient (b)", value = 0.000135, step = 0.000001)
    ),

    conditionalPanel(
      condition = "input.eq_type == 'dw'",
      numericInput("roughness", "Absolute Roughness (m)", value = 0.00026, step = 0.00001)
    ),

    hr(),

    input_switch("show_plots", "View Charts", value = FALSE)
  ),

  layout_columns(
    col_widths = c(4, 8),

    div(
      value_box(
        title = uiOutput("box_title"),
        value = textOutput("calc_result"),
        showcase = bsicons::bs_icon("calculator"),
        theme = "primary"
      ),
      # Renderiza a caixa do fator de atrito 'f' condicionalmente
      uiOutput("f_box")
    ),

    conditionalPanel(
      condition = "input.show_plots == true",
      navset_card_underline(
        title = "System Analysis",
        nav_panel("System Curve", plotOutput("plot_sys", height = "400px")),
        nav_panel("Friction Sensitivity", plotOutput("plot_diam", height = "400px"))
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

  get_f_fun <- reactive({
    switch(input$f_method,
           "cw" = calc_friction_cw,
           "ha" = calc_friction_haaland,
           "sj" = calc_friction_sj,
           "bl" = calc_friction_blasius)
  })

  calc_hl <- function(l, q, d) {
    if (input$eq_type == "hw") {
      calc_head_loss_hw(length = l, flow = q, diameter = d, coef = input$c_coef)
    } else if (input$eq_type == "fl") {
      calc_head_loss_flamant(length = l, flow = q, diameter = d, coef = input$b_coef)
    } else {
      calc_head_loss_darcy(length = l, flow = q, diameter = d, roughness = input$roughness, friction_fun = get_f_fun())
    }
  }

  sys_calc <- reactive({
    req(input$length)
    if (input$target_var != "loss") req(input$head_loss)
    if (input$target_var != "diameter") req(input$diameter)
    if (input$target_var != "flow") req(input$flow)

    f_val <- NA # Inicializa o fator de atrito

    if (input$eq_type == "hw") {
      req(input$c_coef)
      val <- switch(input$target_var,
                    "loss" = calc_hl(input$length, input$flow, input$diameter),
                    "flow" = calc_flow_hw(loss = input$head_loss, length = input$length, diameter = input$diameter, coef = input$c_coef),
                    "diameter" = calc_diameter_hw(loss = input$head_loss, length = input$length, flow = input$flow, coef = input$c_coef))
    } else if (input$eq_type == "fl") {
      req(input$b_coef)
      val <- switch(input$target_var,
                    "loss" = calc_hl(input$length, input$flow, input$diameter),
                    "flow" = calc_flow_flamant(loss = input$head_loss, length = input$length, diameter = input$diameter, coef = input$b_coef),
                    "diameter" = calc_diameter_flamant(loss = input$head_loss, length = input$length, flow = input$flow, coef = input$b_coef))
    } else {
      req(input$roughness)
      val <- switch(input$target_var,
                    "loss" = calc_hl(input$length, input$flow, input$diameter),
                    "flow" = calc_flow_darcy(loss = input$head_loss, length = input$length, diameter = input$diameter, roughness = input$roughness, friction_fun = get_f_fun()),
                    "diameter" = calc_diameter_darcy(loss = input$head_loss, length = input$length, flow = input$flow, roughness = input$roughness, friction_fun = get_f_fun()))

      q_op <- if(input$target_var == "flow") val else input$flow
      hl_op <- if(input$target_var == "loss") val else input$head_loss
      d_op <- if(input$target_var == "diameter") val else input$diameter

      area <- pi * (d_op / 2)^2
      vel <- q_op / area
      f_val <- (hl_op * d_op * 2 * 9.81) / (input$length * vel^2)
    }

    list(
      result = val,
      op_flow = if(input$target_var == "flow") val else input$flow,
      op_loss = if(input$target_var == "loss") val else input$head_loss,
      op_diam = if(input$target_var == "diameter") val else input$diameter,
      f_val = f_val
    )
  })

  output$calc_result <- renderText({
    res <- sys_calc()$result
    unit <- switch(input$target_var, "loss" = " m", "flow" = " m³/s", "diameter" = " m")
    paste0(round(res, 4), unit)
  })

  output$f_box <- renderUI({
    res <- sys_calc()
    if (input$eq_type == "dw" && !is.na(res$f_val)) {
      div(class = "mt-3",
          value_box(
            title = "Friction Factor (f)",
            value = round(res$f_val, 5),
            showcase = bsicons::bs_icon("moisture"),
            theme = "info"
          )
      )
    }
  })

  output$plot_sys <- renderPlot({
    req(sys_calc())
    op <- sys_calc()

    flow_seq <- seq(0.001, op$op_flow * 2, length.out = 100)
    y_seq <- calc_hl(input$length, flow_seq, op$op_diam)

    par(mar = c(5, 5, 2, 2))
    plot(flow_seq, y_seq, type = "l", lwd = 3, col = "#2C3E50",
         xlab = expression("Flow Rate" ~ (m^3/s)), ylab = "Head Loss (m)",
         bty = "l", las = 1, cex.lab = 1.2, cex.axis = 1.1)

    points(op$op_flow, op$op_loss, pch = 19, col = "#E74C3C", cex = 2)
    text(op$op_flow, op$op_loss, labels = "Operating Point", pos = 3, offset = 1, col = "#E74C3C", font = 2)
  })

  output$plot_diam <- renderPlot({
    req(sys_calc())
    op <- sys_calc()

    diam_seq <- seq(op$op_diam * 0.5, op$op_diam * 2, length.out = 100)
    y_seq <- calc_hl(input$length, op$op_flow, diam_seq)

    par(mar = c(5, 5, 2, 2))
    plot(diam_seq, y_seq, type = "l", lwd = 3, col = "#8E44AD",
         xlab = "Pipe Diameter (m)", ylab = "Head Loss (m)",
         bty = "l", las = 1, cex.lab = 1.2, cex.axis = 1.1)

    points(op$op_diam, op$op_loss, pch = 19, col = "#E74C3C", cex = 2)
    text(op$op_diam, op$op_loss, labels = "Operating Point", pos = 3, offset = 1, col = "#E74C3C", font = 2)
  })
}

shinyApp(ui, server)
