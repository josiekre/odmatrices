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
#' @param od_matrix Matrix in \code{data_frame} format, with columns \code{origin},
#'   \code{destination}, and \code{volume}. See \code{\link{test_oddf}}
#' @param counts A \code{data_frame} with a \code{station} column indicating
#'   which external station the count represents, and a \code{aawdt} column
#'   containing the count volume. See \code{\link{test_counts}}
#'
#' @return A \code{data_frame} of the same structure as \code{od_matrix}, with columns
#'   added representing the scaled OD flows.
#'
#' @details The function balances the input \code{od_matrix} and assumes that
#'   flows are symmetrical in a day.
#'
#' @importFrom magrittr '%>%'
#' @importFrom dplyr mutate group_by summarise filter left_join select
#'   mutate_each transmute
#' @importFrom tidyr spread
#'
#' @export
scale_external_od <- function(od_matrix, counts){

  # balance input trip table
  od_balanced <- balance_matrix(od_matrix)

  # calculate EE share at each station
  ie_shares <- od_balanced %>%
    dplyr::mutate(
      ee = ifelse(
        origin %in% counts$station & destination %in% counts$station,
        1, 0)
    ) %>%
    dplyr::group_by(origin) %>%
    dplyr::summarise(
      ee = sum(ee * volume),
      volume = sum(volume),
      ee_share = ee / volume  # origin side externals / total volume
    ) %>%
    dplyr::filter(origin %in% counts$station)

  # discount external station counts by ie share to use as targets
  targets_df <- dplyr::left_join(counts, ie_shares, by = c("station" = "origin")) %>%
    dplyr::mutate(
      ee_target = aawdt/2 * ee_share,
      ie_target = aawdt/2 - ee_target
    )

  targets <- list()
  targets$destination <- targets$origin <- targets_df %>%
    dplyr::select(station, ee_target) %>%
    dplyr::mutate(ID = 1) %>%
    tidyr::spread(station, ee_target)

  # extract seed ee matrix from origin, and fratar to external counts
  seed <- od_balanced %>%
    dplyr::filter(origin %in% counts$station & destination %in% counts$station) %>%
    dplyr::transmute(origin, destination, weight = volume)
  reweighted <- ipfr::ipf(seed = seed, targets = targets)


  # adjust IE trips to match both counts and adjusted external share
  output <- od_balanced %>% ungroup() %>%
    # starting is the balanced observed OD matrix
    rename(starting = volume) %>%
    dplyr::left_join(
      reweighted %>% select(-ID, ee = weight),
      by = c("origin", "destination")
    ) %>%

    # origin-side
    # The internal-external cells equal the split observed in the balanced od matrix,
    # scaled to what is left over from the counts.
    dplyr::left_join(
      targets_df %>% transmute(origin = station, aawdt = aawdt/2), # one-way counts
      by = c("origin")
    ) %>%
    dplyr::group_by(origin) %>%
    dplyr::mutate(
      # identify which cells are internal and external
      ee = ifelse(is.na(ee), 0, ee),
      ix = ifelse(origin %in% counts$station & !(destination %in% counts$station), 1, 0),
      ie_split = (starting * ix) / sum(starting * ix),
      ie_volume = ie_split * (aawdt - sum(ee, na.rm = TRUE))
    ) %>%
    select(-aawdt) %>% ungroup() %>%

    # destination-side
    dplyr::left_join(
      targets_df %>% transmute(destination = station, aawdt = aawdt/2),
      by = c("destination")
    ) %>%
    dplyr::group_by(destination) %>%
    dplyr::mutate(
      xi = ifelse(destination %in% counts$station & !(origin %in% counts$station), 1, 0),
      ei_split = (starting * xi) / sum(starting * xi),
      ei_volume = ei_split * (aawdt - sum(ee, na.rm = TRUE))
    ) %>%
    dplyr::mutate_each(funs(ifelse(is.na(.), 0, .)), ee, ie_volume, ei_volume) %>%
    ungroup() %>%

    # total
    dplyr::transmute(origin, destination, volume = ee + ie_volume + ei_volume)

  return(output)


}
