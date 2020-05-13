# Data templates for soil and vars
#
# @format A list of two elements, `soils_l` and `vars_l`. Both of
# them are lists of three elements each: \code{n}, \code{p}, \code{k}.
# Each nutrient element holds an empty table template that is used to ensure the data object
# passed as argument to [demand_nutrient()] function is correct as far as class of the
# entire object (eg \code{data.table}), name and class of each feature (column, eg `numeric`,
# `character`) are concerned.
templates_l <- list(
  soils_l = list(
    nitrogen = data.table::data.table(
      N_pc    = numeric(0),
      CNR     = numeric(0),
      SOM_pc  = numeric(0),
      Clay_pc = numeric(0)),
    phosphorus = data.table::data.table(
      P_ppm        = numeric(0),
      Limestone_pc = numeric(0)),
    potassium = data.table::data.table(
      K_ppm   = numeric(0),
      Clay_pc = numeric(0))),
  vars_l = list(
    nitrogen = data.table::data.table(
      crop                    = character(0),
      part                    = character(0),
      crop_type               = character(0),
      expected_yield_kg_ha    = integer(0),
      prev_crop               = character(0),
      texture                 = character(0),
      drainage_rate           = character(),
      oct_jan_pr_mm           = integer(0),
      n_supply_prev_frt_kg_ha = integer(0),
      organic_fertilizer      = character(0),
      years_ago               = integer(0),
      n_supply_atm_coeff      = numeric(0)),
    phosphorus = data.table::data.table(
      crop                 = character(0),
      part                 = character(0),
      crop_class           = character(0),
      expected_yield_kg_ha = integer(0),
      texture              = character(0),
      soil_depth_cm        = integer(0)),
    potassium = data.table::data.table(
      crop                 = character(0),
      part                 = character(0),
      expected_yield_kg_ha = integer(0),
      texture              = character(0),
      soil_depth_cm        = integer(0))))


#' Performs sanity checks on soil table
#'
#' The computation of nutrient fertilization plans requires
#' a few soil analyses be performed. Each nutrient fertilization plan
#' requires specific analyses, the functions checks whether these analyses
#' results are present in soil table for each specific nutrient.
#'
#' The data object are passed to appropriate \code{fertplan} functions by [demand_nutrient()],
#' further information on soil features, and their unit of measure can be found in
#' help pages and vignettes of the \code{fertplan} package.
#
#' Templates for soil tables:
#'
#' Template for **nitrogen** nutrient table:
#'
#'  * **N_pc**, Percentage of nitrogen in soil, `numeric`
#'  * **CNR**, Soil carbon / nitrogen ratio, `numeric`
#'  * **SOM_pc**, Soil Organic Matter percentage, `numeric`
#'  * **Clay_pc**, Soil clay content, `numeric`
#'
#'
#' Template for **phosphorus** nutrient table:
#'
#'  * **P_ppm**, Phosphorus in soil in ppm (mg/kg), `numeric`
#'  * **Limestone_pc**, Calcium in soil in percentage, `numeric`
#'
#'
#' templates for **potassium** nutrient table:
#'
#'  * **K_ppm**, Potassium in soil in ppm (mg/kg), `numeric`
#'  * **Clay_pc**, Soil clay content, `numeric`
#'
#' Note that the appropriate classes of soil features
#' for each specific nutrient may be
#' looked up by passing `NULL` as `soil_dt` argument, like in
#' `check_soil_table(NULL, "potassium")`.
#'
#' @param soil_dt     A table where soil physical and chemical features needed are given or `NULL`
#' @param nutrient    One of "nitrogen", "phosphorus", "potassium"
#'
#' @return  A subset of the soil table featuring only the specific
#' analyses results for the `nutrient` given or, if `soil_dt` is `NULL`
#' a character vector of classes of the relevant soil features for each specific
#' nutrient.
#'
#' @export
#'
#' @examples
#' check_soil_table(NULL, "potassium")
#'
#' @md
check_soil_table <- function(soil_dt, nutrient) {

  ensurer::ensure(nutrient, +is_character, +is_nutrient)

  # When soil_dt is NULL than return a vector of
  # classes for the relevant nutrient
  if (is.null(soil_dt)) {
    vapply(
      templates_l$soils[[nutrient]],
      FUN = class,
      FUN.VALUE = character(1))
  } else {
    ensurer::ensure(soil_dt, +is_df, +are_obs_in_table)

    # prevent "no visible binding for global variable" NOTE
    .SD <- .SDcols <- NULL

    tbl_col_names <- names(templates_l$soils_l[[nutrient]])
    soil_dt       <- soil_dt[, .SD, .SDcols = tbl_col_names]
    ensure_as_template(soil_dt, templates_l$soils_l[[nutrient]])
  }
}



#' Performs sanity checks on soil variables
#'
#' The computation of nutrient fertilization plans requires
#' a few atmospheric, crop, and soil variables to be shared among all soil analyses.
#' Each nutrient fertilization plan
#' requires specific variables, the functions checks whether these features
#' have been filled in the appropriate variable list, for each specific nutrient.
#'
#' The data object are passed to appropriate \code{fertplan} functions by [demand_nutrient()],
#' further information on variables, and their unit of measure can be found in
#' help pages and vignettes of the \code{fertplan} package.
#
#' Variable list templates for variables:
#'
#' Template for **nitrogen** nutrient list:
#'
#'  * **crop**, The crop name to be sown, `character`
#'  * **part**, The part of interest of the crop (Frutti, Pianta, ...), `character`
#'  * **crop_type**, The crop type to be sown, `character`
#'  * **expected_yield_kg_ha**, Expected crop yield, `integer`
#'  * **prev_crop**, Soil clay content, `character`
#'  * **texture**, Soil texture (one of "Sandy", "Loam", "Clayey"), `character`
#'  * **drainage_rate**, Rate of drainage in soil (either "fast", "normal", "slow", "no drainage"), `character`
#'  * **oct_jan_pr_mm**, cumulative precipitation in mm in the 4 months-period October - January, `integer`
#'  * **n_supply_prev_frt_kg_ha**, Supply from organic fertilizations, `integer`
#'  * **organic_fertilizer**, Type of organic fertilizer used, `character`
#'  * **years_ago** * Time since last organic fertilization, `integer`
#'  * **n_supply_atm_coeff**, A ratio to correct the N from atmosphere, `numeric`
#'
#'
#' Template for **phosphorus** nutrient list:
#'
#'  * **crop**, The crop name to be sown, `character`
#'  * **part**, The part of interest of the crop (Frutti, Pianta, ...), `character`
#'  * **crop_class**, The class of crop to be sown, `character`
#'  * **expected_yield_kg_ha**, Expected crop yield, `integer`
#'  * **texture**, Soil texture (one of "Sandy", "Loam", "Clayey"), `character`
#'  * **soil_depth_cm**, depth of soil tillage practise, `integer`
#'
#'
#' Template for **potassium** nutrient list:
#'
#'  * **crop**, The crop name to be sown, `character`
#'  * **part**, The part of interest of the crop (Frutti, Pianta, ...), `character`
#'  * **crop_class**, The class of crop to be sown, `character`
#'  * **expected_yield_kg_ha**, Expected crop yield, `integer`
#'  * **texture**, Soil texture (one of "Sandy", "Loam", "Clayey"), `character`
#'  * **soil_depth_cm**, depth of soil tillage practise, `integer`
#'
#' Note that the appropriate classes of the variables
#' needed for each specific nutrient may be
#' looked up by passing `NULL` as `vars` argument, like in
#' `check_vars(NULL, "potassium")`.
#'
#' @param vars      A list where atmospheric, crop, and soil variables needed are given, or `NULL`
#' @param nutrient  One of "nitrogen", "phosphorus", "potassium"
#'
#' @return A `data.table` subset of the `vars` list featuring only the specific
#' variables for the `nutrient` given or, if `vars` is `NULL`
#' a character vector of classes of the relevant variables for each specific
#' nutrient.
#'
#' @export
#'
#' @examples
#' check_vars(NULL, "potassium")
#'

#' @md
check_vars <- function(vars = NULL, nutrient) {
  ensurer::ensure(nutrient, +is_character, +is_nutrient)

  # When vars is NULL than return a vector of
  # classes for the relevant nutrient
  if (is.null(vars)) {
    vapply(
      templates_l$vars_l[[nutrient]],
      FUN = class,
      FUN.VALUE = character(1))
  } else {
    is_list(vars)
    data.table::setDT(vars)

    # prevent "no visible binding for global variable" NOTE
    .SD <- .SDcols <- NULL

    vars_col_names <- names(templates_l$vars_l[[nutrient]])
    vars_dt        <- vars[, .SD, .SDcols = vars_col_names]
    ensure_as_template(vars_dt, templates_l$vars_l[[nutrient]])
  }
}
