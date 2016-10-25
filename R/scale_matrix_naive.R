#' Naive Scaling of a Matrix
#'
#' This function adjusts the scale \eqn{\sum_{ij}m_{ij}} of a matrix to be
#' a scalar value by multiplying all values of a matrix by a uniform value.
#'
#' @param A A matrix in either \code{data.frame} or \code{matrix} format.
#' @param scale A constant that the new matrix will be scaled to.
#' @param matrix_field A character string giving the field that needs to be
#'   scaled.
#'
#' @return An object of \code{class(A)} with rescaled values.
#'
#' @examples
#' scale_matrix_naive(test_odmatrix, 1500)
#' scale_matrix_naive(test_oddf, 25125, "volume")
#' @export
scale_matrix_naive <- function(A, scale, matrix_field = NULL){

  if(is.matrix(A)){
    A * scale / sum(A)
  } else if(inherits(A, "data.frame")){
    if(is.null(matrix_field)) stop("Please specify which field contains the matrix.")

    A[[matrix_field]] <- A[[matrix_field]] * scale / sum(A[[matrix_field]])
    A

  } else {
    stop("A must be either a matrix or a data frame")
  }


}
