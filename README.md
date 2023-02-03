
# clavaan

## Overview

This package is censored SEM.

## Install

Install the latest release from CRAN:

``` r
devtools::install_github("sooyongl/clavaan")
```

The documentation is available at
[here](https://sooyongl.github.io/clavaan/).

``` r
library(clavaan)
library(lavaan)
#> Warning: package 'lavaan' was built under R version 4.1.3
#> This is lavaan 0.6-11
#> lavaan is FREE software! Please report any bugs.
library(tidyverse)
#> -- Attaching packages --------------------------------------- tidyverse 1.3.1 --
#> v ggplot2 3.3.6     v purrr   0.3.4
#> v tibble  3.1.7     v dplyr   1.0.9
#> v tidyr   1.2.0     v stringr 1.4.0
#> v readr   2.1.2     v forcats 0.5.1
#> Warning: package 'ggplot2' was built under R version 4.1.3
#> Warning: package 'tibble' was built under R version 4.1.3
#> Warning: package 'tidyr' was built under R version 4.1.3
#> Warning: package 'readr' was built under R version 4.1.3
#> Warning: package 'dplyr' was built under R version 4.1.3
#> -- Conflicts ------------------------------------------ tidyverse_conflicts() --
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()
```

## Generate Latent growth curve model data

``` r
unc.data <- lavaan::simulateData('
                     I =~ 1*y1 + 1*y2 + 1*y3 + 1*y4 + 1*y5
                     S =~ 0*y1 + 1*y2 + 2*y3 + 3*y4 + 4*y5

                     I ~ 3*1
                     S ~ 0.5*1

                     I ~~ 1*I + 0.2*S
                     S ~~ 0.5*S
                     ', model.type = 'growth',
                     sample.nobs = 500)
```

## Censore data

``` r
censored_prop <- c(left = 0.2, right = 0.8)

cen_points <- clavaan:::cenPoint(x = unc.data,
                       lower_quant = censored_prop[1],
                       upper_quant = censored_prop[2])


cen.data <- clavaan:::cenData(unc.data, cen_points) %>%
  data.frame() %>%
  set_names(names(unc.data))
```

## Compare

``` r
model =
'I =~ 1*y1 + 1*y2 + 1*y3 + 1*y4 + 1*y5
 S =~ 0*y1 + 1*y2 + 2*y3 + 3*y4 + 4*y5

 I ~ 1
 S ~ 1

 I ~~ I + S
 S ~~ S'
```

### clavaan

<!-- <div class = "row"> -->
<!-- <div class = "col-md-6"> -->

``` r
cgrowth(model, data = cen.data, bounds = cen_points) %>%
  summary()
#> lavaan 0.6-11 ended normally after 18 iterations
#> 
#>   Estimator                                        GLS
#>   Optimization method                           NLMINB
#>   Number of model parameters                        10
#>                                                       
#>   Number of observations                           500
#>                                                       
#> Model Test User Model:
#>                                                       
#>   Test statistic                                22.462
#>   Degrees of freedom                                10
#>   P-value (Chi-square)                           0.013
#> 
#> Parameter Estimates:
#> 
#>   Standard errors                             Standard
#>   Information                                 Expected
#>   Information saturated (h1) model          Structured
#> 
#> Latent Variables:
#>                    Estimate  Std.Err  z-value  P(>|z|)
#>   I =~                                                
#>     y1                1.000                           
#>     y2                1.000                           
#>     y3                1.000                           
#>     y4                1.000                           
#>     y5                1.000                           
#>   S =~                                                
#>     y1                0.000                           
#>     y2                1.000                           
#>     y3                2.000                           
#>     y4                3.000                           
#>     y5                4.000                           
#> 
#> Covariances:
#>                    Estimate  Std.Err  z-value  P(>|z|)
#>   I ~~                                                
#>     S                 0.224    0.042    5.379    0.000
#> 
#> Intercepts:
#>                    Estimate  Std.Err  z-value  P(>|z|)
#>     I                 2.988    0.056   52.889    0.000
#>     S                 0.546    0.032   17.290    0.000
#>    .y1                0.000                           
#>    .y2                0.000                           
#>    .y3                0.000                           
#>    .y4                0.000                           
#>    .y5                0.000                           
#> 
#> Variances:
#>                    Estimate  Std.Err  z-value  P(>|z|)
#>     I                 1.031    0.110    9.397    0.000
#>     S                 0.416    0.033   12.706    0.000
#>    .y1                0.884    0.095    9.290    0.000
#>    .y2                1.174    0.088   13.302    0.000
#>    .y3                0.998    0.076   13.122    0.000
#>    .y4                0.920    0.081   11.314    0.000
#>    .y5                0.487    0.106    4.596    0.000
```

<!-- </div> -->

### lavaan with censored data

<!-- <div class = "col-md-6"> -->

``` r
growth(model,data = cen.data) %>%
  summary()
#> lavaan 0.6-11 ended normally after 32 iterations
#> 
#>   Estimator                                         ML
#>   Optimization method                           NLMINB
#>   Number of model parameters                        10
#>                                                       
#>   Number of observations                           500
#>                                                       
#> Model Test User Model:
#>                                                       
#>   Test statistic                               112.154
#>   Degrees of freedom                                10
#>   P-value (Chi-square)                           0.000
#> 
#> Parameter Estimates:
#> 
#>   Standard errors                             Standard
#>   Information                                 Expected
#>   Information saturated (h1) model          Structured
#> 
#> Latent Variables:
#>                    Estimate  Std.Err  z-value  P(>|z|)
#>   I =~                                                
#>     y1                1.000                           
#>     y2                1.000                           
#>     y3                1.000                           
#>     y4                1.000                           
#>     y5                1.000                           
#>   S =~                                                
#>     y1                0.000                           
#>     y2                1.000                           
#>     y3                2.000                           
#>     y4                3.000                           
#>     y5                4.000                           
#> 
#> Covariances:
#>                    Estimate  Std.Err  z-value  P(>|z|)
#>   I ~~                                                
#>     S                 0.027    0.019    1.400    0.162
#> 
#> Intercepts:
#>                    Estimate  Std.Err  z-value  P(>|z|)
#>     I                 3.298    0.047   70.820    0.000
#>     S                 0.319    0.016   19.689    0.000
#>    .y1                0.000                           
#>    .y2                0.000                           
#>    .y3                0.000                           
#>    .y4                0.000                           
#>    .y5                0.000                           
#> 
#> Variances:
#>                    Estimate  Std.Err  z-value  P(>|z|)
#>     I                 0.710    0.073    9.791    0.000
#>     S                 0.092    0.009    9.931    0.000
#>    .y1                0.644    0.064   10.018    0.000
#>    .y2                0.750    0.057   13.258    0.000
#>    .y3                0.660    0.048   13.849    0.000
#>    .y4                0.445    0.039   11.440    0.000
#>    .y5                0.177    0.046    3.833    0.000
```

<!-- </div> -->
<!-- </div> -->

### lavaan with original data

``` r
growth(model,data = unc.data) %>%
  summary()
#> lavaan 0.6-11 ended normally after 32 iterations
#> 
#>   Estimator                                         ML
#>   Optimization method                           NLMINB
#>   Number of model parameters                        10
#>                                                       
#>   Number of observations                           500
#>                                                       
#> Model Test User Model:
#>                                                       
#>   Test statistic                                11.259
#>   Degrees of freedom                                10
#>   P-value (Chi-square)                           0.338
#> 
#> Parameter Estimates:
#> 
#>   Standard errors                             Standard
#>   Information                                 Expected
#>   Information saturated (h1) model          Structured
#> 
#> Latent Variables:
#>                    Estimate  Std.Err  z-value  P(>|z|)
#>   I =~                                                
#>     y1                1.000                           
#>     y2                1.000                           
#>     y3                1.000                           
#>     y4                1.000                           
#>     y5                1.000                           
#>   S =~                                                
#>     y1                0.000                           
#>     y2                1.000                           
#>     y3                2.000                           
#>     y4                3.000                           
#>     y5                4.000                           
#> 
#> Covariances:
#>                    Estimate  Std.Err  z-value  P(>|z|)
#>   I ~~                                                
#>     S                 0.179    0.044    4.030    0.000
#> 
#> Intercepts:
#>                    Estimate  Std.Err  z-value  P(>|z|)
#>     I                 2.977    0.056   53.617    0.000
#>     S                 0.567    0.034   16.633    0.000
#>    .y1                0.000                           
#>    .y2                0.000                           
#>    .y3                0.000                           
#>    .y4                0.000                           
#>    .y5                0.000                           
#> 
#> Variances:
#>                    Estimate  Std.Err  z-value  P(>|z|)
#>     I                 0.961    0.105    9.148    0.000
#>     S                 0.489    0.037   13.121    0.000
#>    .y1                0.940    0.098    9.630    0.000
#>    .y2                1.050    0.081   13.011    0.000
#>    .y3                1.005    0.076   13.189    0.000
#>    .y4                0.828    0.084    9.897    0.000
#>    .y5                0.872    0.129    6.740    0.000
```

``` r
sessionInfo()
#> R version 4.1.2 (2021-11-01)
#> Platform: x86_64-w64-mingw32/x64 (64-bit)
#> Running under: Windows 10 x64 (build 19044)
#> 
#> Matrix products: default
#> 
#> locale:
#> [1] LC_COLLATE=English_United States.1252 
#> [2] LC_CTYPE=English_United States.1252   
#> [3] LC_MONETARY=English_United States.1252
#> [4] LC_NUMERIC=C                          
#> [5] LC_TIME=English_United States.1252    
#> 
#> attached base packages:
#> [1] stats     graphics  grDevices utils     datasets  methods   base     
#> 
#> other attached packages:
#>  [1] forcats_0.5.1   stringr_1.4.0   dplyr_1.0.9     purrr_0.3.4    
#>  [5] readr_2.1.2     tidyr_1.2.0     tibble_3.1.7    ggplot2_3.3.6  
#>  [9] tidyverse_1.3.1 lavaan_0.6-11   clavaan_0.1.0  
#> 
#> loaded via a namespace (and not attached):
#>  [1] tidyselect_1.1.2 xfun_0.31        haven_2.5.0      colorspace_2.0-3
#>  [5] vctrs_0.4.1      generics_0.1.2   htmltools_0.5.2  stats4_4.1.2    
#>  [9] yaml_2.3.5       utf8_1.2.2       rlang_1.0.6      pillar_1.8.1    
#> [13] withr_2.5.0      glue_1.6.2       DBI_1.1.3        dbplyr_2.2.0    
#> [17] readxl_1.4.0     modelr_0.1.8     lifecycle_1.0.2  cellranger_1.1.0
#> [21] munsell_0.5.0    gtable_0.3.0     rvest_1.0.3      mvtnorm_1.1-3   
#> [25] evaluate_0.16    knitr_1.39       tzdb_0.3.0       fastmap_1.1.0   
#> [29] fansi_1.0.3      broom_0.8.0      backports_1.4.1  scales_1.2.1    
#> [33] jsonlite_1.8.0   fs_1.5.2         mnormt_2.1.0     hms_1.1.1       
#> [37] digest_0.6.29    stringi_1.7.6    grid_4.1.2       cli_3.3.0       
#> [41] tools_4.1.2      magrittr_2.0.3   crayon_1.5.1     pbivnorm_0.6.0  
#> [45] pkgconfig_2.0.3  MASS_7.3-54      ellipsis_0.3.2   xml2_1.3.3      
#> [49] reprex_2.0.1     lubridate_1.8.0  assertthat_0.2.1 rmarkdown_2.16  
#> [53] httr_1.4.4       rstudioapi_0.14  R6_2.5.1         compiler_4.1.2
```
