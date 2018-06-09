library(randomForest)
library(caret)


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



#=================== Random Forest =====================#

mtry1 <- floor(sqrt(ncol(new.train)-1))

mtry_new <- c(mtry1-1,mtry1,mtry1+1,mtry1+2,mtry1+3)
acc <- c()
sens <- c()

for(i in mtry_new){
  model_rf <- randomForest(Survived~., data = new.train, mtry = i, ntree = 100)
  pred_rf <- predict(model_rf, new.test)
  cm <- confusionMatrix(pred_rf, new.test$Survived, positive = "1")
  acc <- c(acc, cm$overall['Accuracy'])
  sens <- c(sens,cm$byClass['Sensitivity'])
}

pos = which.max(acc)

control = trainControl(method = "repeatedcv", repeats = 3)

model_rf_final <- train(Survived~., data = train, method = "rf", tuneLength = 10, trControl = control)
pred_rf_final2 <- predict(model_rf_final, test)


mtry_final <- mtry_new[pos]

model_rf_final <- randomForest(Survived~., data=train, mtry = mtry_final-1, ntree = 500)
pred_rf_final <- predict(model_rf_final, test)

solution_df <- data.frame(PassengerID = test$PassengerId, Survived = pred_rf_final2)
write.csv(solution_df, file = "solution_rf.csv", row.names = F)
