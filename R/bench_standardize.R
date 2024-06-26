
##Function creates z-scores for for each dataset across methods and iterations, and then averages them
# ignore is a vector of methods to ignore in computing z-scores
# Paramater Input:
#    bm_comb: raw bm_comb data that will be aggregated over
#    datasets_cv: include if you would like to filter results based on dataset Coefficeint of variation.
#    cv.thresh: vector of lower and upper boundaries for datasets CV to analyze
#    ignore: vector of methods to exclude. Relevant for standarized scores
#

<<<<<<< HEAD
bench_standardize <- function(bm_comb, datasets_cv=NULL, cv.thresh=NULL, ignore=NULL){

 #stores all method shortnames in vector for later labeling after exclusion
 all_rfvs <- levels(factor(bm_comb$rfvs))

 #exclude based on high cv
 if(is.null(cv.thresh)==F){
  bm_comb <- bm_comb[bm_comb$dataset %in% datasets_cv[datasets_cv$cv>cv.thresh[1] & datasets_cv$cv<cv.thresh[2] ,]$name,]
 }

 #exclude methods if specified
=======
bench_standardize <- function(bm_comb_clean, ignore=NULL){

 # exclude methods if specified
>>>>>>> main
 if(is.null(ignore)==F){
  bm_comb_clean <- bm_comb_clean[bm_comb_clean$rfvs %in% ignore==F,]
 }

<<<<<<< HEAD
 #calculate percent variables reduced
 bm_comb <- bm_comb %>% mutate(perc_reduced = 1-n_selected/(n_col-1),
                               log_time = log(as.numeric(time)))

 #define columns to standardize
 z_cols <- c("rsq_axis", "rsq_oblique",
             "time","log_time", "perc_reduced")
=======
 # define columns to standardize
 z_cols <- c("rsq_axis",
             "rsq_oblique",
             "time",
             "log_time",
             "perc_reduced")
>>>>>>> main

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
<<<<<<< HEAD
                "time", "log_time",
                "rsq_axis_z", "rsq_oblique_z",
                "time_z","log_time_z", "perc_reduced_z")
=======
                "time",
                "log_time")
>>>>>>> main


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
              time, log_time,
              rsq_axis_z, rsq_oblique_z,
              time_z,log_time_z, perc_reduced_z),
    .fns = ~ quantile(.x, probs = c(1,2,3) / 4, na.rm = TRUE)
   ),
   quantile = c(25, 50, 75),
   .by = c(rfvs, dataset)
  ) %>%
  pivot_wider(names_from = quantile,
              values_from = all_of(smry_cols))

 smry_by_data <- left_join(mean_se, quants)

<<<<<<< HEAD
 # summary overall -----

 mean_se <- bm_comb %>%
  group_by(rfvs) %>%
  summarize(across(.cols = all_of(smry_cols),
                   .fns = list(mean = ~ mean(.x, na.rm = TRUE),
                               se = ~ sd(.x) / sqrt((length(.x) - 1)))))

 quants <- bm_comb %>%
  reframe(
   across(
    .cols = c(n_selected, perc_reduced,
              rmse_axis, rsq_axis,
              rmse_oblique, rsq_oblique,
              time, log_time,
              rsq_axis_z, rsq_oblique_z,
              time_z,log_time_z, perc_reduced_z),
    .fns = ~ quantile(.x, probs = c(1,2,3) / 4, na.rm = TRUE)
   ),
   quantile = c(25, 50, 75),
   .by = c(rfvs)
  ) %>%
  pivot_wider(names_from = quantile,
              values_from = all_of(smry_cols))

 smry_overall <- left_join(mean_se, quants) %>%
  mutate(dataset = 'overall', .after = rfvs)

 #create new variable called method with long form label name for each VS method
 lab_names <- c("Altman", "Menze", "Permute -\nOblique", "Boruta", "CARET", "Hapfelmeier", "Jiang", "Min Depth \nMedium",
                "Negation", "None", "Permute - \nAxis", "RRF", "Svetnik", "VSURF")
 smry_by_data$method <- factor(smry_by_data$rfvs, levels(factor(smry_by_data$rfvs)), lab_names[all_rfvs %in% levels(factor(smry_by_data$rfvs))])
 smry_overall$method <- factor(smry_overall$rfvs, levels(factor(smry_overall$rfvs)), lab_names[all_rfvs %in% levels(factor(smry_overall$rfvs))])


 list(by_data = smry_by_data,
      overall = smry_overall)
=======
 as.data.frame(smry_by_data)

>>>>>>> main
}


