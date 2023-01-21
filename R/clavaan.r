#' @import lavaan

#' cgrowth
cgrowth <- function(model = NULL, data = NULL, bounds = NULL, ...) {

  mc <- match.call(expand.dots = TRUE)

  sample.info <- cMulti(data, bounds)

  colnames(sample.info[[2]]) <- names(data)
  rownames(sample.info[[2]]) <- names(data)

  mc$sample.nobs = nrow(data)
  mc$sample.mean = sample.info[[1]]
  mc$sample.cov = sample.info[[2]]

  mc[['bounds']] <- NULL
  mc[['data']] <- NULL

  mc[[1L]] <- quote(lavaan::growth)
  eval(mc, parent.frame())
}

#' csem
cgrowth <- function(model = NULL, data = NULL, bounds = NULL, ...) {

  mc <- match.call(expand.dots = TRUE)

  sample.info <- cMulti(data, bounds)

  colnames(sample.info[[2]]) <- names(data)
  rownames(sample.info[[2]]) <- names(data)

  mc$sample.nobs = nrow(data)
  mc$sample.mean = sample.info[[1]]
  mc$sample.cov = sample.info[[2]]

  mc[['bounds']] <- NULL
  mc[['data']] <- NULL

  mc[[1L]] <- quote(lavaan::sem)
  eval(mc, parent.frame())
}

#' ccfa
cgrowth <- function(model = NULL, data = NULL, bounds = NULL, ...) {

  mc <- match.call(expand.dots = TRUE)

  sample.info <- cMulti(data, bounds)

  colnames(sample.info[[2]]) <- names(data)
  rownames(sample.info[[2]]) <- names(data)

  mc$sample.nobs = nrow(data)
  mc$sample.mean = sample.info[[1]]
  mc$sample.cov = sample.info[[2]]

  mc[['bounds']] <- NULL
  mc[['data']] <- NULL

  mc[[1L]] <- quote(lavaan::sem)
  eval(mc, parent.frame())
}

bimat <- function(x) {
  matrix(x, ncol=2)
}
