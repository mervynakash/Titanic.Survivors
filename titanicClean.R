set.seed(123)
setwd("E:/Kaggle/Titanic.Survivors/")


#################################
####### Loading libraries #######
#################################


library("dplyr")
library("plyr")
library("stringr")
library("bindrcpp")
library("ROCR")
#library("Metrics")


#################################
######### Reading data ##########
#################################

train <- read.csv("train.csv",
                  header = TRUE,
                  na.strings = c("NA"," ","",NA),
                  stringsAsFactors = FALSE)

test <- read.csv("test.csv",
                 header = TRUE,
                 na.strings = c("NA"," ","",NA),
                 stringsAsFactors = FALSE)

gender <- read.csv("gender_submission.csv",
                   header = TRUE,
                   na.strings = c("NA"," ","",NA),
                   stringsAsFactors = FALSE)



#################################
###### Analysing Dataset ########
#################################

head(train)
no.of.row <- nrow(train)
no.of.col <- ncol(train)

sapply(train, class)
str(train)

# Checking number of missing values in each column.
colNA <- apply(train, 2, function(x) {length(which(is.na(x)==TRUE))})

# Another way of checking missing values
colSums(is.na(train))
colSums(is.na(test))

# Checking for unique values in column
# The removed columns are continues variable which would not be of much help.
sapply(train[,-c(1,4,6,9,10,11,12)], unique)
sapply(test[,-c(1,3,5,8,9,10,11)], unique)

# Getting the summary details of Age and Fare.
summary(train$Age)
summary(test$Age)

summary(train$Fare)
summary(test$Fare)



#################################
######### Combine Data ##########
#################################

# Combining both the data would help in cleaning it efficiently. 
data <- bind_rows(train, test)


#################################
####### Data Manipulation #######
#################################

# This function is used to get the title of the Names.
newVar <- function(string){
  
  tit <- str_split(string, "[.,]")[[1]][2]
  tit <- str_trim(tit, side = "both")
  return(tit)
  
}

data$Title <- sapply(data$Name, newVar)

# Replacing the titles of the people in the ship with their appropriate gender title.
tab <- table(data$Title)

for( i in 1:nrow(data)){
  ch <- names(tab)[i]
  if(ch %in% c("Lady","Mlle","Mme","Ms","the Countess","Dr")){
    data <- mutate(data, Title = str_replace(Title, ch, "Mrs"))
  } else if(ch %in% c("Capt","Col","Jonkheer","Major","Rev","Sir")){
    data <- mutate(data, Title = str_replace(Title, ch, "Mr"))
  }
}
data <- mutate(data, Title = str_replace(Title,"Dona","Mrs"))
data <- mutate(data, Title = str_replace(Title,"Don","Mr"))

# Splitting the ticket value between 0 and 1.
# 0 for those ticket whose value starts with a number.
# 1 for those ticket whose value starts with an alphabet.

ticketVar <- function(string){
  tv <- length(str_split(string, "[ ]")[[1]])
  return(ifelse(tv>1, 1, 0))
}
data$newTicket <- sapply(data$Ticket, ticketVar)


#################################
######## Data Cleaning ##########
#################################

# Changing the missing values of Age to median.
data$Age[is.na(data$Age)==TRUE] <- median(data$Age, na.rm = TRUE)

# Removing the row containing the missing value of Embarked.
data <- data %>% filter(is.na(Embarked) == FALSE)

# Changing the missing values of Fare to median.
data$Fare[is.na(data$Fare) == TRUE] <- median(data$Fare, na.rm = TRUE)

# Changing the missing values of Cabin to Miss.
data$Cabin[is.na(data$Cabin) == TRUE] <- "Miss"

# Converting the Fare value to log() for easier modelling.
data$Fare <- log(data$Fare + 1)

# Removing the extra level of Parch from the data.
data$Parch[which(data$Parch == 9)] <- 0


