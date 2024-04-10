## Load your packages, e.g. library(targets).
source("./packages.R")


library(future)
library(future.callr)
plan(callr)

## Load your R files
lapply(list.files("./R", full.names = TRUE), source)

# needs to be run outside of tar_plan to avoid dynamic branching
# datasets_make(write_data = TRUE)

# if you don't need to update the tasks, just load them
datasets_included <- list.files('data', pattern = "-outcome-") %>%
 str_remove("\\.csv$")

# coordinate labels for variable selection methods in tables/figures
# (figures look nice when the labels include \n for vertical space)
rfvs_key <- tribble(
 ~ rfvs_label,      ~ table_label,        ~ figure_label,
 "alt",             "Altman",             "Altman",
 "anova",           "Menze",              "Menze",
 "aorsf",           "Permute - Oblique",  "Permute -\nOblique",
 "boruta",          "Boruta",             "Boruta",
 "caret",           "CARET",              "CARET",
 "hap",             "Hapfelmeier",        "Hapfelmeier",
 "jiang",           "Jiang",              "Jiang",
 "mindepth_medium", "Min Depth Medium",   "Min Depth \nMedium",
 "negate",          "Negation",           "Negation",
 "none",            "None",               "None",
 "permute",         "Permute - Axis",     "Permute -\nAxis",
 "rrf",             "RRF",                "RRF",
 "svetnik",         "Svetnik",            "Svetnik",
 "vsurf",           "VSURF",              "VSURF"
)

# guides for running the benchmark experiment. Comment out methods seen
#  here to exclude them from the benchmark. Increase runs to add more
#  splits for each dataset.
analyses <- expand_grid(
 dataset = datasets_included,
 rfvs_label = c(
  'rfvs_none',
  'rfvs_permute',
  'rfvs_mindepth_medium',
  # 'rfvs_mindepth_high',
  # 'rfvs_mindepth_low',
  # 'rfvs_cif',
  'rfvs_jiang',
  'rfvs_vsurf',
  'rfvs_caret',
  'rfvs_rrf',
  'rfvs_hap',
  'rfvs_svetnik',
  'rfvs_boruta',
  "rfvs_alt",
  "rfvs_aorsf",
  "rfvs_negate",
  "rfvs_anova"
 ),
 run = 1:5
) %>%
 # filter(dataset %in% c("GeographicalOriginalofMusic-outcome-V100")) %>%
 separate(col = 'dataset',
          into = c('dataset', 'outcome'),
          sep = '-outcome-') %>%
 mutate(rfvs_fun = syms(rfvs_label),
        rfvs_label = str_remove(rfvs_label, '^rfvs_'))

branch_resources <-
 tar_resources(
  future = tar_resources_future(resources = list(n_cores=20))
 )

cols_to_summarize <- c("n_selected",
                       "perc_reduced",
                       "rsq_axis",
                       "rsq_oblique",
                       "time",
                       "log_time")

# Note: targets that start with the term 'datasets' require folder
#  'data/' created above using datasets_make().
tar_plan(

 # Dataset management ----

 # cv = coefficient of variation
 datasets = read_csv('data/datasets_included.csv') %>%
  left_join(datasets_cv(), by = 'name'),

 # Benchmark (i.e., bm) ----

 bm <- tar_map(
  values = analyses,
  names = c(dataset, outcome, rfvs_label, run),
  tar_target(
   bm,
   bench_rfvs(dataset = dataset,
              outcome = outcome,
              label = rfvs_label,
              rfvs = rfvs_fun,
              run = run),
   resources = branch_resources,
   memory = "transient",
   garbage_collection = TRUE
  )
 ),

 # stack benchmark results into one frame
 tar_combine(bm_comb, bm[[1]]),

 #### Create Summary Data Set Z-scores ####
 results_z = bench_standardize(bm_comb, ignore=NULL),

 ###### Datasets summary ##########
 # requires folder 'data/' created above using datasets_make()
 data_cv = datasets_cv(), #calculates coefficient of variation of each data set
 data_full = datasets_full(data_cv), #appends datasets_cv to datasets_selected

 #dataset summary figure. Requires "grid.arrange(fig_datasets_smry)
 fig_datasets_smry = vis_datasets_smry(data_full),

 ###### Results Summary ##########
 # Distribution plots
 fig_log_time = vis_dist_plots(bm_comb, y="log_time", plot_by="median", order_by="median"),
 fig_log_time_z = vis_dist_plots(bm_comb, y="log_time_z", plot_by="median", order_by="median"),

 fig_perc_reduced = vis_dist_plots(bm_comb, y="perc_reduced", plot_by="median", order_by="median"),
 fig_perc_reduced_z = vis_dist_plots(bm_comb, y="perc_reduced_z", plot_by="median", order_by="median"),

 fig_rsq_axis = vis_dist_plots(bm_comb, y="rsq_axis", plot_by="median", order_by="median"),
 fig_rsq_z_axis = vis_dist_plots(bm_comb, y="rsq_axis_z", plot_by="median", order_by="median", ignore="hap"),

 fig_rsq_oblique = vis_dist_plots(bm_comb, y="rsq_oblique", plot_by="median", order_by="median"),
 fig_rsq_z_oblique = vis_dist_plots(bm_comb, y="rsq_oblique_z", plot_by="median", order_by="median", ignore="hap"),


 # Mean and Median R-square by Forest Type
 fig_rsq_median = vis_rsq(results_smry$overall,
                          matches("^rsq.*_50$"), -contains('_z_'),
                          rfvs_key = rfvs_key),

 fig_rsq_means = vis_rsq(results_smry$overall,
                         matches("^rsq.*_mean$"), -contains('_z_'),
                         rfvs_key = rfvs_key),


 # Outputs ----

 # Accuracy by time by Percent Reduction
 fig_main_median_axis = vis_main_plot(results_z, x="rsq_axis_50", y="time_50", z="perc_reduced_50"),
 fig_main_mean_axis = vis_main_plot(results_z, x="rsq_axis_mean", y="time_mean", z="perc_reduced_mean"),

 fig_main_median_oblique = vis_main_plot(results_z, x="rsq_oblique_50", y="time_50", z="perc_reduced_50"),
 fig_main_mean_oblique = vis_main_plot(results_z, x="rsq_oblique_mean", y="time_mean", z="perc_reduced_mean"),

 tar_render(readme, "README.Rmd")

)
