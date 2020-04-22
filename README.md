Introduction to `fertplanspatial` R package
================

## Description

The goal of the package is to define fertilization plans for the fields
of a farm and spatialize them. Fertilization plans in the Lazio region
territory have to follow these agronomic guidelines with specific
attention to [attachment no.
2](http://www.regione.lazio.it/binary/rl_main/tbl_documenti/AGC_DD_G01782_24_02_2020_Allegato1.pdf "PDF file of the Attachment 2 of the guidelines")
(Assessorato Agricoltura, Promozione della Filiera e della Cultura del
Cibo, Ambiente e Risorse Naturali 2020) and relies on R package
`fertplan` to perform the raw computations.

## Installation

`fertplanspatial` is currently in active development and not yet on
CRAN, it may be installed from this GitHub repository though:

``` r
# Install devtools package if not yet present in R library
# install.packages("devtools")

devtools::install_github("mbask/fertplanspatial")
```

## Usage

``` r
data(soils)
knitr::kable(soils)
```

| id |       X |       Y | N\_pc | C\_pc |       CNR | SOM\_pc | P\_ppm | K\_ppm | Limestone\_pc | Clay\_pc |
| -: | ------: | ------: | ----: | ----: | --------: | ------: | -----: | -----: | ------------: | -------: |
|  1 | 1405396 | 5175767 | 0.139 |  1.33 |  9.568345 |    2.30 |     11 |    449 |          17.4 |       34 |
|  2 | 1405537 | 5175798 | 0.165 |  1.62 |  9.818182 |    2.79 |     14 |    359 |           9.5 |       37 |
|  3 | 1405486 | 5175801 | 0.160 |  1.56 |  9.750000 |    2.69 |     14 |    398 |          12.2 |       40 |
|  4 | 1405503 | 5175761 | 0.164 |  1.61 |  9.817073 |    2.77 |     14 |    492 |          10.3 |       34 |
|  5 | 1405555 | 5175659 | 0.122 |  1.14 |  9.344262 |    1.97 |     21 |    347 |           0.6 |       38 |
|  6 | 1405553 | 5175713 | 0.145 |  1.39 |  9.586207 |    2.40 |     14 |    328 |           6.3 |       40 |
|  7 | 1405508 | 5175740 | 0.159 |  1.55 |  9.748428 |    2.67 |     14 |    355 |           8.7 |       34 |
|  8 | 1405524 | 5175780 | 0.163 |  1.59 |  9.754601 |    2.73 |     15 |    410 |          13.4 |       34 |
|  9 | 1405571 | 5175771 | 0.143 |  1.37 |  9.580420 |    2.36 |     14 |    343 |           9.5 |       37 |
| 10 | 1405481 | 5175750 | 0.152 |  1.47 |  9.671053 |    2.54 |     12 |    394 |          13.4 |       36 |
| 11 | 1405573 | 5175848 | 0.164 |  1.60 |  9.756098 |    2.76 |     14 |    324 |          10.3 |       37 |
| 12 | 1405646 | 5175819 | 0.137 |  1.31 |  9.562044 |    2.25 |     11 |    297 |           5.3 |       40 |
| 13 | 1405543 | 5175910 | 0.173 |  1.70 |  9.826590 |    2.93 |     12 |    398 |          13.0 |       38 |
| 14 | 1405642 | 5175899 | 0.189 |  1.88 |  9.947090 |    3.24 |     15 |    304 |          11.9 |       38 |
| 15 | 1405679 | 5175881 | 0.145 |  1.39 |  9.586207 |    2.40 |     13 |    289 |           2.9 |       40 |
| 16 | 1405589 | 5175851 | 0.162 |  1.58 |  9.753086 |    2.73 |     16 |    351 |          10.3 |       34 |
| 17 | 1405649 | 5175930 | 0.205 |  2.06 | 10.048780 |    3.56 |     20 |    476 |          11.9 |       36 |
| 18 | 1405647 | 5175863 | 0.148 |  1.43 |  9.662162 |    2.47 |     12 |    355 |           5.5 |       39 |
| 19 | 1405511 | 5175874 | 0.154 |  1.49 |  9.675325 |    2.58 |     12 |    351 |          13.0 |       36 |
| 20 | 1405599 | 5175804 | 0.146 |  1.41 |  9.657534 |    2.43 |     14 |    285 |           8.3 |       37 |

``` r
soil_vars <- list(
  # Common vars among nitrogen, phosphorus, and potassium
  crop                 = "Girasole", # to be looked up in table 15.2 (page 63)
  expected_yield_kg_ha = 1330,
  texture              = "Loam", # to be chosen among Sandy, Loam, Clayey
  
  # Additional vars for nitrogen
  crop_type            = "Girasole",  # to be looked up in table 15.3 (page 67)
  prev_crop            = "Prati: polifita con meno del 5%", # to be looked up in table 5 (page 24)
  drainage_rate        = "slow", # to be looked up in table 4 (page 23)
  oct_jan_pr_mm        = 350, # Rainfall between October 2018 and January 2019
  n_supply_prev_frt_kg_ha = 0,
  n_supply_atm_coeff   = 1,

  # Common vars among phosphorus and potassium
  soil_depth_cm        = 30,
  
  # Additional vars for phosphorus
  crop_class           = "Girasole") # to be looked up in table 10 (page 32)
```

``` r
nutrient_dt <- demand_nutrient(soils, soil_vars, c("all"))
print(nutrient_dt)
#>     nitrogen phosphorus  potassium
#>  1: -23.4051    83.9776 -1854.4582
#>  2: -28.9015    60.0745 -1332.6616
#>  3: -27.7770    61.6540 -1638.2890
#>  4: -28.6766    60.5425 -2124.7906
#>  5: -19.6988    19.0504 -1268.5222
#>  6: -24.5205    58.2025 -1168.7290
#>  7: -27.5521    59.6065 -1263.4990
#>  8: -28.2177    56.2408 -1609.2730
#>  9: -24.0707    60.0745 -1228.7032
#> 10: -26.0948    74.5864 -1542.9418
#> 11: -28.5596    60.5425 -1105.2526
#> 12: -22.8383    74.0677  -960.7810
#> 13: -30.4667    74.2900 -1603.4698
#> 14: -31.1401    55.4803  -986.1154
#> 15: -24.5205    61.5097  -907.1170
#> 16: -28.2268    48.7957 -1238.3518
#> 17: -30.9945    25.4893 -2069.9722
#> 18: -25.3122    68.7325 -1335.4540
#> 19: -26.5446    74.2900 -1266.5722
#> 20: -24.8624    59.3725  -851.8540
```

## References

<div id="refs" class="references hanging-indent">

<div id="ref-guidelines2020">

Assessorato Agricoltura, Promozione della Filiera e della Cultura del
Cibo, Ambiente e Risorse Naturali. 2020. “Parte Agronomica, Norme
Generali, Disciplinare Di Produzione Integrata Della Regione Lazio -
SQNPI.” Regione Lazio.
<http://www.regione.lazio.it/rl_agricoltura/?vw=documentazioneDettaglio&id=52065>.

</div>

</div>
