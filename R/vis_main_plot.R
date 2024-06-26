
# Creates plot that shows R-Squared on x-axis, time on y-axis, and reduction percention as size and shade of points
# Input Paramaters:
#    df: should be list results_z
#    x: must be a measure of R-squared; either "rsq_axis_50", "rsq_axis_mean", "rsq_oblique_50", or "rsq_oblique_mean"
#    y: must be measure of time; either "time_mean", or "time_50"
#    z: must be measure of perent reduction: either "perc_reduced_50" or "perc_reduced_mean"
#    k_clust: number of clusters to select

vis_main_plot <- function(df, x="rsq_axis_50", y = "time_50", z = "perc_reduced_50", k_clust=3){

 df <- df$overall


 ########## Use K-means to find zoom area  ############
 kdf <- df[c(x,y)]
 k1 <- kmeans(kdf, k_clust, nstart=25)
 clust_select <- which.min(1/k1$centers[,1]*k1$centers[,2])[[1]] #select bottom right
 df_zoom <- df[k1$cluster==clust_select,]
 x_lim <- c(min(eval(parse(text=paste("df_zoom$",x))))-.01, max(eval(parse(text=paste("df_zoom$",x))))+.01)
 y_lim <- c(max(c(min(eval(parse(text=paste("df_zoom$",y))))-.01,0)), max(eval(parse(text=paste("df_zoom$",y))))+.01)

 ##################################

 #Sets up dimensions for panel B Zoom
 df <- df %>% mutate(x_in = ifelse(eval(parse(text=x))>= x_lim[1] & eval(parse(text=x)) <= x_lim[2], 1, 0),
                     y_in = ifelse(eval(parse(text=y))>= y_lim[1] & eval(parse(text=y)) <= y_lim[2], 1, 0),
                     zoom = x_in*y_in)

 zoom_means <- df %>% group_by(zoom) %>% summarize(across(c(x,y), mean))
 zoom_means$lab <- "See Panel B"

 #set up label names
 forest_type <- ifelse(grepl("axis", x)==T, " (Axis Forest)", " (Oblique Forest)")

 x_type <- ifelse(grepl("_z",x)==T, "Standardized ", "")
 x_lab <- ifelse(grepl("_z",x)==T, " Z-scores", "")
 x_stat <- ifelse(grepl("mean",x)==T, "Mean ", "Median ")

 y_type <- ifelse(grepl("_z",y)==T, "Standardized ", "")
 y_lab <- ifelse(grepl("_z",y)==T, " Z-scores", "")
 y_stat <- ifelse(grepl("mean",y)==T, "Mean ", "Median ")

 z_type <- ifelse(grepl("_z",z)==T, "Standardized ", "")
 z_lab <- ifelse(grepl("_z",z)==T, " Z-scores", "")
 z_stat <- ifelse(grepl("mean",z)==T, "Mean ", "Median ")


 grob_title <- paste0(x_type,x_stat, "Accuracy by ", y_type, y_stat, "Time by ",
                      z_type,z_stat,
                      "Percent Reduction", forest_type)
 x_label <- paste0("R-Squared", x_lab)
 y_label <- paste0("Time (seconds)", y_lab)
 z_label <- paste0("Percent \nReduction", z_lab)

 if(y_stat=="Median "){
  legend.pos <- c(0,0)
  legend.just <- c(-0.07,-.03)
 } else {
  legend.pos <- c(0,1)
  legend.just <- c(-0.07,1.03)
 }

 z_breaks <- seq(0,1, by=0.2)
 z_lims <- c(0,1)

 if(z_type== "Standardized "){
  z_breaks <- seq(-3,1, by=1)
  z_lims <- c(-3,1)
 }


 #Panel A Plot
 p1a <- ggplot(df, aes(x=eval(parse(text=x)), y=eval(parse(text=y))))+
  geom_point(aes(size=eval(parse(text=z)), color=eval(parse(text=z))))+
  stat_ellipse(data=df[df$zoom==1,], aes(group=zoom), type="norm",level=.98, show.legend = F)+
  geom_text_repel(data=df[df$zoom==0,],
                  aes(label=method),
                  force=10, max.overlaps = Inf, size=4, point.padding = 22,
                  min.segment.length = 0) +
  geom_text(data=zoom_means[zoom_means$zoom==1,],
            aes(label=lab, x=eval(parse(text=x)), y=eval(parse(text=y))),
            nudge_x =  mean(eval(parse(text=paste0("df[df$zoom==1,]$",x)))) -
             min(eval(parse(text=paste0("df[df$zoom==1,]$",x))))-.1)+
  labs(title= "A) All Selection Methods", x=x_label, y=y_label)+
  guides(color= guide_legend(title=z_label), size=guide_legend(title=z_label))+
  scale_size_continuous(limits=z_lims, breaks=z_breaks, range=c(2,15))+
  scale_color_continuous(limits=z_lims, breaks=z_breaks,
                         high = "#132B43", low = "#56B1F7")+
  theme(legend.position = "bottom") + guides(col=guide_legend(nrow=1, title=z_label),
                                             size = guide_legend(nrow=1, title=z_label))

 legend <- ggpubr::get_legend(p1a)

 p1a <- p1a + theme(legend.position="none")


 #Panel B Plot
 p1b <- ggplot(df[df$zoom==1,], aes(x=eval(parse(text=x)), y=eval(parse(text=y)),
                                    color=eval(parse(text=z)), size= eval(parse(text=z))))+
  geom_point()+
  geom_text_repel(aes(label=method, point.size=perc_reduced_mean), force=30,  size=4, point.padding = 22,
                  min.segment.length = 0) +
  scale_size_continuous(limits=z_lims, breaks=z_breaks, range=c(2,15))+
  scale_color_continuous(limits=z_lims, breaks=z_breaks,
                         high = "#132B43", low = "#56B1F7")+
  labs(title= "B) Top Performers", x=x_label, y="")+

  guides(color= guide_legend(title=z_label), size=guide_legend(title=z_label))+
  theme(legend.position="none")

 #Combine Plot
 grid.arrange(grobs=list(p1a, p1b, legend),
              layout_matrix = rbind(
               c(1, 2),
               c(1, 2),
               c(1, 2),
               c(1, 2),
               c(1, 2),
               c(1, 2),
               c(1, 2),
               c(3, 3)),
              top = textGrob(grob_title,
                             gp=gpar(fontsize=15,font=3)))
}


