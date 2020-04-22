# Compute potassium demand
#
# This is an internal function not meant to be used by the end-user
# as no checks are performed on its arguments
#
# @param soil_dt   a \code{data.table} of soil samples bound with environmental and crop-related and variables
#
# @return          a numeric vector of length equal to the number of rows in \code{soil_dt}
demand_potassium <- function(soil_dt) `: numeric` ({

  flow_cmpnts_c <- paste(LETTERS[5:8], "K_kg_ha", sep = "_")

  # prevent no visible binding NOTE
  crop <- expected_yield_kg_ha <- K_ppm <- texture <- soil_depth_cm <- NULL
  Clay_pc <- k_demand_kg_ha <- E_K_kg_ha <- F_K_kg_ha <- G_K_kg_ha <- H_K_kg_ha<- NULL

  demand_dt <- soil_dt[
    , `:=` (
      E_K_kg_ha              = fertplan::A_crop_demand(
        crop_abs       = fertplan::rem_K_coef_of(crop) / 100,
        crop_exp_yield = expected_yield_kg_ha),
      F_K_kg_ha              = fertplan::F_K_in_soil(
        k_ppm         = K_ppm,
        soil_texture  = texture,
        soil_depth_cm = soil_depth_cm),
      G_K_kg_ha              = fertplan::G_K_immob_by_clay(Clay_pc),
      H_K_kg_ha              = fertplan::H_K_leaching(Clay_pc)  )]

  fertzl_cols <- grep(
    pattern = "^[A-Z]_K_kg_ha$",
    x       = colnames(demand_dt),
    value   = TRUE)
  ensurer::ensure_that(
    fertzl_cols,
    identical(., flow_cmpnts_c) ~ "some potassium components missing, impossible to estimate K demand.")

  demand_dt[, k_demand_kg_ha := E_K_kg_ha + (F_K_kg_ha * G_K_kg_ha) + H_K_kg_ha]

  demand_dt[, k_demand_kg_ha]
})

