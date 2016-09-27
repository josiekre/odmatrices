#' Scale an external trips matrix
#'
#' In modern big data applications, there is a high probability that the source
#' OD matrix (potentially including IE trips) will not match external station
#' counts. For example, StreetLight provides OD matrices that are normalized for
#' data disclosure and seasonality, and that therefore do not represent the actual
#' flows in the system. This function takes an input matrix and rescales it to
#' match counts at an external via an Iterative Proportional Fitting (IPF,
#' FRATAR, or raking) algorithm.
#'
#' @param df Matrix in \code{data_frame} format, with columns \code{origin},
#'   \code{destination}, and flow columns.
#' @param counts A \code{data_frame} with a \code{station} column indicating
#'   which external station the count represents. There should be a count for
#'   every flow field in \code{df}.
#'
#' @return A \code{data_frame} of the same structure as \code{df}, with columns
#'   added representing the scaled OD flows.
#'
#' @importFrom magrittr '%>%'
#'
#' @export
scale_external_od <- function(df, counts){

  # Join external counts to the matrix

  # Determine IE proportion at each station

  # Fratar EE to get EE' matrix (matching external counts minus IE)

  # Proportionally reallocate IE'

  # Join EE', IE' and return
}
