# Type-safe assertions ----------------------------------------------------

#' @importFrom ensurer ensures_that
is_character <-
  ensurer::ensures_that(is.character(.) ~ "vector must be of character type.")

is_list <-
  ensurer::ensures_that(is.list(.) ~ "expecting a list type.")

is_numeric <-
  ensurer::ensures_that(is.numeric(.) ~ "vector must be of numeric type.")

`: numeric` <-
  ensurer::ensures_that(is.numeric(.) ~ "this function should return a vector numeric type.")

`: dt` <-
  ensurer::ensures_that(is.data.table(.) ~ "this function should return a data.table type.")



# Package-wide assertions -------------------------------------------------

# Ensure a table conforms to a table template
#
# Check that a \code{data.frame} or \code{data.table} has specific columns,
# types, etc, given in a template. If it does not stop program execution with an error.
#
# \code{ensure_as_template} uses \code{ensurer::ensure_that} in the
# background to ensure conditions for a value "on the fly"
#
# @param x   a \code{data.frame} or \code{data.table} to be checked
# @param tpl a \code{data.frame} as  templated to be used to check \code{x}
#
# @return    the \code{x} value itself on success
ensure_as_template <- function(x, tpl) {
  . <- NULL
  ensurer::ensure_that(
    x,
    is.data.frame(.),
    identical(class(.), class(tpl)),
    identical(sapply(., class), sapply(tpl, class)),
    identical(sapply(., levels), sapply(tpl, levels)))
}


#' Data templates for soil and vars
#'
#' @md
#' @format A list of two elements, `soils_l` and `vars_l`. Both of
#' them are lists of three elements each: \code{n}, \code{p}, \code{k}.
#' Each nutrient element holds an empty table template that is used to ensure the data object
#' passed as argument to [demand_nutrient()] function is correct as far as class of the
#' entire object (eg \code{data.table}), name and class of each feature (column, eg `numeric`,
#' `character`) are concerned.
#'
#' The data object are passed to appropriate \code{fertplan} functions by [demand_nutrient()],
#' further information on features (soil and vars), and their unit of measure can be found in
#' help pages and vignettes of the \code{fertplan} package.
#'
#' Templates for **Nitrogen** nutrient:
#'
#' `soils_l`:
#'  * **N_pc**, Percentage of nitrogen in soil, `numeric`
#'  * **CNR**, Soil carbon / nitrogen ratio, `numeric`
#'  * **SOM_pc**, Soil Organic Matter percentage, `numeric`
#'  * **Clay_pc**, Soil clay content, `numeric`
#'
#' `vars_l`:
#'  * **crop**, The crop name to be sown, `character`
#'  * **crop_type**, The crop type to be sown, `character`
#'  * **expected_yield_kg_ha**, Expected crop yield, `numeric`
#'  * **prev_crop**, Soil clay content, `character`
#'  * **texture**, Soil texture from (one of "Sandy", "Loam", "Clayey"), `character`
#'  * **drainage_rate**, Rate of drainage in soil (either "fast", "normal", "slow", "no drainage"), `character`
#'  * **oct_jan_2019_pr_mm**, cumulative precipitation in mm in the 4 months-period October - January, `numeric`
#'  * **n_supply_prev_frt_kg_ha**, Supply from organic fertilizations, `numeric`
#'  * **n_supply_atm_coeff**, A ratio to correct the N from atmosphere, `numeric`
#'
#' Templates for **Phosphorus** nutrient:
#'
#' `soils_l`:
#'  * **P_ppm**, Phosphorus in soil in ppm (mg/kg), `numeric`
#'  * **Limestone_pc**, Calcium in soil in percentage, `numeric`
#'
#' `vars_l`:
#'  * **crop**, The crop name to be sown, `character`
#'  * **crop_class**, The class of crop to be sown, `character`
#'  * **expected_yield_kg_ha**, Expected crop yield, `numeric`
#'  * **texture**, Soil texture from (one of "Sandy", "Loam", "Clayey"), `character`
#'  * **soil_depth_cm**, depth of soil tillage practise, `numeric`
#'
#' Templates for **Potassium** nutrient:
#'
#' `soils_l`:
#'  * **K_ppm**, Potassium in soil in ppm (mg/kg), `numeric`
#'  * **Clay_pc**, Soil clay content, `numeric`
#'
#' `vars_l`:
#'  * **crop**, The crop name to be sown, `character`
#'  * **expected_yield_kg_ha**, Expected crop yield, `numeric`
#'  * **texture**, Soil texture from (one of "Sandy", "Loam", "Clayey"), `character`
#'  * **soil_depth_cm**, depth of soil tillage practise, `numeric`
templates_l <- list(
  soils_l = list(
    n = data.table::data.table(
      N_pc    = numeric(0),
      CNR     = numeric(0),
      SOM_pc  = numeric(0),
      Clay_pc = numeric(0)),
    p = data.table::data.table(
      P_ppm        = numeric(0),
      Limestone_pc = numeric(0)),
    k = data.table::data.table(
      K_ppm   = numeric(0),
      Clay_pc = numeric(0))),
  vars_l = list(
    n = data.table::data.table(
      crop                    = character(0),
      crop_type               = character(0),
      expected_yield_kg_ha    = numeric(0),
      prev_crop               = character(0),
      texture                 = character(0),
      drainage_rate           = character(),
      oct_jan_pr_mm           = numeric(0),
      n_supply_prev_frt_kg_ha = numeric(0),
      n_supply_atm_coeff      = numeric(0)),
    p = data.table::data.table(
      crop                 = character(0),
      crop_class           = character(0),
      expected_yield_kg_ha = numeric(0),
      texture              = character(0),
      soil_depth_cm        = numeric(0)),
    k = data.table::data.table(
      crop                 = character(0),
      expected_yield_kg_ha = numeric(0),
      texture              = character(0),
      soil_depth_cm        = numeric(0))))




