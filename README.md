# Titanic.Survivors

The sinking of the RMS Titanic is one of the most infamous shipwrecks in history.  On April 15, 1912, during her maiden voyage, the Titanic sank after colliding with an iceberg, killing 1502 out of 2224 passengers and crew. This sensational tragedy shocked the international community and led to better safety regulations for ships.  

One of the reasons that the shipwreck led to such loss of life was that there were not enough lifeboats for the passengers and crew. Although there was some element of luck involved in surviving the sinking, some groups of people were more likely to survive than others, such as women, children, and the upper-class.  

In this project the main theme is to complete the analysis of people most likely to survive the incident. This project has been done in R Programming using packages such as dplyr, stringr, ROCR, and Metrics. 

The project contains 5 files: The main code file (Titanic.R), Training file (train.csv), Testing file (test.csv), Survivors file (gender_submission.csv) and the Solutions file (solution.csv). 

----------------------------------------------------------------------------------------------------------------------------------------

titanicCLean.R - This R code contains the cleaning part of the data. I have combined the train.csv and test.csv to impute the missing values and outliers.

----------------------------------------------------------------------------------------------------------------------------------------

titanicLogit.R - Implimenting the logistic regression on the cleaned data from titanicClean.R

----------------------------------------------------------------------------------------------------------------------------------------

titanicDT.R - Implimenting the Decision Tree on the cleaned data from titanicClean.R

----------------------------------------------------------------------------------------------------------------------------------------

titanicRandomForest.R - Implimenting the Random Forest on the cleaned data from titanicClean.R

----------------------------------------------------------------------------------------------------------------------------------------

titanicMARSpline.R - Implimenting the MARSpline (Multivariate Adaptive Regression Spline) on the cleaned data from titanicClean.R. I have created the model based on 3 pruning techniques - Forward, Backward and Cross-Validation. 

----------------------------------------------------------------------------------------------------------------------------------------
train.csv : The training set should be used to build a machine learning model. This file also has a column "Survived" which gives us the data to know which passengers survived. For the training set, we provide the outcome (also known as the “ground truth”) for each passenger. 

Some of the data columns are:

pclass: A proxy for socio-economic status (SES) 1st = Upper; 2nd = Middle; 3rd = Lower

age: Age is fractional if less than 1. If the age is estimated, is it in the form of xx.5

sibsp: The dataset defines family relations in this way...: (Sibling = brother, sister, stepbrother, stepsister); (Spouse = husband, wife (mistresses and fiancés were ignored))

parch: The dataset defines family relations in this way...: (Parent = mother, father); (Child = daughter, son, stepdaughter, stepson); (Some children travelled only with a nanny, therefore parch=0 for them.)

embarked: Port of Embarkment

----------------------------------------------------------------------------------------------------------------------------------------

test.csv : The test set should be used to see how well the model performs on unseen data. For the test set, there is no ground truth for each passenger.

----------------------------------------------------------------------------------------------------------------------------------------

gender_submission.csv : This file contains the solution for the test.csv data. The solution to whether the people in test.csv survived or not can be checked in gender_submission.csv file.

----------------------------------------------------------------------------------------------------------------------------------------

solution.csv : After completing the model and predicting the test.csv dataset, the solution to that prediction is saved in this file.

----------------------------------------------------------------------------------------------------------------------------------------

Well that's it about introduction.

This dataset is actually a competition in https://www.kaggle.com, a worldwide online Data Science competition hub. 

If you're new to Data Science then Titanic dataset is where you should begin.

Currently my rank in the competition is 3669. I hope to improve this rank as I practise more in R.

Cheers and Happy Coding.

*EDIT* (09/06/2018)
I applied MARSpline - Forward Pruning to get an accuracy of 79.9% and updated my rank to 1773 as of now. 
