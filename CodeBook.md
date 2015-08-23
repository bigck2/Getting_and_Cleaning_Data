# CodeBook

This is a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data.

## The data source

* Original data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
* Original description of the dataset: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Data Set Information

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

## The data

The dataset includes the following files:

- 'README.txt' - This provides an overview of all the seperate text files.

- 'features_info.txt': Provides an overview about the variables that measured.

- 'features.txt': This is a look up table that identifies the variables with an identification integer. There are 561 rows in this file which will be used on x_test and x_train to identify the columns. There are 561 columns in both the x_test and x_train data sets which correspons to these features.

- 'activity_labels.txt': This is a look up table to identifies what activity the subject is performing as the measurements are taken. This is linked to x_test and x_train via the y_test and y_train files. The y_test and y_train data sets have the same number of rows as the x_test and x_train data sets. There are integers in these files which correspond to the acitvity_labels.txt file.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each activity being measured. Its range is from 1 to 30.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

- 'test/subject_test.txt': Each row identifies the subject who performed the activity for each activity being measured. Its range is from 1 to 30.

## Transformation details

###I'll attempt to describe my steps in the Run_analysis.R script, which also has more detailed comments about steps.

There are 5 key parts:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## How ```run_analysis.R``` implements the above steps:

* Require ```dplyr``` the package.
* Load the features and activity labels.
* Get the test data set. Then make this tidy by giving column names from the features.txt file. I also add a column for      subject from the  subject_test.txt file and a column of activities from the y_test file.
* Get the train data set. I then make this a tidy data set peforming the same steps I used on the test data.
* Next I combine these together using rbind.
* Extract the columns that have mean() or std() in the column name. 
* Using write.table I make a copy of this data set to the working directroy called "tidy_data.txt"
* Using the dplyr package I group this data set by activities and subject.
* Then I use the summarise_each function to calculate the means.
* Using write.table I make a copy of this final data set to the working directroy called "tidy_data_summarized.txt"
