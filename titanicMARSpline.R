library(earth)
library(caret)
library(dplyr)


rmarkdown::render("titanicClean.R")


#################################
######### Dividing Data #########
#################################

data$Sex <- factor(data$Sex)
data$Cabin <- factor(data$Cabin)
data$Embarked <- factor(data$Embarked)
data$Title <- factor(data$Title)
data$newTicket <- factor(data$newTicket)
data$Name <- factor(data$Name)
data$Ticket <- factor(data$Ticket)

data$Name <- NULL
data$Ticket <- NULL
data$Cabin <- NULL


train <- data %>% filter(is.na(Survived) == FALSE)
train$Survived <- as.factor(train$Survived)

test <- data %>% filter(is.na(Survived) == TRUE)
test$Survived <- NULL


# Splitting the train data to predict whether the model created is 
# effective in getting the survivors.
split <- sample(seq_len(nrow(train)), size = floor(0.75 * nrow(train)))
new.train <- train[split,]
new.test <- train[-split,]

#=================== MARSpline ===========================#

model_mars_for <- earth(Survived~., data = new.train, pmethod = "forward")
pred_mars_for <- as.numeric(predict(model_mars_for, new.test, type = "class"))
mean(pred_mars_for == new.test$Survived)

model_mars_back <- earth(Survived~., data = new.train, pmethod = "backward")
pred_mars_back <- as.numeric(predict(model_mars_back, new.test, type = "class"))
mean(pred_mars_back == new.test$Survived)

model_mars_cv <- earth(Survived~., data = new.train, pmethod = "cv", nfold = 10, ncross = 3)
pred_mars_cv <- as.numeric(predict(model_mars_cv, new.test, type = "class"))
mean(pred_mars_cv == new.test$Survived)


#=================== MARSpline Final - Forward Pruning =====================#

model_mars_for_final <- earth(Survived~., data = train, pmethod = "forward")
pred_mars_for_final <- as.numeric(predict(model_mars_for_final, test, type = "class"))

solution_mars_for <- data.frame(PassengerID = test$PassengerId, Survived = pred_mars_for_final)
write.csv(solution_mars_for, file = "solution_mars_for.csv", row.names = F)

#=================== MARSpline Final - Backward Pruning ====================#

model_mars_back_final <- earth(Survived~., data = train, pmethod = "backward")
pred_mars_back_final <- as.numeric(predict(model_mars_back_final, test, type = "class"))

solution_mars_back <- data.frame(PassengerID = test$PassengerId, Survived = pred_mars_back_final)
write.csv(solution_mars_back, file = "solution_mars_back.csv", row.names = F)

#=================== MARSpline Final - Cross-validation ====================#

model_mars_cv_final <- earth(Survived~., data = train, pmethod = "cv", nfold = 10, ncross = 3)
pred_mars_cv_final <- as.numeric(predict(model_mars_cv_final, test, type = "class"))

solution_mars_cv <- data.frame(PassengerID = test$PassengerId, Survived = pred_mars_cv_final)
write.csv(solution_mars_cv, file = "solution_mars_cv.csv", row.names = F)
