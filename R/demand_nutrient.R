#' Compute NPK fertilization
#'
#' This is the main interface hub to all `fertplan` package functions. Its main
#' objective is to relieve the user from the process of computing all NPK flow
#' components (*i.e.* $f_{N,a}-f_{N,g}$ for nitrogen) that make each nutrient
#' budget.
#'
#' To compure NPK fertilization plans soil, a few chemical and physical analysis
#' on soil samples are needed as well as some informations on the environment
#' and related to the crop to be sown.
#'
#' All soil samples chemical and physical analyses (*i.e.* for nitrogen nutrien:
#' percentage of nitrogen, carbon / nitrogen ratio, organic matter percentage,
#' clay content in percentage) needed to compute each nutrient budget must be
#' passed as `data.table` columns and soil samples as rows, as in the following
#' example for nitrogen:
#'
#' | N_pc  |   CNR | SOM_pc  | Clay_pc |
#' | ----: | ----: | ------: | ------: |
#' | 0.139 |  9.57 |    2.30 |      34 |
#' | 0.165 |  9.82 |    2.79 |      37 |
#' | 0.160 |  9.75 |    2.69 |      40 |
#'
#' The order of the features/columns is unimportant. An example of features
#' needed for Phosphorus nutrient:
#'
#' | P_ppm | Limestone_pc |
#' | ----: | -----------: |
#' |    11 |         17.4 |
#' |    14 |          9.5 |
#' |    14 |         12.2 |
#'
#' An example of features needed for Potassium nutrient:
#'
#' | K_ppm | Clay_pc |
#' | ----: | ------: |
#' |   449 |      34 |
#' |   359 |      37 |
#' |   398 |      40 |
#'
#' Other environmental and crop-related informazions needed for each nutrient
#' computation can be passed as elements of a list. The function assumes
#' that these features are shared among all soil samples. Specific informations
#' on these variables can be found on the nitrogen, phosphorus, and potassium
#' vignettes of the `fertplan` package and strictly depend on the Lazio Region
#' guidelines.
#'
#' Environmental features needed for **nitrogen** nutrient:
#'
#'  * **crop**, The crop name to be sown, to be looked up in table 15.2 (page 63 of the guidelines)
#'  * **crop_type**, The crop type to be sown,  to be looked up in table 15.3 (page 67)
#'  * **expected_yield_kg_ha**, Expected crop yield in kg/ha
#'  * **prev_crop**, name or type of the previous crop, to be looked up in table 5 (page 24)
#'  * **texture**, Soil texture from (one of "Sandy", "Loam", "Clayey")
#'  * **drainage_rate**, Rate of drainage in soil (either "fast", "normal", "slow", "no drainage")
#'  * **oct_jan_pr_mm**, cumulative precipitation in mm in the 4 months-period October - January
#'  * **n_supply_prev_frt_kg_ha**, Supply from organic fertilizations in kg/ha
#'  * **n_supply_atm_coeff**, A ratio to correct the N from atmosphere in kg/ha
#'
#' Environmental features needed for **phosphorus** nutrient:
#'
#'  * **crop**, The crop name to be sown, to be looked up in table 15.2 (page 63 of the guidelines)
#'  * **crop_class**, The class of crop to be sown, to be looked up in table 10 (page 32)
#'  * **expected_yield_kg_ha**, Expected crop yield in kg/ha
#'  * **texture**, Soil texture from (one of "Sandy", "Loam", "Clayey")
#'  * **soil_depth_cm**, depth of soil tillage practise in cm, usually 30 or 40 cm
#'
#' Environmental features needed for **potassium** nutrient:
#'
#'  * **crop**, The crop name to be sown, to be looked up in table 15.2 (page 63 of the guidelines)
#'  * **expected_yield_kg_ha**, Expected crop yield in kg/ha
#'  * **texture**, Soil texture from (one of "Sandy", "Loam", "Clayey")
#'  * **soil_depth_cm**, depth of soil tillage practise in cm, usually 30 or 40 cm
#'
#' A real soil samples `data.table` is available as package dataset \code{\link{soils}}.
#'
#' More informations on soil properties and other variables related to the
#'  crop and the environment can be found in the documentation of the
#'  [check_soil_table()] and [check_vars()] functions,
#'  in package [fertplan](http://github.com/mbask/fertplan) help pages, and in vignettes and in the
#'  guideline of Region Lazio.
#'
#' @param soil_dt     a `data.table` of soil properties (columns)
#'   x soil samples (rows). The specific features (soil analyses) that
#'   must be passed in the `data.table` depend on the
#'   nutrient fertilization passed in `nutrient` parameter
#' @param vars        a `list` of variables shared between all soil
#'   samples. The specific variables needed depend on the nutrient fertilization
#'   passed in `nutrient` parameter
#' @param nutrient    a character vector detailing which nutrient
#'   fertilization plan to compute among "nitrogen", "phosphorus", and
#'   "potassium". Any combination of the three nutrients can be given or
#'   "all" (default) to compute all of them.
#'
#' @return  a `data.table` with as many features as nutrients
#'   given as `nutrient` parameter and as many rows as soil samples
#'   given as `soil_dt` parameter.
#' @md
#' @export
#' @importFrom ensurer ensure
#' @importFrom ensurer ensure_that
#' @importFrom data.table setDT
#' @importFrom data.table data.table
#' @importFrom data.table `:=`
#' @seealso [fertplan](http://github.com/mbask/fertplan) package.
#' @seealso Assessorato Agricoltura, Promozione della Filiera e della Cultura del
#'   Cibo, Ambiente e Risorse Naturali. 2020. “Parte Agronomica, Norme Generali,
#'   Disciplinare Di Produzione Integrata Della Regione Lazio - SQNPI.” Regione Lazio.
#'   \url{http://www.regione.lazio.it/rl_agricoltura/?vw=documentazioneDettaglio&id=52065}.
demand_nutrient <- function(soil_dt, vars, nutrient = "all") `: dt` ({

  ensurer::ensure(soil_dt, +is_df, +are_obs_in_table)
  is_list(vars)
  is_character(nutrient)

  if ("all" %in% nutrient) {
    nutrient <- c("nitrogen", "phosphorus", "potassium")
  }

  # setup variables and return table
  # for computing nutrient fertilization concentrations

  ntrt_results_dt <- data.table::data.table()
  .SD <- NULL

  # nitrogen
  if ("nitrogen" %in% nutrient) {
    soil_n_dt <- check_soil_table(soil_dt, "nitrogen")

    # insert optional arguments when n_supply_prev_frt_kg_ha is 0
    if (vars$n_supply_prev_frt_kg_ha == 0L) {
      vars <- within(
        vars, {
          years_ago          <- 0L
          organic_fertilizer <- "" })
    }
    vars_n_dt      <- check_vars(vars, "nitrogen")

    nitrogen <- NULL
    ntrt_results_dt[, nitrogen := demand_nitrogen(cbind(soil_n_dt, vars_n_dt))]
  }

  # phosphorus
  if ("phosphorus" %in% nutrient) {
    soil_p_dt <- check_soil_table(soil_dt, "phosphorus")
    vars_p_dt <- check_vars(vars, "phosphorus")
    phosphorus <- NULL
    ntrt_results_dt[, phosphorus := demand_phosphorus(cbind(soil_p_dt, vars_p_dt))]
  }

  # potassium
  if ("potassium" %in% nutrient) {
    soil_k_dt <- check_soil_table(soil_dt, "potassium")
    vars_k_dt <- check_vars(vars, "potassium")
    potassium <- NULL
    ntrt_results_dt[, potassium := demand_potassium(cbind(soil_k_dt, vars_k_dt))]
  }

  if (ncol(ntrt_results_dt) == 0) {
    warning("No nutrient demand to compute. Returning a null data.table...")
    ntrt_results_dt
  } else {
    are_obs_in_table(ntrt_results_dt)
  }
})