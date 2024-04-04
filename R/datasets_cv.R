# calculate coefficient of variation across datasets
datasets_cv <- function(){

 df <- list.files('data', pattern = "-outcome-") %>%
  str_remove("\\.csv$")

 cv_list <- NULL

 for(i in 1:length(df)){

  temp_df <- read.csv(paste("data/", df[i], ".csv", sep=""))

  cv_list[[i]] <- data.frame(
   name = gsub("(-outcome).*", "", df[i]),
   cv = abs(sd(temp_df$outcome, na.rm = T) / mean(temp_df$outcome, na.rm = T)))

 }

 bind_rows(cv_list)

}

