library("dplyr")
library("plyr")
library("stringr")
library("bindrcpp")
library("ROCR")
library(rmarkdown)
library(knitr)
library(RCurl)


setwd("E:/Kaggle/Titanic.Survivors/")

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


#################################
######## Creating Model #########
#################################

# Creating a model using Generalized Linear Regression.
model <- glm(Survived ~ ., family = binomial(link = 'logit'), data = train[,-c(1,4,9)], control = list(maxit = 50))
anova(model, test = "Chisq")

# Creating a second model after the checking the p-values from the above model.
model2 <- glm(Survived ~ Pclass + Sex + Age + SibSp + Fare + Title,
              data = train,
              family = binomial(link = "logit"),
              control = list(maxit = 50))
summary(model2)

# Comparing the 2 created models.
anova(model, model2, test = "Chisq")

#################################
# Predicting the data on train ##
#################################

# Splitting the train data to predict whether the model created is 
# effective in getting the survivors.
split <- sample(seq_len(nrow(train)), size = floor(0.75 * nrow(train)))
new.train <- train[split,]
new.test <- train[-split,]

model.random <- glm(Survived ~ Pclass + Sex + Age + SibSp + Fare + Title,
                    data = new.train,
                    family = binomial(link = "logit"),
                    control = list(maxit = 50))

predict.random <- predict(model.random, newdata = new.test, type = "response")
predict.random <- ifelse(predict.random > 0.5, 1, 0)

# Using the ROCR Package to get the AUC value to know whether 
# the model is effective.
pr <- prediction(predict.random, new.test$Survived)
perf <- performance(pr, measure = "tpr", x.measure = "fpr")
plot(perf)

#auc(new.test$Survived, predict.random)
# AUC = 0.842

#################################
#### Solution from the model ####
#################################


# Applying the model in the test data.
predict.model <- predict(model2, newdata = test, type = "response")
predict.model <- ifelse(predict.model > 0.5, 1, 0)

# Saving the predicted the values in another file.
solution <- data.frame(PassengerID = test$PassengerId, Survived = predict.model)
write.csv(solution, file = "solution.csv", row.names = FALSE)



#################################
########## THANK YOU ############
#################################
