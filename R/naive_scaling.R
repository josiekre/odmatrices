#' Naively rescale a matrix
#'
#' Sometimes it may be necessary to scale a matrix; as in \eqn{B = xA} where
#'
#' @param A A matrix in either \code{data_frame} or matrix form.
#' @param x If a matrix or a \code{data_frame}, then A will be multiplied by the
#'   ratio of \eqn{\sum_{\forall i j} x_{ij}} to \eqn{\sum_{\forall i j}
#'   A_{ij}}, such that \eqn{\sum_{\forall i j} B_{ij} = \sum_{\forall i j}
#'   x_{ij}}. If \code{x} is a scalar, then \eqn{A} will be scaled to the
#'   same magnitude as \eqn{x}.
#' @param matrix_column_name If \code{A} is a \code{data_frame}, the name of the
#'   column that contains the values requiring scaling.
#' @param scale_column_name If \code{x} is a \code{data_frame}, the name of the
#'   column that contains the values for scaling.
#'
#' @return Either a matrix or a numeric vector (determined by type of
#'   \code{A}), with scaled values.
#'
scale_matrix_naive <- function(A, x, matrix_column_name = NULL,
                               scale_column_name = NULL){

  # Determine if x is matrix or scalar.
  if(is.matrix(x)){
    scale_x <- sum(x)
  } else if (is.data.frame(x)){
    if(is.null(scale_column_name)){
      stop("'scale_column_name' must be supplied for x of class data frame")
    } else {
      scale_x <- sum(x[[scale_column_name]])
    }
  } else {
    # x is just a scalar
    scale_x <- x
  }

  # mutiply Ax
  if(is.matrix(A)){
    scale_A <- sum(A)
    B <- A * (scale_x / scale_A)
  } else {
    if(is.null(scale_column_name)){
      stop("'matrix_column_name' must be supplied for A of class data frame")
    } else {
      scale_A <- sum(A[[matrix_column_name]])
      B <- A[[matrix_column_name]] * (scale_x / scale_A)
    }
  }

  B
}

