#' Spatial soil nutrients fertilization dataset
#'
#' A [sp::SpatialPointsDataFrame()] dataset containing the results
#' of applying [demand_nutrient()] on \code{\link{soils}} dataset to get
#' NPK fertilization plans.
#'
#' Each soil sample point is spatially located in WGS84 Pseudo-Mercator coordinates
#' (epsg:3857, unit: metres) and uniquely identified through a numeric `id`.
#'
#' @md
#' @format A soil sample points `data.table` with 20 sample points (rows)
#' and 6 features(columns):
#'
#'  * **id**: a simple id for each soil sample point
#'  * **X**: longitude coordinate in WGS84 Pseudo-Mercator Coordinate Reference System
#'  * **Y**: latitude coordinate in WGS84 Pseudo-Mercator Coordinate Reference System
#'  * **nitrogen**: estimate of nitrogen demand in kg/ha
#'  * **phosphorus**: estimate of phosphorus (P_2O) demand in kg/ha
#'  * **potassium**: estimate of potassium (K_2O_5) demand in kg/ha
#'
#' @source \url{https://www.journals.elsevier.com/european-journal-of-agronomy}
"soils_spatial"