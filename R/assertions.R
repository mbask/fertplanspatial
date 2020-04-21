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
#' @format A list of two elements, \code{soils_l} and \code{vars_l}. Both of
#' them are lists of three elements each: \code{n}, \code{p}, \code{k}.
#' Each nutrient element holds an empty table template that is used to ensure the data object
#' passed as argument to [demand_nutrient()] function is correct as far as class of the
#' entire object (eg \code{data.table}), name and class of each feature (column, eg \code{numeric},
#' \code{character}) are concerned.
#'
#' The data object are passed to appropriate \code{fertplan} functions by \code{demand_nutrient},
#' further information on features (soil and vars), and their unit of measure can be found in
#' help pages and vignettes of the \code{fertplan} package.
#'
#' Templates for **Nitrogen** nutrient:
#'
#' \code{soils_l}:
#' \describe{
#'   \item{N_pc}{Percentage of nitrogen in soil, \code{numeric}}
#'   \item{CNR}{Soil carbon / nitrogen ratio, \code{numeric}}
#'   \item{SOM_pc}{Soil Organic Matter percentage, \code{numeric}}
#'   \item{Clay_pc}{Soil clay content, \code{numeric}}}
#'
#' \code{vars_l}:
#' \describe{
#'   \item{crop}{The crop name to be sown, \code{character}}
#'   \item{crop_type}{The crop type to be sown, \code{character}}
#'   \item{expected_yield_kg_ha}{Expected crop yield, \code{numeric}}
#'   \item{prev_crop}{Soil clay content, \code{character}}
#'   \item{texture}{Soil texture from (one of "Sandy", "Loam", "Clayey"), \code{character}}
#'   \item{drainage_rate}{Rate of drainage in soil (either "fast", "normal", "slow", "no drainage"), \code{character}}
#'   \item{oct_jan_2019_pr_mm}{cumulative precipitation in mm in the 4 months-period October - January, \code{numeric}}
#'   \item{n_supply_prev_frt_kg_ha}{Supply from organic fertilizations, \code{numeric}}
#'   \item{n_supply_atm_coeff}{A ratio to correct the N from atmosphere, \code{numeric}}}
#'
#' Templates for **Phosphorus** nutrient:
#'
#' \code{soils_l}:
#' \describe{
#'   \item{P_ppm}{Phosphorus in soil in ppm (mg/kg), \code{numeric}}
#'   \item{Limestone_pc}{Calcium in soil in percentage, \code{numeric}}}
#'
#' \code{vars_l}:
#' \describe{
#'   \item{crop}{The crop name to be sown, \code{character}}
#'   \item{crop_B_P}{The class of crop to be sown, \code{character}}
#'   \item{expected_yield_kg_ha}{Expected crop yield, \code{numeric}}
#'   \item{texture}{Soil texture from (one of "Sandy", "Loam", "Clayey"), \code{character}}
#'   \item{soil_depth_cm}{depth of soil tillage practise, \code{numeric}}}
#'
#' Templates for **Potassium** nutrient:
#'
#' \code{soils_l}:
#' \describe{
#'   \item{K_ppm}{Potassium in soil in ppm (mg/kg), \code{numeric}}
#'   \item{Clay_pc}{Soil clay content, \code{numeric}}}
#'
#' \code{vars_l}:
#' \describe{
#'   \item{crop}{The crop name to be sown, \code{character}}
#'   \item{expected_yield_kg_ha}{Expected crop yield, \code{numeric}}
#'   \item{texture}{Soil texture from (one of "Sandy", "Loam", "Clayey"), \code{character}}
#'   \item{soil_depth_cm}{depth of soil tillage practise, \code{numeric}}}
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
      oct_jan_2019_pr_mm      = numeric(0),
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




