process_data <- function(df, rmse.thresh=NULL, exclude.hap = F, exclude.none=F){
 df <- df$by_data

 if(exclude.hap==T){
  df <- df[df$rfvs != "hap",]
 }

 if(exclude.none==T){
  df <- df[df$rfvs != "none",]
 }



 #average data over runs
 df2 <- df %>% group_by(rfvs, dataset) %>% summarise(n_selected = mean(n_selected),
                                                     n_col = mean(n_col),
                                                     rmse_axis=mean(rmse_axis),
                                                     rsq_axis=mean(rsq_axis),
                                                     rmse_oblique = mean(rmse_oblique),
                                                     rsq_oblique =mean(rsq_oblique),
                                                     time = mean(time))
 #reduce variables with high rmse
 high_vars <- df2 %>% group_by(dataset) %>% dplyr::summarize(rmse_mean = mean(rmse_axis)) %>% arrange(rmse_mean)

 if(is.null(rmse.thresh)==F){
  df2 <- df2[df2$dataset %in% high_vars[high_vars$rmse_mean<rmse.thresh,]$dataset,]
 }


 #create variable for percent reduction in variables
 df2$perc_reduced <- 1-df2$n_selected/(df2$n_col-1)

 sets <- unique(df2$dataset)
 df2 <- as.data.frame(df2)
 df2$rmse_axis_z <- NA
 df2$rmse_oblique_z <- NA
 df2$rsq_axis_z <- NA
 df2$rsq_oblique_z <- NA
 df2$perc_reduced_z <- NA
 df2$time_z <- NA
 for(i in 1:length(sets)){
  df2[df2$dataset==sets[i],]$rmse_axis_z <- (log(df2[df2$dataset==sets[i],]$rmse_axis) -
                                              mean(log(df2[df2$dataset==sets[i],]$rmse_axis)))/sd(log(df2[df2$dataset==sets[i],]$rmse_axis))

  df2[df2$dataset==sets[i],]$rmse_oblique_z <- (log(df2[df2$dataset==sets[i],]$rmse_oblique) -
                                                 mean(log(df2[df2$dataset==sets[i],]$rmse_oblique)))/sd(log(df2[df2$dataset==sets[i],]$rmse_oblique))

  df2[df2$dataset==sets[i],]$rsq_axis_z <- (df2[df2$dataset==sets[i],]$rsq_axis -
                                             mean(df2[df2$dataset==sets[i],]$rsq_axis))/sd(df2[df2$dataset==sets[i],]$rsq_axis)

  df2[df2$dataset==sets[i],]$rsq_oblique_z <- (df2[df2$dataset==sets[i],]$rsq_oblique -
                                                mean(df2[df2$dataset==sets[i],]$rsq_oblique))/sd(df2[df2$dataset==sets[i],]$rsq_oblique)

  df2[df2$dataset==sets[i],]$perc_reduced_z <- (df2[df2$dataset==sets[i],]$perc_reduced -
                                                 mean(df2[df2$dataset==sets[i],]$perc_reduced))/sd(df2[df2$dataset==sets[i],]$perc_reduced)

  df2[df2$dataset==sets[i],]$time_z <- (log(df2[df2$dataset==sets[i],]$time) -
                                         mean(log(df2[df2$dataset==sets[i],]$time)))/sd(log(df2[df2$dataset==sets[i],]$time))

 }


 # Summarize by model types (i.e across datasets)
 df3 <- df2 %>% group_by(rfvs) %>% summarise(n_selected = median(n_selected),
                                             n_col = median(n_col),
                                             perc_reduced = median(perc_reduced),
                                             perc_reduced_sd = sd(perc_reduced),
                                             perc_reduced_z = median(perc_reduced_z),
                                             rmse_axis=median(rmse_axis),
                                             rmse_axis_sd = sd(rmse_axis),
                                             rmse_axis_log=median(log(rmse_axis)),
                                             rmse_axis_log_sd = sd(log(rmse_axis)),
                                             rsq_axis=median(rsq_axis),
                                             rsq_axis_sd = sd(rsq_axis),
                                             rmse_axis_z=median(rmse_axis_z),
                                             rsq_axis_z=median(rsq_axis_z),
                                             rmse_oblique = median(rmse_oblique),
                                             rmse_oblique_sd = sd(rmse_oblique),
                                             rsq_oblique = median(rsq_oblique),
                                             rsq_oblique_sd = sd(rsq_oblique),
                                             rmse_oblique_z = median(rmse_oblique_z),
                                             rsq_oblique_z =median(rsq_oblique_z),
                                             time = median(time),
                                             time_sd = sd(time),
                                             time_z = median(time_z))
 if(exclude.hap ==T & exclude.none==F){
  lab_names <- c("Altman", "Menze", "Permute \nOblique", "Boruta", "CARET", "Jiang", "Min Depth \nMedium",
                 "Negation", "None", "Permute \nAxis", "RRF", "Svetnik", "VSURF")
 } else if(exclude.none==T & exclude.hap==F){
  lab_names <- c("Altman", "Menze", "Permute -\nOblique", "Boruta", "CARET", "Hapfelmeier", "Jiang", "Min Depth \nMedium",
                 "Negation", "Permute - \nAxis", "RRF", "Svetnik", "VSURF")
 } else if(exclude.none==T & exclude.hap==F){
  lab_names <- c("Altman", "Menze", "Permute -\nOblique", "Boruta", "CARET",  "Jiang", "Min Depth \nMedium",
                 "Negation","Permute - \nAxis", "RRF", "Svetnik", "VSURF")
 } else{
  lab_names <- c("Altman", "Menze", "Permute -\nOblique", "Boruta", "CARET", "Hapfelmeier", "Jiang", "Min Depth \nMedium",
                 "Negation", "None", "Permute - \nAxis", "RRF", "Svetnik", "VSURF")
 }
 df2$method <- factor(df2$rfvs, levels(factor(df2$rfvs)), lab_names)
 df3$method <- factor(df3$rfvs, levels(factor(df3$rfvs)), lab_names)

 return(list(results=df2, results.avg=df3))
}
