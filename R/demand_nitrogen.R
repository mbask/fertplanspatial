# Compute nitrogen demand

# This is an internal function not meant to be used by the end-user
# as no checks are performed on its arguments
#
# @param soil_dt   a \code{data.table} of soil samples bound with environmental and crop-related and variables
# @param blnc_cmpt should the individual nitrogen components or just the nutrient balance itself be returned?
#
# @return          a numeric vector of length equal to the number of rows in \code{soil_dt}
demand_nitrogen <- function(soil_dt, blnc_cmpt) `: dt` ({

  flow_cmpnts_c <- paste(LETTERS[1:7], "N_kg_ha", sep = "_")

  # prevent no visible binding NOTE
  crop <- part <- expected_yield_kg_ha <- crop_type <- N_pc <- texture <- SOM_pc <- CNR <- oct_jan_pr_mm <- NULL
  drainage_rate <- prev_crop <- n_supply_prev_frt_kg_ha <- n_supply_atm_coeff <- nitrogen_kg_ha <- NULL
  n_supply_prev_frt_kg_ha <- years_ago <- organic_fertilizer <- b1_N_kg_ha <- b2_N_kg_ha <- B_N_kg_ha <- NULL

  demand_dt <- soil_dt[
    , `:=` (
      b1_N_kg_ha             = fertplan::b1_available_n(
        total_n_pc     = N_pc,
        texture        = texture),
      b2_N_kg_ha             = fertplan::b2_mineralized_n(
        crop_type      = crop_type,
        som_pc         = SOM_pc,
        cn_ratio       = CNR,
        texture        = texture))]
  demand_dt[
    , `:=` (
      A_N_kg_ha              = fertplan::A_crop_demand(
        crop_abs       = fertplan::rem_N_coef_of(crop, part) / 100,
        crop_exp_yield = expected_yield_kg_ha),
      B_N_kg_ha              = fertplan::B_N_in_soil(b1_N_kg_ha, b2_N_kg_ha),
      C_N_kg_ha              = fertplan::C_N_precip_leach(
        available_n      = b1_N_kg_ha,
        rainfall_oct_jan = oct_jan_pr_mm))]
  demand_dt[
    , `:=` (
      D_N_kg_ha              = fertplan::D_N_denitrification(
        B             = B_N_kg_ha,
        drainage_rate = drainage_rate,
        soil_texture  = texture),
      E_N_kg_ha              = fertplan::E_N_from_prev_crop(crop = prev_crop),
      F_N_kg_ha              = fertplan::F_N_prev_fertilization(n_supply_prev_frt_kg_ha, organic_fertilizer, years_ago),
      G_N_kg_ha              = fertplan::G_N_from_atmosphere(coeff = n_supply_atm_coeff))]

  fertzl_cols <- grep(
    pattern = "^[A-Z]_N_kg_ha$",
    x       = colnames(demand_dt),
    value   = TRUE)
  ensurer::ensure_that(
    fertzl_cols,
    identical(., flow_cmpnts_c) ~ "some components of nitrogen balance are missing.")

  if (blnc_cmpt) {
    demand_dt[, fertzl_cols, with = FALSE]
  } else {
    .SD <- NULL
    demand_dt[, nitrogen_kg_ha := rowSums(.SD), .SDcols = fertzl_cols]
    demand_dt[, "nitrogen_kg_ha"]
  }

})

