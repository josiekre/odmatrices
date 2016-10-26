library(tidyverse)

# volume in a made-up OD matrix
zones <- c("I1", "I2", "A", "B", "C")   # two internal, three external zones
volumes <- c(
  7834, 7625, 127, 603, 231,
  6439, 8916, 913, 275, 108,
  285, 827, 0, 519, 947,
  816, 301, 371, 0, 821,
  213, 341, 726, 712, 0)

# matrix representation
test_odmatrix <- matrix(volumes, byrow = TRUE, ncol = 5)
colnames(test_odmatrix) <- rownames(test_odmatrix) <- zones
devtools::use_data(test_odmatrix, overwrite = TRUE)

# dataframe representation
test_oddf <- expand.grid(
  destination = zones, origin = zones, stringsAsFactors = FALSE
) %>%
  tbl_df() %>%
  mutate(volume = volumes) %>%
  select(origin, destination, volume)
devtools::use_data(test_oddf, overwrite = TRUE)

# counts
test_counts <- data_frame(station = zones[3:length(zones)], aawdt = c(4218, 3805, 5213))
devtools::use_data(test_counts, overwrite = TRUE)



