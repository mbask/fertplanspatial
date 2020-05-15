# Type-safe assertions ----------------------------------------------------

#' @importFrom ensurer ensures_that
is_character <-
  ensurer::ensures_that(is.character(.) ~ "vector must be of character type.")

is_list <-
  ensurer::ensures_that(is.list(.) ~ "expecting a list type.")

is_numeric <-
  ensurer::ensures_that(is.numeric(.) ~ "vector must be of numeric type.")

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
