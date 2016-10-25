#' Demonstration OD matrix
#'
#' An object of class \code{matrix} containing demonstration OD-flows between
#' three zones.
#'
#'
"test_odmatrix"


#' Demonstration OD data frame
#'
#' An object of class \code{data_frame} containing 9 observations of 3
#' variables:
#' \describe{
#'   \item{origin}{The origin zone, either internal "I" or one of two externals zones.}
#'   \item{destination}{The destination zone.}
#'   \item{volume}{The daily volume flowing from origin to destination}
#' }
"test_oddf"


#' Demonstration external station counts
#'
#' An object of class \code{data_frame} containing 2 observations of 2 variables:
#' \describe{
#'   \item{station}{A station ID corresponding to the external stations in
#'   \code{\link{test_odmatrix}} and \code{\link{test_oddf}}}
#'   \item{aawdt}{Observed traffic volumes at the external station.}
#' }
"test_counts"
