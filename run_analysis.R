#load dplyr package for additional functionality - group_by 
#and summarize_each - for step 5
library(dplyr)

#set working directory to UCI HAR DataSet
setwd("./UCI HAR Dataset")

#get activity labels, need to set stringsAsFactors = FALSE
#doing this will make later steps easier
activity_labels <- read.table("activity_labels.txt", stringsAsFactors = FALSE)
#after reviewing activity_labels this is a reference 
#table to what is being done (ie 1 is for walking)

#get the features
features <- read.table("features.txt", stringsAsFactors = FALSE)
#after reviewing features I realized this is a list 
#of the 561 measurements being taken doing
#various activities by various subjections

#Let's move into the Test Folder to process the Test Data
setwd("./test")

#get the x_test data
x_test <- read.table("x_test.txt")
#this is the meat of the test data

#I'll give x_test descriptive names of what is being 
#measured in each column
colnames(x_test) <- features[,2]

#get the subject test data
#this is a vector that identifies which subject/participant is being
#measured for each row of the x_test data frame
subject_test <- read.table("subject_test.txt")

#i will add this as a column to the x_test data frame
#this will identify which subject is being measured in each row 
#of the x_test data frame
x_test$subject <- subject_test[,1]


#get the Y_test data
# it seems like this relates to the acivity_labels
#(ie. WALKING, WALKING_UPSTAIRS)
y_test <- read.table("y_test.txt")
#It looks like the y_test is a column of data that describes the 
#activity in each row
#This would need to some how be looked up with the activity_labels data

#create character vector activities_test by subestting
#activity_labels by the values in y_test
#then only take the second column
activities_test <- activity_labels[y_test[,1],][,2]


#I will add the activities_test column to the x_test data frame
#with name activities
#now each row of the the x_test data frame has an
#activity value describing what is being measured in the other columns
x_test$activities <- activities_test

#the x_test data frame is now descriptive
#It has colnames describing what is being measured in each column
#there are two descriptive columns added that tell us
#the subject being measured and the activity they are performing

#Now I need to prepare the training data in the same way

#return to UCI Data Set parent directory
setwd('..')

#move to the training data directory
setwd("./train")

#get the x_train data
x_train <- read.table("x_train.txt")
#this is the meat of the training data

#I'll give x_train descriptive names of 
#what is being measured in each column
colnames(x_train) <- features[,2]

#get the subject train data
#this is a vector that identifies which subject/participant is being
#measured for each row of the x_train data frame
subject_train <- read.table("subject_train.txt")

#i will add this as a column to the x_train data frame
#this will identify which subject is being measured in each row 
#of the x_test data frame
x_train$subject <- subject_train[,1]

#get the Y_train data
# it seems like this relates to the acivity_labels
#(ie. WALKING, WALKING_UPSTAIRS)
y_train <- read.table("y_train.txt")
#It looks like the y_train is a column of data that describes the 
#activity in each row
#This would need to some how be looked up with the activity_labels data

#create character vector activities_test by subestting
#activity_labels by the values in y_test
#then only take the second column
activities_train <- activity_labels[y_train[,1],][,2]

#I will add the activities_test column to the x_train data frame
#with name activities
#now each row of the the x_test data frame has an
#activity value describing what is being measured in the other columns
x_train$activities <- activities_train

#now we have created a lot of variables
#to keep it simple I'm going to remove some variables
rm(activity_labels, features, subject_test, subject_train, y_test, y_train,
   activities_test, activities_train)

# now we have two data frames x_test and x_train
#lets combine them togethe with rbind and remove these 
#variables we don't need anymore
all_data <- rbind(x_test, x_train)
rm(x_test, x_train)

#now I need to cut down the number of columns. There are currently
#563 columns in all_data. But I'm only interested in the ones
#that pertain to the mean or standard deviation

#lets look at all the names
n <- names(all_data)

#to analyze the column names, I want them all to be lowercase
n <- tolower(n)

#find the columns with "mean()" in the name
mean_columns <- grep("mean()", n)

#find the columns with "std()" in the name
std_columns <- grep("std()", n )

important_columns <- c(mean_columns, std_columns)
important_columns <- sort(important_columns)

#don't forget the two columns we added that describe the data
#column 562 - subject and column 563 - activities
important_columns <- c(important_columns, 562, 563)

#now lets subset all_data with only the relevant columns
all_data <- all_data[,important_columns]

#now lets save a copy of the tidy data set
# we are currently in the ./UCI HAR Dataset/train directory
#let's move back out to theoriginal working directory
setwd('..')
setwd('..')
write.table(all_data, "tidy_data.txt", row.name=FALSE)


#let's get rid of the intermediate vairables
rm(mean_columns, std_columns, n, important_columns)


#for step 5, use dplyr to group_by subject and activity
#then use summarise_each(grouped_df, funs(mean))

grouped_all_data <- group_by(all_data, subject, activities)

summarized_all_data <- summarise_each(grouped_all_data,
                              funs(mean))


#lets export a copy of summarized_all_data, which is the 
#answer to step five which gives measures 
#with the average of each variable for each activity
#and each subject

write.table(summarized_all_data, "tidy_data_summarized.txt", 
              row.name = FALSE)

rm(grouped_all_data)


