#' Naive Scaling of a Matrix
#'
#' This function adjusts the scale \eqn{\sum_{ij}m_{ij}} of a matrix to be
#' a scalar value by multiplying all values of a matrix by a uniform value.
#'
#' @param A A matrix in either \code{data_frame} or \code{matrix} format.
#' @param scale A constant that the new matrix will be scaled to.
#'
#' @return An object of \code{class(A)} with rescaled values.
#'
#' @examples
#' scale_matrix_naive(test_odmatrix, 1500)
#'
#' @export
scale_matrix_naive <- function(A, scale){

  if(class(A) == "matrix"){
    A * scale / sum(A)
  }


}
