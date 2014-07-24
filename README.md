# GettingCleaningData-Project
===========================

This README describes how the run_analysis.R script works.

## File List
===========================
run_analysis.R
README.md
CodeBook.txt

## How to run script
===========================
Copy the source file to your local working directory. Then source the script from R.
> source run_analysis.R

## Description of Data
===========================

The data used for the script represent data collected from the accelerometers and gyroscope from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The data for the project is located at:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Script description
===========================

The script will first check if the data folder "UCI HAR Dataset" exists in the current working directory. If not, then the data is downloaded to a temporary folder. This temporary folder will be removed upon exit of R (RStudio).

The script will run the following steps:

### 1. Merges the training and the test sets to create one data set.
####################################
The x, y, and subject data for training and test sets are read in. One data frame is created for the test data and one data frame created for the training data. The features list is also read in from features.txt. The column names of the test and training data frames are changed to subject, activity, and the measurement names from features.txt. The training and test data frames are combined together using rbind.

### 2. Extracts only the measurements on the mean and standard deviation for each measurement.
####################################
Only the columns with the name "mean(" or std(" are extracted using grep.

### 3. Uses descriptive activity names to name the activities in the data set.
####################################
The activities names are read in from the file "activity_labels.txt". They are then applied to the activity column using subsetting.

### 4. Approprately labels the data set with descriptive variable names.
####################################
The measurement names from features.txt have been modified to reflect more descriptive names. Here are the replacements made:
f -> fft
t -> Time
BodyBody -> Body (BodyBody was a typo mistake in the original features.txt)
-std() -> StdDev
-mean() -> Mean
-X -> Xaxis
-Y -> Yaxis
-Z -> Zaxis

### 5. Creates a second independent tidy independent tidy data set with the average of each variable for each activity and each subject.
####################################
The aggregate function was used to calculate the mean ordered by activity and subject. The resulting tidy data was written to a txt file "TidyData.txt".





