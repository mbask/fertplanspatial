# Type-safe assertions ----------------------------------------------------

#' @importFrom ensurer ensures_that
is_character <-
  ensurer::ensures_that(is.character(.) ~ "vector must be of character type.")

is_list <-
  ensurer::ensures_that(is.list(.) ~ "expecting a list type.")

is_numeric <-
  ensurer::ensures_that(is.numeric(.) ~ "vector must be of numeric type.")

is_df <-
  ensurer::ensures_that(is.data.frame(.) ~ "table must be a proper data.frame object.")


is_spdf <-
  ensurer::ensures_that("SpatialPointsDataFrame" %in% class(.) ~ "table must be of SpatialPointsDataFrame class from package sp.")

is_sp <-
  ensurer::ensures_that("SpatialPoints" %in% class(.) ~ "table must be of SpatialPoints class from package sp.")

is_formula <-
  ensurer::ensures_that(class(.) == "formula" ~ "character vector must be of formula type.")

is_variogram_model <-
  ensurer::ensures_that("variogramModel" %in% class(.) ~ "object should be a variogram model.")

`: numeric` <-
  ensurer::ensures_that(is.numeric(.) ~ "this function should return a vector numeric type.")

`: dt` <-
  ensurer::ensures_that(is.data.table(.) ~ "this function should return a data.table type.")

`: variogram_list` <-
  ensurer::ensures_that(is.list(.), length(.) == 2, "gstatVariogram" %in% class(.[[1]]), "variogramModel" %in% class(.[[2]]) ~ "this function should return a gstatVariogram, variogramModel list.")

`: spdf_list` <-
  ensurer::ensures_that(is.list(.), all(unlist(lapply(., class)) == "SpatialPointsDataFrame") ~ "this function should return a list of SpatialPointsDataFrame elements.")

`: spdf` <-
  ensurer::ensures_that("SpatialPointsDataFrame" %in% class(.) ~ "this function should return a SpatialPointsDataFrame class object from package sp.")



# Package-wide assertions -------------------------------------------------

is_positive <-
  ensurer::ensures_that(. > 0 ~ "numeric value should be positive")

is_in_variogram_models <-
  ensurer::ensures_that(. %in% c("auto", as.character(gstat::vgm()$short)) ~ "variogram model not found.")

are_obs_in_table <-
  ensurer::ensures_that(nrow(.) > 0 ~ "table has no observations.")

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
#'  * **expected_yield_kg_ha**, Expected crop yield, `integer`
#'  * **prev_crop**, Soil clay content, `character`
#'  * **texture**, Soil texture from (one of "Sandy", "Loam", "Clayey"), `character`
#'  * **drainage_rate**, Rate of drainage in soil (either "fast", "normal", "slow", "no drainage"), `character`
#'  * **oct_jan_pr_mm**, cumulative precipitation in mm in the 4 months-period October - January, `integer`
#'  * **n_supply_prev_frt_kg_ha**, Supply from organic fertilizations, `integer`
#'  * **organic_fertilizer**, Type of organic fertilizer used, `character`
#'  * **years_ago** * Time since last organic fertilization, `integer`
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
#'  * **expected_yield_kg_ha**, Expected crop yield, `integer`
#'  * **texture**, Soil texture from (one of "Sandy", "Loam", "Clayey"), `character`
#'  * **soil_depth_cm**, depth of soil tillage practise, `integer`
#'
#' Templates for **Potassium** nutrient:
#'
#' `soils_l`:
#'  * **K_ppm**, Potassium in soil in ppm (mg/kg), `numeric`
#'  * **Clay_pc**, Soil clay content, `numeric`
#'
#' `vars_l`:
#'  * **crop**, The crop name to be sown, `character`
#'  * **expected_yield_kg_ha**, Expected crop yield, `integer`
#'  * **texture**, Soil texture from (one of "Sandy", "Loam", "Clayey"), `character`
#'  * **soil_depth_cm**, depth of soil tillage practise, `integer`
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
      expected_yield_kg_ha    = integer(0),
      prev_crop               = character(0),
      texture                 = character(0),
      drainage_rate           = character(),
      oct_jan_pr_mm           = integer(0),
      n_supply_prev_frt_kg_ha = integer(0),
      organic_fertilizer      = character(0),
      years_ago               = integer(0),
      n_supply_atm_coeff      = numeric(0)),
    p = data.table::data.table(
      crop                 = character(0),
      crop_class           = character(0),
      expected_yield_kg_ha = integer(0),
      texture              = character(0),
      soil_depth_cm        = integer(0)),
    k = data.table::data.table(
      crop                 = character(0),
      expected_yield_kg_ha = integer(0),
      texture              = character(0),
      soil_depth_cm        = integer(0))))




