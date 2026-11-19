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

    selectInput("flow_unit", "Flow Rate Unit",
                choices = c("m³/s"  = "m3/s",
                            "m³/h"  = "m3/h",
                            "m³/min"= "m3/min",
                            "L/s"   = "L/s",
                            "L/min" = "L/min",
                            "L/h"   = "L/h"),
                selected = "m3/s"),

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
      numericInput("flow", "Flow Rate (m³/s)", value = 0.02, min = 0.0001)
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

  # Guarda a unidade anterior para converter o valor do input$flow ao trocar de unidade
  prev_unit <- reactiveVal("m3/s")

  unit_label <- reactive({
    switch(input$flow_unit,
           "m3/s"   = "m³/s",
           "m3/h"   = "m³/h",
           "m3/min" = "m³/min",
           "L/s"    = "L/s",
           "L/min"  = "L/min",
           "L/h"    = "L/h",
           input$flow_unit)
  })

  # Converte o valor numérico do campo 'flow' automaticamente quando o usuário muda 'flow_unit'
  observeEvent(input$flow_unit, {
    old_u <- prev_unit()
    new_u <- input$flow_unit
    if (old_u != new_u && !is.null(input$flow) && !is.na(input$flow)) {
      factors <- c(
        "m3/s" = 1, "m3/min" = 1/60, "m3/h" = 1/3600,
        "L/s" = 1e-3, "L/min" = 1e-3/60, "L/h" = 1e-3/3600
      )
      q_m3s <- input$flow * factors[[old_u]]
      new_q <- signif(q_m3s / factors[[new_u]], 4)
      updateNumericInput(
        session, "flow",
        label = paste0("Flow Rate (", unit_label(), ")"),
        value = new_q
      )
    } else {
      updateNumericInput(
        session, "flow",
        label = paste0("Flow Rate (", unit_label(), ")")
      )
    }
    prev_unit(new_u)
  }, ignoreInit = TRUE)

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

  calc_hl <- function(l, q, d, u = input$flow_unit) {
    if (input$eq_type == "hw") {
      calc_head_loss_hw(length = l, flow = q, diameter = d, coef = input$c_coef, flow_unit = u)
    } else if (input$eq_type == "fl") {
      calc_head_loss_flamant(length = l, flow = q, diameter = d, coef = input$b_coef, flow_unit = u)
    } else {
      calc_head_loss_darcy(length = l, flow = q, diameter = d, roughness = input$roughness,
                           friction_fun = get_f_fun(), flow_unit = u)
    }
  }

  sys_calc <- reactive({
    req(input$length > 0, input$flow_unit)
    if (input$target_var != "loss") req(input$head_loss > 0)
    if (input$target_var != "diameter") req(input$diameter > 0)
    if (input$target_var != "flow") req(input$flow > 0)

    f_val <- NA
    u <- input$flow_unit

    if (input$eq_type == "hw") {
      req(input$c_coef > 0)
      val <- switch(
        input$target_var,
        "loss" = calc_hl(input$length, input$flow, input$diameter, u),
        "flow" = calc_flow_hw(loss = input$head_loss, length = input$length, diameter = input$diameter, coef = input$c_coef, flow_unit = u),
        "diameter" = calc_diameter_hw(loss = input$head_loss, length = input$length, flow = input$flow, coef = input$c_coef, flow_unit = u)
      )
    } else if (input$eq_type == "fl") {
      req(input$b_coef > 0)
      val <- switch(
        input$target_var,
        "loss" = calc_hl(input$length, input$flow, input$diameter, u),
        "flow" = calc_flow_flamant(loss = input$head_loss, length = input$length, diameter = input$diameter, coef = input$b_coef, flow_unit = u),
        "diameter" = calc_diameter_flamant(loss = input$head_loss, length = input$length, flow = input$flow, coef = input$b_coef, flow_unit = u)
      )
    } else {
      req(input$roughness >= 0)
      val <- switch(
        input$target_var,
        "loss" = calc_hl(input$length, input$flow, input$diameter, u),
        "flow" = calc_flow_darcy(loss = input$head_loss, length = input$length, diameter = input$diameter, roughness = input$roughness, friction_fun = get_f_fun(), flow_unit = u),
        "diameter" = calc_diameter_darcy(loss = input$head_loss, length = input$length, flow = input$flow, roughness = input$roughness, friction_fun = get_f_fun(), flow_unit = u)
      )

      q_op <- if (input$target_var == "flow") val else input$flow
      hl_op <- if (input$target_var == "loss") val else input$head_loss
      d_op <- if (input$target_var == "diameter") val else input$diameter

      # Converte q_op para m3/s para calcular a velocidade real e recuperar f
      factors <- c(
        "m3/s" = 1, "m3/min" = 1/60, "m3/h" = 1/3600,
        "L/s" = 1e-3, "L/min" = 1e-3/60, "L/h" = 1e-3/3600
      )
      q_m3s <- q_op * factors[[u]]
      area <- pi * (d_op / 2)^2
      vel <- q_m3s / area
      f_val <- (hl_op * d_op * 2 * 9.81) / (input$length * vel^2)
    }

    list(
      result = val,
      op_flow = if (input$target_var == "flow") val else input$flow,
      op_loss = if (input$target_var == "loss") val else input$head_loss,
      op_diam = if (input$target_var == "diameter") val else input$diameter,
      f_val = f_val
    )
  })

  output$calc_result <- renderText({
    res <- sys_calc()$result
    unit <- switch(
      input$target_var,
      "loss" = " m",
      "flow" = paste0(" ", unit_label()),
      "diameter" = " m"
    )
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

    flow_seq <- seq(op$op_flow * 0.1, op$op_flow * 2, length.out = 100)
    y_seq <- calc_hl(input$length, flow_seq, op$op_diam, input$flow_unit)

    par(mar = c(5, 5, 2, 2))
    plot(flow_seq, y_seq, type = "l", lwd = 3, col = "#2C3E50",
         xlab = paste0("Flow Rate (", unit_label(), ")"),
         ylab = "Head Loss (m)",
         ylim = c(0, max(y_seq) * 1.1),
         bty = "l", las = 1, cex.lab = 1.2, cex.axis = 1.1)

    points(op$op_flow, op$op_loss, pch = 19, col = "#E74C3C", cex = 2)
    text(op$op_flow, op$op_loss, labels = "Operating Point", pos = 3, offset = 1, col = "#E74C3C", font = 2)
  })

  output$plot_diam <- renderPlot({
    req(sys_calc())
    op <- sys_calc()

    diam_seq <- seq(op$op_diam * 0.5, op$op_diam * 2, length.out = 100)
    y_seq <- calc_hl(input$length, op$op_flow, diam_seq, input$flow_unit)

    par(mar = c(5, 5, 2, 2))
    plot(diam_seq, y_seq, type = "l", lwd = 3, col = "#8E44AD",
         xlab = "Pipe Diameter (m)", ylab = "Head Loss (m)",
         ylim = c(0, max(y_seq) * 1.1),
         bty = "l", las = 1, cex.lab = 1.2, cex.axis = 1.1)

    points(op$op_diam, op$op_loss, pch = 19, col = "#E74C3C", cex = 2)
    text(op$op_diam, op$op_loss, labels = "Operating Point", pos = 3, offset = 1, col = "#E74C3C", font = 2)
  })
}

shinyApp(ui, server)
