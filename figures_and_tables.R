1
tar_load(c("fig_datasets_smry",
           "fig_log_time", "fig_log_time_z",
           "fig_perc_reduced", "fig_perc_reduced_z",
           "fig_rsq_axis", "fig_rsq_z_axis",
           "fig_rsq_oblique", "fig_rsq_z_oblique",
           "fig_main_median_axis",
           "fig_main_mean_axis",
           "fig_main_median_oblique",
           "fig_main_mean_oblique"))

######## Figures #################

#Dataset Characteristics Plot
grid.arrange(fig_datasets_smry)

#Computation Time Distributions
grid.arrange(fig_log_time, fig_log_time_z,
             layout_matrix=matrix(c(1,2), ncol=1, byrow=T))

#Computation Percetn Reduced distributions
grid.arrange(fig_perc_reduced, fig_perc_reduced_z,
             layout_matrix=matrix(c(1,2), ncol=1, byrow=T))

#Computation R-square Reduced distributions
grid.arrange(fig_rsq_axis, fig_rsq_z_axis,
             layout_matrix=matrix(c(1,2), ncol=1, byrow=T))

grid.arrange(fig_rsq_oblique, fig_rsq_z_oblique,
             layout_matrix=matrix(c(1,2), ncol=1, byrow=T))

#Main Figure Median
grid.arrange(fig_main_median_axis)
grid.arrange(fig_main_median_oblique)

#Main figure Mean
grid.arrange(fig_main_mean_axis)
grid.arrange(fig_main_mean_oblique)

#Main figure for High CV
grid.arrange(fig_main_median_cv)

######## Tables ################

#Table of no variables selected
tab_novar(bm_comb)



results_z$overall %>% kbl %>% kable_styling()
names(df)

df <- results_z$overall
res_sum <- data.frame(Method=df$method,
                      stat  = rep(c("Mean (SD)<br>Median [IQR]"), 2),
                      rsq_axis = paste(round(df$rsq_axis_mean,2), " (", round(df$rsq_axis_se,3),")<br>",
                                       round(df$rsq_axis_50,2), " [", round(df$rsq_axis_25,3), ", ",round(df$rsq_axis_25,3),"]"),
                      rsq_oblique = paste(round(df$rsq_oblique_mean,2), " (", round(df$rsq_oblique_se,3),")<br>",
                                       round(df$rsq_oblique_50,2), " [", round(df$rsq_oblique_25,3), ", ",round(df$rsq_oblique_25,3),"]", sep=""),
                      pr = paste(round(df$perc_reduced_mean,2), " (", round(df$perc_reduced_se,3),")<br>",
                                       round(df$perc_reduced_50,2), " [", round(df$perc_reduced_25,3), ", ",round(df$perc_reduced_25,3),"]"),
                      time = paste(round(df$time_mean,2), " (", round(df$time_se,3),")<br>",
                                 round(df$time_50,2), " [", round(df$time_25,3), ", ",round(df$time_25,3),"]")

                      )
Hmisc::label(res_sum$stat) <-""
Hmisc::label(res_sum$rsq_axis) <-"R-Squared (Axis)"
Hmisc::label(res_sum$rsq_oblique) <-"R-Squared (Oblique)"
Hmisc::label(res_sum$pr) <-"Variable Percent Reduced"
Hmisc::label(res_sum$time) <-"Time (seconds)"
rs <- seq(from=1,to=14)
rs1 <- seq(from=1, to=27, by=2)
rs2 <- seq(from=2, to=28, by=2)

res_sum %>%  kbl("html", escape=F, align = "c") %>% kable_styling(position="center") %>%
 pack_rows(res_sum$Method[1],1,2)%>%pack_rows(res_sum$Method[2],3,4)%>%pack_rows(res_sum$Method[3],5,6)%>%
 pack_rows(res_sum$Method[4],7,8)%>%pack_rows(res_sum$Method[5],9,10)%>%pack_rows(res_sum$Method[6],11,12)%>%
 pack_rows(res_sum$Method[7],13,14)%>%pack_rows(res_sum$Method[8],15,16)%>%pack_rows(res_sum$Method[9],17,18)%>%
 pack_rows(res_sum$Method[10],19,20)%>%pack_rows(res_sum$Method[11],21,22)%>%pack_rows(res_sum$Method[12],23,24)%>%
 pack_rows(res_sum$Method[13],25,26)%>%pack_rows(res_sum$Method[14],27,28)
