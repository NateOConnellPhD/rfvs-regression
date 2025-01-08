

#jiang 2004 approach, code in hapfelmeier csda 2013
# Y: response vector
# X: matrix or data frame containing the predictors
# recompute: should the variable importances be recomputed after each
#            regection step? T produces J.0 and J.1
# ntree: number of trees contained in a forest
# RETURNS: selected variables, a corresponding forest and OOB-error for the
#          0 s.e. and 1 s.e. rule

## NOT USED; kept for reference, see [rfvs_jiang]

v_select_jiang <- function(Y,
                           X,
                           recompute = T,
                           ntree = 1000) {

 mtry <- ceiling(sqrt(ncol(X))) # automatically set mtry to sqrt(p)
 dat <- cbind(Y, X) # create the data
 names(dat) <- c("response", paste("V", 1:ncol(X), sep = ""))

 forest <- cforest(response ~ .,
                   data = dat,
                   # fit a forest
                   controls = cforest_unbiased(mtry = mtry, ntree = ntree))
 selections <-
  list() # a list that contains the sequence of selected variables
 selections[[ncol(X)]] <-
  names(sort(varimp(forest, pre1.0_0 = T), decreasing = T))
 errors <- c()

 for (i in ncol(X):1) {
  # take backward rejection steps
  mtry <-
   ceiling(sqrt(i)) # set mtry to sqrt() of remaining variables
  forest <-
   cforest(
    as.formula(paste(
     "response", paste(selections[[i]],
                       collapse = " + "), sep = " ~ "
    )),
    data = dat,
    # fit forest
    controls = cforest_unbiased(mtry = mtry, ntree = ntree)
   )
  errors[i] <-
   mean((as.numeric(as.character(Y)) - # compute the OOB-error
          as.numeric(as.character(
           predict(forest, OOB = T)
          ))) ^ 2)
  # define the next set of variables
  if (recompute == F & i > 1)
   selections[[i - 1]] <- selections[[i]][-i]
  if (recompute == T & i > 1)
   selections[[i - 1]] <-
   names(sort(varimp(forest, pre1.0_0 = T), decreasing = T))[-i]
 }

 # compute the error expected when no predictor is used at all
 errors <-
  c(mean((
   as.numeric(as.character(Y)) - ifelse(all(Y %in% 0:1),
                                        round(mean(
                                         as.numeric(as.character(Y))
                                        )), mean(Y))
  ) ^ 2), errors)
 # define the number of variables determined by the 0 s.e. and 1 s.e. rule
 optimum.number.0se <- which.min(errors)
 optimum.number.1se <-
  which(errors <= min(errors) + 1 * ifelse(all(Y %in% 0:1),
                                           sqrt(min(errors) * (1 - min(
                                            errors
                                           )) / nrow(X)), 0))[1]
 # compute the corresponding forests and OOB-errors
 if (optimum.number.0se == 1) {
  forest.0se <- c()
  selection.0se <- c()
 }
 if (optimum.number.1se == 1) {
  forest.1se <- c()
  selection.1se <- c()
 }
 if (optimum.number.0se != 1) {
  selection.0se <- selections[[optimum.number.0se - 1]]
  forest.0se <-
   cforest(
    as.formula(paste(
     "response", paste(selection.0se,
                       collapse = " + "), sep = " ~ "
    )),
    data = dat,
    controls = cforest_unbiased(mtry = mtry, ntree = ntree)
   )
 }
 if (optimum.number.1se != 1) {
  selection.1se <- selections[[optimum.number.1se - 1]]
  forest.1se <-
   cforest(
    as.formula(paste(
     "response", paste(selection.1se,
                       collapse = " + "), sep = " ~ "
    )),
    data = dat,
    controls = cforest_unbiased(mtry = mtry, ntree = ntree)
   )
 }
 oob.error.0se <- errors[optimum.number.0se]
 oob.error.1se <- errors[optimum.number.1se]
 return(
  list(
   "selection.0se" = selection.0se,
   "forest.0se" = forest.0se,
   "oob.error.0se" = oob.error.0se,
   "selection.1se" = selection.1se,
   "forest.1se" = forest.1se,
   "oob.error.1se" = oob.error.1se
  )
 )
}
