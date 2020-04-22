# Compute phosphorus demand
#
# This is an internal function not meant to be used by the end-user
# as no checks are performed on its arguments
#
# @param soil_dt   a \code{data.table} of soil samples bound with environmental and crop-related and variables
#
# @return          a numeric vector of length equal to the number of rows in \code{soil_dt}
demand_phosphorus <- function(soil_dt) `: numeric` ({

  flow_cmpnts_c <- paste(LETTERS[1:3], "P_kg_ha", sep = "_")

  # prevent no visible binding NOTE
  crop <- expected_yield_kg_ha <- crop_class <- P_ppm <- texture <- soil_depth_cm <- NULL
  Limestone_pc <- p_demand_kg_ha <- A_P_kg_ha <- B_P_kg_ha <- C_P_kg_ha <- NULL

  demand_dt <- soil_dt[
    , `:=` (
    A_P_kg_ha              = fertplan::A_crop_demand(
      crop_abs       = fertplan::rem_P_coef_of(crop) / 100,
      crop_exp_yield = expected_yield_kg_ha),
    B_P_kg_ha              = fertplan::B_P_in_soil(
      crop           = crop_class,
      p_ppm          = P_ppm,
      soil_texture   = texture,
      soil_depth_cm  = soil_depth_cm),
    C_P_kg_ha              = fertplan::C_P_immob_by_Ca(
      Ca_pc          = Limestone_pc,
      soil_texture   = texture))]

  fertzl_cols <- grep(
    pattern = "^[A-Z]_P_kg_ha$",
    x       = colnames(demand_dt),
    value   = TRUE)
  ensurer::ensure_that(
    fertzl_cols,
    identical(., flow_cmpnts_c) ~ "some phosphorus components missing, impossible to estimate P demand.")

  demand_dt[, p_demand_kg_ha := A_P_kg_ha + B_P_kg_ha * C_P_kg_ha]

  demand_dt[, p_demand_kg_ha]
})

