# .onAttach <- function(libname, pkgname) {
#   version <- read.dcf(file=system.file("DESCRIPTION", package=pkgname),
#                       fields="Version")
#   packageStartupMessage("This is ",paste(pkgname, version))
#   packageStartupMessage('Censored SEM via lavaan')
# }
