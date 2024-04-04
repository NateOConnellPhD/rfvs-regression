datasets_full <- function(){
 df <- read.csv("data/datasets_included.csv")
 df <- merge(df, datasets_cv, by="name")
}
