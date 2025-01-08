

#hapfelmeier csda 2013 approach

# Y: response vector
# X: matrix or data frame containing the predictors
# nperm: number of permutations
# ntree: number of trees contained in a forest
# alpha: alpha level for permutation tests
# RETURNS: selected variables, a corresponding forest and the OOB-error
#          with and without Bonferroni-Adjustment

v_select_hap <- function(Y,
                X,
                nperm = 100,
                ntree = 100,
                alpha = 0.05) {

 mtry <- ceiling(sqrt(ncol(X))) # automatically set mtry to sqrt(p)
 dat <- cbind(Y, X) # create the data
 names(dat) <- c("response", paste("V", 1:ncol(X), sep = ""))

 forest <- cforest(response ~ .,
                   data = dat,
                   # fit a forest
                   controls = cforest_unbiased(mtry = mtry, ntree = ntree))

 # compute initial variable importances
 obs.varimp <-
  varimp(forest, pre1.0_0 = T)
 selection <- names(obs.varimp)

 # create a matrix that contains the variable importances after permutation
 perm.mat <- matrix(
  NA,
  ncol = length(selection),
  nrow = nperm,
  dimnames = list(1:nperm, selection)
 )

 # repeat the computational steps for each variable
 for (j in selection) {

  perm.dat <- dat # perm.dat will be the data after permutation

  for (i in 1:nperm) {
   # do nperm permutations
   perm.dat[, j] <- sample(perm.dat[, j]) # permute each variable
   perm.forest <-
    cforest(response ~ .,
            data = perm.dat,
            # recompute the forests
            controls = cforest_unbiased(mtry = mtry, ntree = ntree))
   perm.mat[i, j] <-
    varimp(perm.forest, pre1.0_0 = T)[j]
  }

 }

 # recompute the importances
 p.vals <-
  sapply(selection, function(x)
   sum(perm.mat[, x] # compute p-values
       >= obs.varimp[x]) / nperm)
 p.vals.bonf <-
  p.vals * length(p.vals) # p-values with Bonferroni-Adjustment

 if (any(p.vals < alpha)) {
  # keep significant variables
  selection <- names(p.vals)[which(p.vals < alpha)]
  mtry <- ceiling(sqrt(length(selection)))
  forest <- cforest(
   as.formula(paste(
    "response", paste(selection,
                      collapse = " + "), sep = " ~ "
   )),
   data = dat,
   controls = cforest_unbiased(mtry = mtry, ntree = ntree)
  )
 }

 if (any(p.vals.bonf < alpha)) {
  # keep significant variables (Bonferroni)
  selection.bonf <- names(p.vals.bonf)[which(p.vals.bonf < alpha)]
  mtry <- ceiling(sqrt(length(selection.bonf)))
  forest.bonf <-
   cforest(
    as.formula(paste(
     "response", paste(selection.bonf,
                       collapse = " + "), sep = " ~ "
    )),
    data = dat,
    controls = cforest_unbiased(mtry = mtry, ntree = ntree)
   )
 }

 if (!any(p.vals < alpha)) {
  # if there are not significant variables
  selection <- c()
  forest <- c()
 }

 if (!any(p.vals.bonf < alpha)) {
  # if there are not significant variables
  selection.bonf <- c()
  forest.bonf <- c()
 }

 oob.error <- ifelse(
  length(selection) != 0,
  mean((
   as.numeric(as.character(Y)) -
    as.numeric(as.character(predict(forest, OOB = T)))
  )^2),
  mean((
   as.numeric(as.character(Y)) -
    ifelse(all(Y %in% 0:1),
           round(mean(as.numeric(as.character(Y)))),
           mean(Y))
  )^2)
 )

 oob.error.bonf <- ifelse(
  length(selection.bonf) != 0,
  mean((
   as.numeric(as.character(Y)) -
    as.numeric(as.character(predict(forest.bonf, OOB = T)))
  )^2),
  mean((
   as.numeric(as.character(Y)) - ifelse(all(Y %in% 0:1),
                                        round(mean(
                                         as.numeric(as.character(Y))
                                        )), mean(Y))
  )^2)
 )

 return(
  list(
   "selection" = selection,
   "forest" = forest,
   "oob.error" = oob.error,
   "selection.bonf" = selection.bonf,
   "forest.bonf" = forest.bonf,
   "oob.error.bonf" = oob.error.bonf
  )
 )
}
