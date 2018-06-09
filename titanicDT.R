library(rpart)
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


train <- data %>% filter(is.na(Survived) == FALSE)
train$Survived <- as.factor(train$Survived)

test <- data %>% filter(is.na(Survived) == TRUE)
test$Survived <- NULL


train$Sex <- factor(train$Sex)
test$Sex <- factor(test$Sex)

train$Cabin <- factor(train$Cabin)
test$Cabin <- factor(test$Cabin)

train$Embarked <- factor(train$Embarked)
test$Embarked <- factor(test$Embarked)

train$Title <- factor(train$Title)
test$Title <- factor(test$Title)

train$newTicket <- factor(train$newTicket)
test$newTicket <- factor(test$newTicket)

train$Ticket <- factor(train$Ticket)
test$Ticket <- factor(test$Ticket)

train$Name <- factor(train$Name)
test$Name <- factor(test$Name)



#train <- train %>% select(-Name)
#test <- test %>% select(-Name)
# Splitting the train data to predict whether the model created is 
# effective in getting the survivors.
split <- sample(seq_len(nrow(train)), size = floor(0.75 * nrow(train)))
new.train <- train[split,]
new.test <- train[-split,]


#################################
### Decision Tree ###############
#################################
#model_dt = rpart(Survived~., data=new.train, control = rpart.control(minsplit = 10))
#printcp(model_dt)
# View(new.train)


control <- trainControl(method = "cv")
model_dt <- train(Survived~., data=new.train, trControl = control, tuneLength = 15, method = "rpart")
# print(model_dt)

preddt = predict(model_dt, new.test, type = "raw")

mean(preddt == new.test$Survived)



model_dt_test <- train(Survived~., data=train, trControl = control, tuneLength = 15, method = "rpart")
preddt_test <- predict(model_dt_test, test, type = "raw")

solution <- data.frame(PassengerID = test$PassengerId, Survived = preddt_test)
write.csv(solution, file = "solution_dt.csv", row.names = F)
  