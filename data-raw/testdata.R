library(tidyverse)

# volume in a made-up OD matrix
volumes <- c(15121, 127, 603, 213, 0, 614, 526, 712,0)
zones <- c("I", "A", "B")   # internal, two external zones

# matrix representation
test_odmatrix <- matrix(volumes, byrow = TRUE, ncol = 3)
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
test_counts <- data_frame(station = zones[-1], aawdt = c(1826, 3212))
devtools::use_data(test_counts, overwrite = TRUE)



