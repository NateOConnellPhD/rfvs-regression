

#Plots distribution results
# input parameters:
#    df = "bm_comb"
#    y = name of metric to plot (e.g. time, log_time, time_z, rsq_axis, rsq_axis_z)
#    plot_by = "mean" or "median" ; plot averaged or medians across runs by method and dataset
#    order_by = "mean" or "median" ; order methods by mean or median
#    ignore = vector of rfvs methods to ignore; same as in bench_standardize

vis_dist_plots <- function(df, y=var, plot_by="median", order_by="median", ignore=NULL){

 df <- bench_standardize(df, ignore=ignore)

 #Define terms to name Plot title and y-axis based on variable assessed
 out_type <- case_when(
         grepl("rsq", y) ~ paste("R-Squared"),
         grepl("log_time", y) ~ paste("Log-Time"),
         grepl("time", y) ~ paste("Time"),
         grepl("perc_reduced",y) ~ paste("Percent Variable Reduction")
        )
 z_type <- ifelse(grepl("_z",y)==T, "Standardized ", "")
 z_lab <- ifelse(grepl("_z",y)==T, " Z-scores", "")
 forest_type <- ifelse(grepl("time", y)==T, "",
                       ifelse(grepl("perc_reduc",y)==T, "",
                              ifelse(grepl("axis", y)==T, " (Axis Forest)", " (Oblique Forest)")))
 main_title <- paste0("Method of Variable Selection by ", z_type, out_type, forest_type)
 y_label <- paste0(out_type, z_lab)


 #order values by variable median
 if(order_by=="mean"){
  order_vars <- eval(parse(text=paste0("df$overall$",y,"_mean")))
 } else if(order_by=="median"){
  order_vars <- eval(parse(text=paste0("df$overall$",y,"_50")))
 }

 if(grepl("time", y)){
  order_vars <- as.vector(df$overall$method[order(order_vars)])
 } else {
  order_vars <-  as.vector(df$overall$method[order(-order_vars)])
 }

  if(plot_by=="mean"){
   ggplot(df$by_data, aes(x=method, y=eval(parse(text=paste0(y,"_mean")))))+geom_boxplot() +
    ggtitle(main_title) +  scale_x_discrete(limits=order_vars)+
    labs(x="", y=y_label)
  } else if(plot_by=="median"){
   ggplot(df$by_data, aes(x=method, y=eval(parse(text=paste0(y,"_50")))))+geom_boxplot() +
    ggtitle(main_title) +  scale_x_discrete(limits=order_vars)+
    labs(x="", y=y_label)
  }
}



