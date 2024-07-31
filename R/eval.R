


eval_rmse <- function(estimate, truth){

 sqrt( mean( (estimate - truth)^2 ) )

}

eval_rsq <- function(estimate, truth){

 baseline <- eval_rmse(mean(truth), truth)

 1 - eval_rmse(estimate, truth) / baseline

}
