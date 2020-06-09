#' Tranform a data.frame into a SpatialPoints
#'
#' Assign a Coordinate Reference System proj4 string and identify geographical
#' coordinates in a `data.frame` to return a SpatialPoints object. Geographical coordinates
#' must be present in the `data.frame` and named `X`, and `Y`.
#'
#' @param tab a data.fram typically build via [expand.grid()]
#' @param crs_s a proj4string coordinate reference system typically returned by [sp::proj4string()]
#'
#' @return a [sp::SpatialPoints()] for `tab` with a crs assigned and X, Y coordinates identified
#' @export
#' @md
to_sp <- function(tab, crs_s) `: spatial` ({
  is_df(tab)
  sp::coordinates(tab) <- ~ X + Y
  sp::proj4string(tab) <- crs_s
  tab
})


#' Spatialize nutrient fertilization plans
#'
#' Spatialization is performed bny fitting a variogram model to the nutrients
#' fertilization plans and then performing ordinary kriging.
#'
#' The function returns a list of [sp::SpatialPointsDataFrame()] grids on the
#' bounding box of the spatial soil nutrients fertilization dataset, as
#' returned by [demand_nutrient()]. Each spatial grid can be readily plotted or
#' rasterized.
#'
#' Spatial coordinates must be passed as 'X' and 'Y' named columns in `sp_df`
#' spatial table. This table should also containing either 'nitrogen',
#' 'phosphorus', and 'potassium' named columns according to the nutrient plan
#' to be spatialized passed as `nutrient` argument.
#'
#' @param sp_df    a Spatial soil nutrients fertilization dataset
#' @param model    a character vector describing the variogram model type.
#'   Either "auto" or one of the available variogram models to [gstat::vgm()],
#'   e.g. "Exp", "Sph", "Gau", "Mat". Specific model parameters may be passed
#'   to [gstat::vgm()] as named function arguments arguments.
#'   In "auto" the optimal variogram
#'   is chosen by [automap::autofitVariogram()]. Calling gstat::vgm() without a model
#'   argument returns a data.frame with available models.
#' @param grid_spdf a [sp::SpatialPoints()] object grid with nutrient predictions
#'   locations. If `NULL` (default) then a point grid is built using `sp_df` bounding
#'   box and coordinate reference system, each point spatially distant by `spat_res`.
#' @param bbox_buffer an integer value to enlarge (or shrink) the bounding box the
#'   default point grid is built in (i.e. when grid_spdf is set to `NULL`). Default to `0L`,
#'    i.e. no effect on the bounding box.
#' @param spat_res a positive number indicating the spatial resolution
#'   of the resulting spatial grid when `grid_spdf` is `NULL`. Default is 5 metres.
#' @param nutrient  a character vector detailing which nutrient
#'   spatialized fertilization plan to compute among "nitrogen",
#'   "phosphorus", and "potassium". Any combination of the three
#'   nutrients can be given or "all" (default) to compute all of them.
#' @param ... arguments that will be passed to [gstat::vgm()]
#'
#' @md
#' @return a list with as many elements as nutrients given as `nutrient`
#' parameter. Each element is a [sp::SpatialPointsDataFrame()].
#' @export
#' @importFrom ensurer ensure
#' @importFrom sp      bbox
#' @importFrom sp      coordinates
#' @importFrom sp      proj4string
#' @importFrom gstat    vgm
#' @importFrom gstat    krige
#' @importFrom gstat    variogram
#' @importFrom gstat    fit.variogram
#' @importFrom automap  autofitVariogram
spatial_nutrient <- function(sp_df, model = "auto", grid_spdf = NULL, bbox_buffer = 0L, spat_res = 5L, nutrient = "all", ...) `: spdf_list` ({

  variogram_kriging <- function(formula) {
    variogram_n <- variogram_nutrient(
      formula,
      sp_df,
      model,
      ...)
    gstat::krige(
      formula,
      locations = sp_df,
      newdata   = grid_spdf,
      model     = variogram_n[["vrg_model"]])
  }


  is_character(nutrient)
  is_spdf(sp_df)
  ensurer::ensure(model, +is_character, +is_in_variogram_models)

  if ("all" %in% nutrient) {
    nutrient <- c("nitrogen", "phosphorus", "potassium")
  }

  if (is.null(grid_spdf)) {
    # Build a spatial grid of spat_res distanced points
    # in the sp_df bounding box with same CRS
    ensurer::ensure(spat_res, +is_numeric, +is_positive)
    is_integer(bbox_buffer)

    sp_bbox   <- sp::bbox(sp_df)

    grid_spdf <- to_sp(
      tab = expand.grid(
        apply(
          sp_bbox,
          1,     # on rows
          function(row) { seq(from = row[1] - bbox_buffer, to = row[2] + bbox_buffer, by = spat_res) }
      )),
      crs_s = sp::proj4string(sp_df))
  }

  # check grid is fine
  is_sp(grid_spdf)
  if (is.na(sp::proj4string(grid_spdf)) | sp::proj4string(grid_spdf) !=  sp::proj4string(sp_df)) {
    warning("CRS of grid does not match CRS of nutrient spatial soil dataset; setting the latter CRS on the former.")
    sp::proj4string(grid_spdf) <- sp::proj4string(sp_df)
  }

  spatial_l <- list()

  # nitrogen
  if ("nitrogen" %in% nutrient) {
    formula = formula(nitrogen ~ 1)
    is_formula(formula)
    spatial_l$n <- variogram_kriging(formula)
  }

  # phosphorus
  if ("phosphorus" %in% nutrient) {
    formula = formula(phosphorus ~ 1)
    is_formula(formula)
    spatial_l$p <- variogram_kriging(formula)
  }

  # potassium
  if ("potassium" %in% nutrient) {
    formula = formula(potassium ~ 1)
    is_formula(formula)
    spatial_l$k <- variogram_kriging(formula)
  }
  if (!length(spatial_l)) {
    warning("No nutrient plan spatialised. Returning an empty list...")
  }
  spatial_l
})
