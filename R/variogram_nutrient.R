# A wrapper around gstat and automap variogram functions
#
# @param formula
# @param sp_df
# @param model
#
# @return
variogram_nutrient <- function(formula, sp_df, model) `: variogram_list` ({

  # calculates sample variogram values
  n_values <- gstat::variogram(formula, sp_df)

  if (model == "auto") {
    n_model <- automap::autofitVariogram(
      formula    = formula,
      input_data = sp_df,
      alpha      = seq(0, 359, 15))$var_model
  } else {
    n_model <- gstat::vgm(model)
  }

  n_fit <- gstat::fit.variogram(object = n_values, model = n_model)
  list(vrg_values = n_values, vrg_model = n_fit)
})
