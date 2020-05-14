# Type-safe assertions ----------------------------------------------------

#' @importFrom ensurer ensures_that
is_character <-
  ensurer::ensures_that(is.character(.) ~ "vector must be of character type.")

is_list <-
  ensurer::ensures_that(is.list(.) ~ "expecting a list type.")

is_numeric <-
  ensurer::ensures_that(is.numeric(.) ~ "vector must be of numeric type.")

is_logical <-
  ensurer::ensures_that(is.logical(.) ~ "expecting a `TRUE` or `FALSE` variable.")

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

is_nutrient <-
  ensurer::ensures_that(. %in% c("nitrogen", "phosphorus", "potassium"))

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
    identical(sapply(., levels), sapply(tpl, levels)),
    err_desc = "inconsistent format, one or more variables do not match the proper type (eg, an integer value required but a numeric given!)")
}


