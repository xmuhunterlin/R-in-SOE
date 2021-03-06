# Xavier X. Sala-I-Martin: I Just Ran Two Million Regression (AER, 1997)
# Growth Convergence of 72 countries with 41 variables
# Regression Variables Selection based on Penalized Regression in R
# Using glmnet package: alpha=0 (ridge), alpha=1 (lasso)
# lasso (L1 penality) => fit <- glmnet(x, y, family="gaussian")
# ridge (L2 penality), or using nfolds=10 for CV
# setwd("C:/Course16/WISE2016/R")
growth <- read.csv("C:/Course16/ec510/data/FLS-data.csv")
summary(growth)

# working with data matrices (not standardized)
X <- as.matrix(growth[,-1])
Y <- as.matrix(growth[,1])

# load glmnet package
# glmnet can be used for linear regression (family="gausian")
library(glmnet)

# 1. Ridge Regression
fit1 <- glmnet(X, Y, family="gaussian", alpha=0)
fit1
plot(fit1)
plot(fit1,xvar="lambda")
coef(fit1,s=0.1)  # s=lambda selected

# 2. Least Absolute Shrinkage and Selection Operator
fit2 <- glmnet(X, Y, family="gaussian", alpha=1)
fit2
plot(fit2,label=T)
plot(fit2,xvar="lambda",label=T)
coef(fit2,s=0.05)  # s=lambda selected

# 2a. Least Absolute Shrinkage and Selection Operator
# using 10-fold cross validation to select lambda
# fix a seed for random number generator to run CV
# set.seed(2016) for 3-fold CV (note: total obs. is 72 only)
cvfit2 <- cv.glmnet(X, Y, nfolds=3, family="gaussian", alpha=1)
cvfit2
# cvfit2$lambda.min = lambda with minimum mean cross-validated error
# cvfit2$lambda.1se = lambda for the most reguarlized model 
#                     so that error is within one s.e. of the minimum
plot(cvfit2,label=T)
coef(fit2,s=cvfit2$lambda.min)  # s=lambda selected 
# lambda selected from CV, then apply to model fit2

# model comparison for alpha=0,1,0.5, given lambda=0.05
# compare ridge (alpha=0), lasso (alpha=1), and elastic net (alpha=0.5)
fit <- glmnet(X, Y, family="gaussian", alpha=0, lambda=0.05)
# summarize the fit
fit
# make predictions
predictions <- predict(fit, X, type="link")
# summarize accuracy
rmse <- mean((Y - predictions)^2)
print(rmse)

fit <- glmnet(X, Y, family="gaussian", alpha=1, lambda=0.05)
# summarize the fit
fit
# make predictions
predictions <- predict(fit, X, type="link")
# summarize accuracy
rmse <- mean((Y - predictions)^2)
print(rmse)

# 3. Elastic Net
# fit model
fit <- glmnet(X, Y, family="gaussian", alpha=0.5, lambda=0.05)
# summarize the fit
fit
# make predictions
predictions <- predict(fit, X, type="link")
# summarize accuracy
rmse <- mean((Y - predictions)^2)
print(rmse)
#
# repeated CV method for fit2 model (not run)
cv_vector<-rep(0,100)
for(i in 1:100) {
  cvfit2 <- cv.glmnet(X, Y, nfolds=3, family="gaussian", alpha=1)
  cv_vector[i]=cvfit2$lambda.min
}
median(cv_vector)  # find median value of lambda.min
coef(fit2,s=median(cv_vector))  # s=lambda selected 

