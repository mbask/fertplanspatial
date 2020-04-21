#' Title
#'
#' More informations on soil properties and other variables related to the crop and the environment can be found in \code{\link{templates_l}}, in package \code{fertplan} help pages and vignettes and in the guideline of Region Lazio.
#'
#' @param soil_dt     a \code{data.table} of soil properties (columns) x soil samples (rows). Its features (soil analyses) depend on the nutrient fertilization specificed in \code{nutrient} parameter
#' @param vars        a \code{list} of variables shared between soil samples. The specific analyses depend on the nutrient fertilization specified in \code{nutrient} parameter
#' @param nutrient    a character vector detailing which nutrient fertilization plan to compute among "nitrogen", "phosphorus", and "potassium". Any combination of the three nutrients can be given or "All" (default) to computeall of them.
#'
#' @return            a \code{data.table} with as many features as nutrients given as \code{nutrient} parameter and as many rows as soil properties given as \code{soil_dt} parameter.
#' @export
#' @importFrom ensurer ensure_that
#' @importFrom data.table setDT
#' @importFrom data.table data.table
#' @importFrom data.table `:=`
#' @seealso \code{fertplan} package.
#' @seealso Assessorato Agricoltura, Promozione della Filiera e della Cultura del Cibo, Ambiente e Risorse Naturali. 2020. “Parte Agronomica, Norme Generali, Disciplinare Di Produzione Integrata Della Regione Lazio - SQNPI.” Regione Lazio. \url{http://www.regione.lazio.it/rl_agricoltura/?vw=documentazioneDettaglio&id=52065}.
demand_nutrient <- function(soil_dt, vars, nutrient = "all") `: dt` ({

  ensurer::ensures_that(soil_dt, is.data.frame(.) ~ "not a proper table.")
  is_list(vars)
  is_character(nutrient)

  if ("all" %in% nutrient) {
    nutrient <- c("nitrogen", "phosphorus", "potassium")
  }

  # setup variables and return table
  # for computing nutrient fertilization concentrations
  data.table::setDT(vars)
  ntrt_results_dt <- data.table::data.table()
  # prevent "no visible binding for global variable" NOTE
  ..tbl_col_names <- ..vars_col_names <- NULL

  # nitrogen
  if ("nitrogen" %in% nutrient) {
    tbl_col_names <- names(templates_l$soils_l$n)
    soil_n_dt     <- soil_dt[, ..tbl_col_names]
    ensure_as_template(soil_n_dt, templates_l$soils_l$n)

    vars_col_names <- names(templates_l$vars_l$n)
    vars_n_dt      <- vars[, ..vars_col_names]
    ensure_as_template(vars_n_dt, templates_l$vars_l$n)

    nitrogen <- NULL
    ntrt_results_dt[, nitrogen := demand_nitrogen(cbind(soil_n_dt, vars_n_dt))]
  }

  # phosphorus
  if ("phosphorus" %in% nutrient) {
    tbl_col_names <- names(templates_l$soils_l$p)
    soil_p_dt     <- soil_dt[, ..tbl_col_names]
    ensure_as_template(soil_p_dt, templates_l$soils_l$p)

    vars_col_names <- names(templates_l$vars_l$p)
    vars_p_dt      <- vars[, ..vars_col_names]
    ensure_as_template(vars_p_dt, templates_l$vars_l$p)

    phosphorus <- NULL
    ntrt_results_dt[, phosphorus := demand_phosphorus(cbind(soil_p_dt, vars_p_dt))]
  }

  # potassium
  if ("potassium" %in% nutrient) {
    tbl_col_names <- names(templates_l$soils_l$k)
    soil_k_dt     <- soil_dt[, ..tbl_col_names]
    ensure_as_template(soil_k_dt, templates_l$soils_l$k)

    vars_col_names <- names(templates_l$vars_l$k)
    vars_k_dt      <- vars[, ..vars_col_names]
    ensure_as_template(vars_k_dt, templates_l$vars_l$k)

    potassium <- NULL
    ntrt_results_dt[, potassium := demand_potassium(cbind(soil_k_dt, vars_k_dt))]
  }
  ntrt_results_dt
})