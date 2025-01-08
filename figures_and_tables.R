
# update target figurs and tables
tar_make_future(starts_with(c("fig")), workers=6, shortcut=T)

# Load Target figures and tables

tar_load(starts_with(c("fig", "results", "tab", "data")))

############################################################
################### Primary Results ########################
############################################################

### Export Datasets supplementary table

#write.csv(data_full[,c(1,2,12,13,14,15,16,17,18,20,23)], "supplement_datasets_table.csv", row.names = F)

######## Figures #################
#Dataset Characteristics Plot
grid.arrange(fig_datasets_smry)

#Table of results
tab_main

#Table for when no variables selected
tab_none_sel

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

#Figures Mean and Median Rsq
fig_rsq_median
fig_rsq_means

t1<- ggplot() +
 annotate("text", x = 4, y = 25, size=6,
          label = "Axis", color = "black", fontface="italic") +
 theme_void()

t2<- ggplot() +
 annotate("text", x = 4, y = 25, size=6,
          label = "Oblique", color = "black", fontface="italic") +
 theme_void()

grid.arrange(t1, fig_rsq_means, t2, fig_rsq_median,
             layout_matrix=matrix(c(1,2,2,2,2,3,4,4,4,4), ncol=1, byrow=T))

#Main Figure Median
grid.arrange(fig_main_median)

#Maing figure median complete case
grid.arrange(fig_main_median_cc)


#Main figure Mean
grid.arrange(fig_main_mean)

#Main Figure Median - Complete Case
grid.arrange(fig_main_median_cc)

#Mean and Median; high and low
t1<- ggplot() +
 annotate("text", x = 4, y = 25, size=6,
          label = "N:P < 10", color = "black", fontface="italic") +
 theme_void()

t2<- ggplot() +
 annotate("text", x = 4, y = 25, size=6,
          label = "N:P \u2265 10", color = "black", fontface="italic") +
 theme_void()


grid.arrange(t1, fig_rsq_median_pn_high, t2, fig_rsq_median_pn_low,
             layout_matrix=matrix(c(1,2,2,2,2,2,3,4,4,4,4,4), ncol=1, byrow=T))

#Main Figure - PN High and low
grid.arrange(fig_main_median_axis_pn_high)
grid.arrange(fig_main_median_oblique_pn_high)

grid.arrange(fig_main_median_axis_pn_low)
grid.arrange(fig_main_median_oblique_pn_low)

######## Tables ################

#Table of no variables selected
tab_none_sel

#Table of overall results
tab_main




