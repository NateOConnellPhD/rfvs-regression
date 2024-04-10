
# df = results_smry$overall

vis_rsq <- function(df,
                    ...,
                    rfvs_key,
                    exclude = c("none", "hap")){

 rspec <- round_spec() %>%
  round_using_decimal(1)

 if(!is.null(exclude)){

  df <- filter(df, !(rfvs %in% exclude))

 }

 data_gg <- df %>%
  select(rfvs, ...) %>%
  pivot_longer(cols = -rfvs) %>%
  mutate(name = str_extract(name, pattern = "axis|oblique"),
         name = str_to_title(name),
         label = table_value(100 * value, rspec = rspec),
         rfvs = recode(rfvs, !!!as_fig_recoder(rfvs_key)),
         rfvs = fct_reorder(rfvs, .x = value, .fun = max)) %>%
  group_by(rfvs) %>%
  mutate(hjust = if_else(value == max(value), -0.25, 1.25))

 ggplot(data_gg) +
  aes(x = rfvs, y = value, label = label, group = rfvs, color = name) +
  geom_line(color = 'grey50', alpha = 0.6) +
  geom_point() +
  geom_text(hjust = data_gg$hjust, show.legend = FALSE) +
  theme_bw() +
  theme(panel.grid = element_blank(),
        legend.position = 'inside',
        legend.position.inside = c(0.9,0.15)) +
  coord_flip() +
  scale_y_continuous(limits= c(.33, .45),
                     breaks=seq(from=0.33, to=0.45, .02),
                     expand = c(0.01, 0.01)) +

  labs(x = "Variable selection method",
       y = expression("Prediction accuracy of downstream forest estimated by Median" ~R^2),
       color = "Forest type")

}

