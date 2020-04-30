data("soils")
data("soils_spatial")
soil_vars <- list(
  crop                 = "Girasole",
  expected_yield_kg_ha = 1330,
  texture              = "Loam",
  crop_type            = "Girasole",
  prev_crop            = "Prati: polifita con meno del 5%",
  drainage_rate        = "slow",
  oct_jan_pr_mm        = 350,
  n_supply_prev_frt_kg_ha = 0,
  n_supply_atm_coeff   = 1,
  soil_depth_cm        = 30,
  crop_class           = "Girasole")

# Use soils_spatial dataset to check demand_nutrient output
expect_equal(demand_nutrient(soils, soil_vars, nutrient = "nitrogen")$nitrogen, soils_spatial$nitrogen)
expect_equal(demand_nutrient(soils, soil_vars, nutrient = "phosphorus")$phosphorus, soils_spatial$phosphorus)
expect_equal(demand_nutrient(soils, soil_vars, nutrient = "potassium")$potassium, soils_spatial$potassium)

# A variable is missing only for a specific nutrient (phosphorus)
soil_vars$crop_class <- NULL
expect_error(demand_nutrient(soils, soil_vars), "column names: \\[crop_class\\]")
# A basic variable is missing
soil_vars$texture <- NULL
expect_error(demand_nutrient(soils, soil_vars), "column names: \\[texture\\]")
# A soil feature is missing (carbon nitrogen ratio)
soil_vars$texture <- "Loam"
soils[, CNR := NULL]
expect_error(demand_nutrient(soils, soil_vars), "column names: \\[CNR\\]")
# No nutrient given
expect_warning(demand_nutrient(soils, soil_vars, "nitro"), "No nutrient demand to compute")
# At least one correct nutrient name is passed (potassium)
expect_equal(demand_nutrient(soils, soil_vars, c("nitro", "potassium"))$potassium, soils_spatial$potassium)
