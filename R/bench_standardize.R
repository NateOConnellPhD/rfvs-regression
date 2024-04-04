
#Function creates z-scores for for each dataset across methods and iterations, and then averages them
# ignore is a vector of methods to ignore in computing z-scores

bench_standardize <- function(bm_comb_clean, ignore=NULL){

 # exclude methods if specified
 if(is.null(ignore)==F){
  bm_comb_clean <- bm_comb_clean[bm_comb_clean$rfvs %in% ignore==F,]
 }

 # define columns to standardize
 z_cols <- c("rsq_axis",
             "rsq_oblique",
             "time",
             "log_time",
             "perc_reduced")

 # standardize columns
 bm_comb_clean <- bm_comb_clean %>%
  group_by(dataset,run) %>%
  mutate(across(.cols = all_of(z_cols), .fns = list(z = ~scale(.x)[,1]))) %>%
  ungroup()

 smry_cols <- c("n_selected",
                "perc_reduced",
                "rmse_axis",
                "rsq_axis",
                "rmse_oblique",
                "rsq_oblique",
                "time",
                "log_time")


 # summary for each dataset ----

 mean_se <- bm_comb %>%
  group_by(rfvs, dataset) %>%
  summarize(across(.cols = all_of(smry_cols),
                   .fns = list(mean = ~ mean(.x, na.rm = TRUE),
                               se = ~ sd(.x) / (length(.x) - 1))))

 quants <- bm_comb %>%
  reframe(
   across(
    .cols = c(n_selected, perc_reduced,
              rmse_axis, rsq_axis,
              rmse_oblique, rsq_oblique,
              time, log_time),
    .fns = ~ quantile(.x, probs = c(1,2,3) / 4, na.rm = TRUE)
   ),
   quantile = c(25, 50, 75),
   .by = c(rfvs, dataset)
  ) %>%
  pivot_wider(names_from = quantile,
              values_from = all_of(smry_cols))

 smry_by_data <- left_join(mean_se, quants)

 as.data.frame(smry_by_data)

}


