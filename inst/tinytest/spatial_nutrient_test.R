data("soils_spatial")
# Unexistent model given
expect_error(spatial_nutrient(soils_spatial, model = "Sphe"), "variogram model not found")
sp_bbox   <- sp::bbox(soils_spatial)
grid_spdf <- expand.grid(
  apply(
    sp_bbox,
    1,     # on rows
    function(row) { seq(from = row[1], to = row[2], by = 10) }
  ))
# No SpatialPoints table given
expect_error(spatial_nutrient(soils_spatial, grid_spdf = grid_spdf), "table must be of SpatialPoints class from package sp")
sp::coordinates(grid_spdf) <- ~ X + Y
# Mismatch between CRSs
expect_warning(spatial_nutrient(soils_spatial, grid_spdf = grid_spdf), "CRS of grid does not match CRS of nutrient spatial soil dataset")
# No nutrient given
expect_warning(spatial_nutrient(soils_spatial, nutrient = "nitro"), "No nutrient plan spatialised")
