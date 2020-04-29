#' Soil physical and chemical analyses dataset
#'
#' A dataset containing the results of physical and chemical analyses on 20
#' samples of soil in a field located in the property of the Italian Council
#' for Agricultural Research and Economica, Research Centre for Engineering
#' and Agro-Food Processing of Monterotondo (Rome).
#'
#' The soil sample points are randomly spread over a 5 ha field previously cultivated on
#' wheat followed by a few month-long fallow. Soil samples were analyzed in October 2019.
#'
#' @md
#' @format A soil samples `data.table` with 20 soil samples (rows) and 9 features (columns):
#'
#'  * **id**: a simple id for each soil sample
#'  * **N_pc**: nitrogen content in %
#'  * **C_pc**: carbon content in %
#'  * **CNR**: carbon / nitrogen ratio
#'  * **SOM_pc**: soil organic matter in %
#'  * **P_ppm**: phosphorus content in ppm (mg/kg)
#'  * **K_ppm**: potassium content in ppm (mg/kg)
#'  * **Limestone_pc**: calcium (Ca) content in %
#'  * **Clay_pc**: clay content in %
#'
#' @source \url{https://www.journals.elsevier.com/european-journal-of-agronomy}
"soils"

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