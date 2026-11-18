#' @title Convert Volumetric Flow Rate Units
#'
#' @description Internal helper to convert volumetric flow rates between cubic
#' meters per second (`"m3/s"`) and other common hydraulic units (Liters or
#' cubic meters per second, minute, hour, or day).
#'
#' @param flow Numeric. Volumetric flow rate value(s).
#' @param flow_unit Character. The flow unit (e.g., `"m3/s"`, `"m3/h"`, `"L/s"`,
#'   `"L/min"`, `"L/h"`). Default is `"m3/s"`.
#' @param to_m3s Logical. If `TRUE`, converts from `flow_unit` to `"m3/s"`.
#'   If `FALSE`, converts from `"m3/s"` back to `flow_unit`.
#'
#' @return A numeric vector with the converted flow rate.
#' @keywords internal
#' @noRd
convert_flow_unit <- function(flow, flow_unit = "m3/s", to_m3s = TRUE) {
  if (length(flow_unit) != 1 || !is.character(flow_unit)) {
    stop("'flow_unit' must be a single character string (e.g., 'm3/s', 'L/s', 'm3/h', 'L/h').", call. = FALSE)
  }

  # Normaliza a string: minúsculas, sem espaços, troca '³' por '3' e 'p' (ex: lps) por '/'
  u <- tolower(trimws(flow_unit))
  u <- gsub("\u00b3", "3", u)
  u <- gsub("liters|liter|litros|litro", "l", u)
  u <- gsub("^(l|m3)p(s|min|h|d)$", "\\1/\\2", u)
  u <- gsub("^(l|m3)(s|min|h|d)$", "\\1/\\2", u)

  # Fator multiplicador para converter 1 unidade para m3/s
  factor_to_m3s <- switch(u,
    "m3/s" = 1,
    "m3/min" = 1 / 60,
    "m3/h" = 1 / 3600,
    "m3/d" = 1 / 86400,
    "l/s" = 1e-3,
    "l/min" = 1e-3 / 60,
    "l/h" = 1e-3 / 3600,
    "l/d" = 1e-3 / 86400,
    stop(
      sprintf(
        "Invalid 'flow_unit': '%s'. Supported units are: 'm3/s', 'm3/min', 'm3/h', 'm3/d', 'L/s', 'L/min', 'L/h', 'L/d'.",
        flow_unit
      ),
      call. = FALSE
    )
  )

  if (to_m3s) {
    return(flow * factor_to_m3s)
  } else {
    return(flow / factor_to_m3s)
  }
}
