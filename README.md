
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
#> This is lavaan 0.6-12
#> lavaan is FREE software! Please report any bugs.
library(tidyverse)
#> ── Attaching packages
#> ───────────────────────────────────────
#> tidyverse 1.3.2 ──
#> ✔ ggplot2 3.4.0      ✔ purrr   0.3.5 
#> ✔ tibble  3.1.8      ✔ dplyr   1.0.10
#> ✔ tidyr   1.2.1      ✔ stringr 1.4.1 
#> ✔ readr   2.1.3      ✔ forcats 0.5.2
#> Warning: package 'ggplot2' was built under R version 4.2.2
#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> ✖ dplyr::filter() masks stats::filter()
#> ✖ dplyr::lag()    masks stats::lag()
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
#> lavaan 0.6-12 ended normally after 17 iterations
#> 
#>   Estimator                                        GLS
#>   Optimization method                           NLMINB
#>   Number of model parameters                        10
#> 
#>   Number of observations                           500
#> 
#> Model Test User Model:
#>                                                       
#>   Test statistic                                 9.852
#>   Degrees of freedom                                10
#>   P-value (Chi-square)                           0.454
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
#>     S                 0.116    0.044    2.657    0.008
#> 
#> Intercepts:
#>                    Estimate  Std.Err  z-value  P(>|z|)
#>     I                 3.035    0.055   54.838    0.000
#>     S                 0.519    0.034   15.379    0.000
#>    .y1                0.000                           
#>    .y2                0.000                           
#>    .y3                0.000                           
#>    .y4                0.000                           
#>    .y5                0.000                           
#> 
#> Variances:
#>                    Estimate  Std.Err  z-value  P(>|z|)
#>     I                 0.993    0.105    9.434    0.000
#>     S                 0.483    0.037   13.160    0.000
#>    .y1                0.832    0.094    8.895    0.000
#>    .y2                1.063    0.082   12.903    0.000
#>    .y3                1.057    0.081   13.026    0.000
#>    .y4                1.056    0.095   11.062    0.000
#>    .y5                0.711    0.131    5.447    0.000
```

<!-- </div> -->

### lavaan with censored data

<!-- <div class = "col-md-6"> -->

``` r
growth(model,data = cen.data) %>%
  summary()
#> lavaan 0.6-12 ended normally after 28 iterations
#> 
#>   Estimator                                         ML
#>   Optimization method                           NLMINB
#>   Number of model parameters                        10
#> 
#>   Number of observations                           500
#> 
#> Model Test User Model:
#>                                                       
#>   Test statistic                               106.546
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
#>     S                 0.011    0.019    0.604    0.546
#> 
#> Intercepts:
#>                    Estimate  Std.Err  z-value  P(>|z|)
#>     I                 3.342    0.044   75.630    0.000
#>     S                 0.297    0.017   17.902    0.000
#>    .y1                0.000                           
#>    .y2                0.000                           
#>    .y3                0.000                           
#>    .y4                0.000                           
#>    .y5                0.000                           
#> 
#> Variances:
#>                    Estimate  Std.Err  z-value  P(>|z|)
#>     I                 0.606    0.066    9.169    0.000
#>     S                 0.099    0.010   10.150    0.000
#>    .y1                0.629    0.063    9.953    0.000
#>    .y2                0.745    0.056   13.274    0.000
#>    .y3                0.674    0.049   13.857    0.000
#>    .y4                0.549    0.045   12.098    0.000
#>    .y5                0.170    0.050    3.393    0.001
```

<!-- </div> -->
<!-- </div> -->

### lavaan with original data

``` r
growth(model,data = unc.data) %>%
  summary()
#> lavaan 0.6-12 ended normally after 32 iterations
#> 
#>   Estimator                                         ML
#>   Optimization method                           NLMINB
#>   Number of model parameters                        10
#> 
#>   Number of observations                           500
#> 
#> Model Test User Model:
#>                                                       
#>   Test statistic                                 5.946
#>   Degrees of freedom                                10
#>   P-value (Chi-square)                           0.820
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
#>     S                 0.133    0.046    2.896    0.004
#> 
#> Intercepts:
#>                    Estimate  Std.Err  z-value  P(>|z|)
#>     I                 3.015    0.056   53.616    0.000
#>     S                 0.524    0.035   15.192    0.000
#>    .y1                0.000                           
#>    .y2                0.000                           
#>    .y3                0.000                           
#>    .y4                0.000                           
#>    .y5                0.000                           
#> 
#> Variances:
#>                    Estimate  Std.Err  z-value  P(>|z|)
#>     I                 0.984    0.108    9.070    0.000
#>     S                 0.497    0.038   12.957    0.000
#>    .y1                0.947    0.101    9.348    0.000
#>    .y2                1.121    0.086   13.023    0.000
#>    .y3                1.035    0.080   12.961    0.000
#>    .y4                1.061    0.100   10.607    0.000
#>    .y5                0.968    0.146    6.644    0.000
```
