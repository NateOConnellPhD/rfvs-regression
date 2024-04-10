datasets_full <- function(data_cv){
 df <- read.csv("data/datasets_included.csv")
 df <- merge(df, data_cv, by="name")
}
