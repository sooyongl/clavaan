
# clavaan

## Overview

The clavaan package is specifically designed for analyzing censored data
within the structural equation modeling framework. It is capable of
handling right, left, or doubly-censored data. By estimating the
censored mean and variance-covariance from the censored data, the
package enables model fitting using the well-established lavaan package.
This integration allows researchers to accurately analyze censored data
and draw reliable conclusions from their structural equation models.

This package is based on Sooyong Lee’s doctoral dissertation (Sooyong Lee. (2023). Development of a method for addressing various censoring effects in a latent growth curve modeling framework).


## Install

Install the latest release from CRAN:

``` r
devtools::install_github("sooyongl/clavaan")
```

<!-- The documentation is available at [here](https://sooyongl.github.io/clavaan/). -->

``` r
library(clavaan)
library(lavaan)
#> This is lavaan 0.6-14
#> lavaan is FREE software! Please report any bugs.
suppressPackageStartupMessages(library(tidyverse))
```

## Generate Latent growth curve model data

To generate data based on the latent growth model with a mean intercept
of 3 and a mean slope of 0.5 using the lavaan package, you can follow
the below code:

``` r
unc.data <- lavaan::simulateData('
                     # Time indicators            
                     I =~ 1*y1 + 1*y2 + 1*y3 + 1*y4 + 1*y5
                     S =~ 0*y1 + 1*y2 + 2*y3 + 3*y4 + 4*y5

                     # GROWTH MEANS
                     I ~ 3*1
                     S ~ 0.5*1
                     
                     # GROWTH Var-Covariance
                     I ~~ 1*I + 0.2*S
                     S ~~ 0.5*S
                     ', 
                     model.type = 'growth',
                     sample.nobs = 500)
```

## Censore data

To censor the generated data, you can use the `cenPoint()` function from
the `clavaan` package, which allows you to set the proportion of
censoring at each end. In this case, the data will be censored at 40%
with 20% at each point. The code would look like this:

``` r
censored_prop <- c(left = 0.2, right = 0.8)

cen_points <- clavaan:::cenPoint(x = unc.data,
                       lower_quant = censored_prop[1],
                       upper_quant = censored_prop[2])


cen.data <- clavaan:::cenData(unc.data, cen_points) %>%
  data.frame() %>%
  set_names(names(unc.data))
```

This will result in a censored dataset with 20% censoring at the lower
end and 20% censoring at the upper end, totaling 40% censoring overall.

## Compare typical MLE and GBIT

To analyze the data using both MLE and GBIT, you can utilize the
`growth()` function from the `lavaan` package for MLE, and the
`cgrowth()` function from the `clavaan` package for GBIT. Employing
these two methods will allow you to compare their performance and better
understand the impact of censoring on your data.

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
#> lavaan 0.6.14 ended normally after 16 iterations
#> 
#>   Estimator                                        GLS
#>   Optimization method                           NLMINB
#>   Number of model parameters                        10
#> 
#>   Number of observations                           500
#> 
#> Model Test User Model:
#>                                                       
#>   Test statistic                                41.381
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
#>     S                 0.134    0.046    2.904    0.004
#> 
#> Intercepts:
#>                    Estimate  Std.Err  z-value  P(>|z|)
#>     I                 2.864    0.055   52.244    0.000
#>     S                 0.527    0.036   14.669    0.000
#>    .y1                0.000                           
#>    .y2                0.000                           
#>    .y3                0.000                           
#>    .y4                0.000                           
#>    .y5                0.000                           
#> 
#> Variances:
#>                    Estimate  Std.Err  z-value  P(>|z|)
#>     I                 0.972    0.102    9.573    0.000
#>     S                 0.542    0.041   13.182    0.000
#>    .y1                0.836    0.092    9.103    0.000
#>    .y2                0.911    0.073   12.427    0.000
#>    .y3                1.004    0.080   12.610    0.000
#>    .y4                0.718    0.083    8.643    0.000
#>    .y5                0.950    0.139    6.828    0.000
```

<!-- </div> -->

### lavaan with censored data

<!-- <div class = "col-md-6"> -->

``` r
growth(model,data = cen.data) %>%
  summary()
#> lavaan 0.6.14 ended normally after 27 iterations
#> 
#>   Estimator                                         ML
#>   Optimization method                           NLMINB
#>   Number of model parameters                        10
#> 
#>   Number of observations                           500
#> 
#> Model Test User Model:
#>                                                       
#>   Test statistic                               131.423
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
#>     S                 0.004    0.021    0.206    0.837
#> 
#> Intercepts:
#>                    Estimate  Std.Err  z-value  P(>|z|)
#>     I                 3.178    0.046   69.221    0.000
#>     S                 0.309    0.018   17.273    0.000
#>    .y1                0.000                           
#>    .y2                0.000                           
#>    .y3                0.000                           
#>    .y4                0.000                           
#>    .y5                0.000                           
#> 
#> Variances:
#>                    Estimate  Std.Err  z-value  P(>|z|)
#>     I                 0.683    0.071    9.652    0.000
#>     S                 0.116    0.011   10.608    0.000
#>    .y1                0.634    0.065    9.818    0.000
#>    .y2                0.696    0.054   12.980    0.000
#>    .y3                0.672    0.049   13.748    0.000
#>    .y4                0.443    0.041   10.906    0.000
#>    .y5                0.262    0.053    4.914    0.000
```

<!-- </div> -->
<!-- </div> -->

### lavaan with original data

``` r
growth(model,data = unc.data) %>%
  summary()
#> lavaan 0.6.14 ended normally after 30 iterations
#> 
#>   Estimator                                         ML
#>   Optimization method                           NLMINB
#>   Number of model parameters                        10
#> 
#>   Number of observations                           500
#> 
#> Model Test User Model:
#>                                                       
#>   Test statistic                                21.408
#>   Degrees of freedom                                10
#>   P-value (Chi-square)                           0.018
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
#>     S                 0.149    0.046    3.217    0.001
#> 
#> Intercepts:
#>                    Estimate  Std.Err  z-value  P(>|z|)
#>     I                 2.871    0.055   51.749    0.000
#>     S                 0.538    0.036   14.980    0.000
#>    .y1                0.000                           
#>    .y2                0.000                           
#>    .y3                0.000                           
#>    .y4                0.000                           
#>    .y5                0.000                           
#> 
#> Variances:
#>                    Estimate  Std.Err  z-value  P(>|z|)
#>     I                 1.011    0.104    9.713    0.000
#>     S                 0.568    0.041   13.688    0.000
#>    .y1                0.855    0.093    9.234    0.000
#>    .y2                0.954    0.075   12.712    0.000
#>    .y3                1.119    0.083   13.508    0.000
#>    .y4                1.019    0.094   10.866    0.000
#>    .y5                0.631    0.128    4.926    0.000
```

``` r
sessionInfo()
#> R version 4.2.2 (2022-10-31 ucrt)
#> Platform: x86_64-w64-mingw32/x64 (64-bit)
#> Running under: Windows 10 x64 (build 19044)
#> 
#> Matrix products: default
#> 
#> locale:
#> [1] LC_COLLATE=English_United States.utf8 
#> [2] LC_CTYPE=English_United States.utf8   
#> [3] LC_MONETARY=English_United States.utf8
#> [4] LC_NUMERIC=C                          
#> [5] LC_TIME=English_United States.utf8    
#> 
#> attached base packages:
#> [1] stats     graphics  grDevices utils     datasets  methods   base     
#> 
#> other attached packages:
#>  [1] forcats_0.5.1   stringr_1.4.0   dplyr_1.0.9     purrr_0.3.4    
#>  [5] readr_2.1.2     tidyr_1.2.0     tibble_3.1.7    ggplot2_3.4.1  
#>  [9] tidyverse_1.3.1 lavaan_0.6-14   clavaan_0.1.0  
#> 
#> loaded via a namespace (and not attached):
#>  [1] lubridate_1.8.0  mvtnorm_1.1-3    assertthat_0.2.1 digest_0.6.29   
#>  [5] utf8_1.2.2       R6_2.5.1         cellranger_1.1.0 backports_1.4.1 
#>  [9] reprex_2.0.1     stats4_4.2.2     evaluate_0.15    httr_1.4.3      
#> [13] pillar_1.7.0     rlang_1.0.6      readxl_1.4.0     rstudioapi_0.13 
#> [17] pbivnorm_0.6.0   rmarkdown_2.14   munsell_0.5.0    broom_0.8.0     
#> [21] compiler_4.2.2   modelr_0.1.8     xfun_0.31        pkgconfig_2.0.3 
#> [25] mnormt_2.1.0     htmltools_0.5.4  tidyselect_1.1.2 quadprog_1.5-8  
#> [29] fansi_1.0.3      crayon_1.5.2     tzdb_0.3.0       dbplyr_2.2.0    
#> [33] withr_2.5.0      MASS_7.3-58.1    grid_4.2.2       jsonlite_1.8.0  
#> [37] gtable_0.3.0     lifecycle_1.0.3  DBI_1.1.3        magrittr_2.0.3  
#> [41] scales_1.2.0     cli_3.3.0        stringi_1.7.6    fs_1.5.2        
#> [45] xml2_1.3.3       ellipsis_0.3.2   generics_0.1.2   vctrs_0.5.2     
#> [49] tools_4.2.2      glue_1.6.2       hms_1.1.1        parallel_4.2.2  
#> [53] fastmap_1.1.0    yaml_2.3.5       colorspace_2.0-3 rvest_1.0.2     
#> [57] knitr_1.39       haven_2.5.0
```
