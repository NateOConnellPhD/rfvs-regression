vis_rsq_median <- function(df, exclude.hap=F, exclude.none=F){
 rspec <- round_spec() %>%
  round_using_decimal(1)

 if(exclude.hap==T){
  df$overall <- df$overall[df$overall$rfvs != "hap",]
 }

 if(exclude.none==T){
  df$overall <- df$overall[df$overall$rfvs != "none",]
 }

 if(exclude.hap ==T & exclude.none==F){
  lab_names <- c("Altman", "Menze", "Permute \nOblique", "Boruta", "CARET", "Jiang", "Min Depth \nMedium",
                 "Negation", "None", "Permute \nAxis", "RRF", "Svetnik", "VSURF")
  meth_names <- c("alt", "anova", "aorsf", "boruta", "caret", "jiang", "mindepth_medium", "negate", "none", "permute",
                  "rrf","svetnik","vsurf")
 } else if(exclude.none==T & exclude.hap==F){
  lab_names <- c("Altman", "Menze", "Permute -\nOblique", "Boruta", "CARET", "Hapfelmeier", "Jiang", "Min Depth \nMedium",
                 "Negation", "Permute - \nAxis", "RRF", "Svetnik", "VSURF")
  meth_names <- c("alt", "anova", "aorsf", "boruta", "caret","hap", "jiang", "mindepth_medium", "negate", "permute",
                  "rrf","svetnik","vsurf")
 } else if(exclude.none==T & exclude.hap==T){
  lab_names <- c("Altman", "Menze", "Permute -\nOblique", "Boruta", "CARET",  "Jiang", "Min Depth \nMedium",
                 "Negation","Permute - \nAxis", "RRF", "Svetnik", "VSURF")
  meth_names <- c("alt", "anova", "aorsf", "boruta", "caret", "jiang", "mindepth_medium", "negate", "permute",
                  "rrf","svetnik","vsurf")
 } else{
  lab_names <- c("Altman", "Menze", "Permute -\nOblique", "Boruta", "CARET", "Hapfelmeier", "Jiang", "Min Depth \nMedium",
                 "Negation", "None", "Permute - \nAxis", "RRF", "Svetnik", "VSURF")
  meth_names <- c("alt", "anova", "aorsf", "boruta", "caret","hap", "jiang", "mindepth_medium", "negate", "none", "permute",
                  "rrf","svetnik","vsurf")
 }

 df$overall$rfvs <- factor(df$overall$rfvs, meth_names, lab_names)

 data_gg <- df$overall %>%
  select(rfvs, matches("^rsq.*_50$")) %>%
  pivot_longer(cols = -rfvs) %>%
  mutate(name = str_extract(name, pattern = "axis|oblique"),
         label = table_value(100 * value, rspec = rspec),
         rfvs = fct_reorder(rfvs, .x = value, .fun = max)) %>%
  group_by(rfvs) %>%
  mutate(hjust = if_else(value == max(value), -0.25, 1.25))

 data_gg$name <- factor(data_gg$name, c("axis", "oblique"), c("Axis", "Oblique"))

 ggplot(data_gg) +
  aes(x = rfvs, y = value, label = label, group = rfvs, color = name) +
  geom_line(color = 'grey50', alpha = 0.6) +
  geom_point() +
  geom_text(hjust = data_gg$hjust, show.legend = FALSE) +
  theme_bw() +
  theme(panel.grid = element_blank(),
        legend.position = c(1,0), legend.justification = c(1.2,-0.2)) +
  coord_flip() +
  scale_y_continuous(limits= c(.33, .45),breaks=seq(from=0.33, to=0.45, .02), expand = c(0.01, 0.01)) +

  labs(x = "Variable selection method",
       y = expression("Prediction accuracy of downstream forest estimated by Median" ~R^2),
       color = "Forest type")

}
