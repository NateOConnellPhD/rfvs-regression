



#svetnick 2004 approach, code in hapfelmeier csda 2013
# Y: response vector
# X: matrix or data frame containing the predictors
# ntree: number of trees contained in a forest
# folds: determines 'folds'-fold cross validation
# repetitions: the results of 'repetitons' repetitons should be aggregated
# RETURNS: selected variables, a corresponding forest and OOB-error

svt <- function(Y,
                X,
                ntree = 100,
                folds = 5,
                repetitions = 20) {

 mtry <- ceiling(sqrt(ncol(X))) # automatically set mtry to sqrt(p)

 dat <- cbind(Y, X) # create the data

 names(dat) <- c("response", paste("V", 1:ncol(X), sep = ""))

 forest <- cforest(response ~ .,
                   data = dat,
                   # fit a forest
                   controls = cforest_unbiased(mtry = mtry, ntree = ntree))
 final.imps <-
  names(sort(varimp(forest, pre1.0_0 = T), decreasing = T)) # the final sequence
 errors <- array(NA, dim = c(repetitions, ncol(X) + 1, folds))

 for (x in 1:repetitions) {
  # repeatedly produce results of several...
  samps <- sample(rep(1:folds, length = nrow(X)))
  for (k in 1:folds) {
   # ...crossvalidations
   train <-
    dat[samps != k,]
   test <- dat[samps == k,] # train and test data
   forest <- cforest(response ~ .,
                     data = train,
                     # fit a forest
                     controls = cforest_unbiased(mtry = mtry, ntree = ntree))
   selection <-
    names(sort(varimp(forest, pre1.0_0 = T), decreasing = T))
   for (i in ncol(X):1) {
    # do backward rejection steps
    mtry <- min(mtry, ceiling(sqrt(i)))
    forest <-
     cforest(
      as.formula(paste(
       "response", paste(selection[1:i],
                         collapse = " + "), sep = " ~ "
      )),
      data = train,
      controls = cforest_unbiased(mtry = mtry, ntree = ntree)
     )
    errors[x, i + 1, k] <-
     mean((as.numeric(as.character(test$response)) -
            as.numeric(as.character(
             predict(forest, newdata = test)
            ))) ^ 2)
   }
   errors[x, 1, k] <-
    mean((as.numeric(as.character(test$response)) -
           ifelse(
            all(Y %in% 0:1), round(mean(as.numeric(
             as.character(train$response)
            ))), mean(train$response)
           )) ^ 2)
  }
 }
 mean.errors <-
  sapply(1:(ncol(X) + 1), function(x)
   mean(errors[, x,]))
 optimum.number <-
  which.min(mean.errors)   # optimal number of variables
 if (optimum.number == 1) {
  # determine the final forest, selection and OBB-error
  forest <- c()
  selection <- c()
 }
 if (optimum.number != 1) {
  selection <- final.imps[1:(optimum.number - 1)]
  forest <- cforest(
   as.formula(paste(
    "response", paste(selection,
                      collapse = " + "), sep = " ~ "
   )),
   data = dat,
   controls = cforest_unbiased(mtry = mtry, ntree = ntree)
  )
 }
 error <- mean.errors[optimum.number]
 return(list(
  "selection" = selection,
  "forest" = forest,
  "error" = error
 ))
}
