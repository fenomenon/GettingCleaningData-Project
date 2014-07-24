# Check if samsung data is in working directory, if not download it

if (!file.exists("UCI HAR Dataset")) {
  # Read data
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

  # create a temp directory
  td = tempdir()

  # create the placeholder file
  tf = tempfile(tmpdir=td, fileext=".zip")

  # download into placeholder file
  download.file(fileUrl, tf)

  unzip(tf, exdir=td, overwrite=TRUE)


  data_folder <- paste(td, "\\UCI HAR Dataset", sep = "")
} else {
  data_folder <- paste("UCI HAR Dataset", sep = "")
}

# Read training files
x_temp <- read.table(paste(data_folder, "\\train\\X_train.txt", sep = ""))
y_temp <- read.table(paste(data_folder, "\\train\\y_train.txt", sep = ""))
subject_temp <- read.table(paste(data_folder, "\\train\\subject_train.txt", sep = ""))

####################################
# Combine the training tables
df_train <- data.frame()
df_train <- cbind(subject_temp, y_temp, x_temp)

# change column names
features <- read.table(paste(data_folder, "\\features.txt", sep = ""), stringsAsFactors=FALSE)
colnames(df_train) <- c("subject", "activity", features[,2])

####################################
# Read test files
x_temp <- read.table(paste(data_folder, "\\test\\X_test.txt", sep = ""))
y_temp <- read.table(paste(data_folder, "\\test\\y_test.txt", sep = ""))
subject_temp <- read.table(paste(data_folder, "\\test\\subject_test.txt", sep = ""))

# Combine the test tables
df_test <- data.frame()
df_test <- cbind(subject_temp, y_temp, x_temp)

# change column names
features <- read.table(paste(data_folder, "\\features.txt", sep = ""), stringsAsFactors=FALSE)
colnames(df_test) <- c("subject", "activity", features[,2])

####################################
# combine test and training data
df <- rbind(df_train, df_test)

####################################
# Extract only the measurements on the mean and std for each measurement
colWithMeanStd <- grep("mean\\(|std\\(", names(df), perl=TRUE)
df <- df[,c(1:2, colWithMeanStd)]

####################################
# Use descriptive activity names to name the activities in the data set
activity_names <- read.table(paste(data_folder, "\\activity_labels.txt", sep = ""), stringsAsFactors=FALSE)

df$activity <- activity_names[df[,2],2]

####################################
# Appropriately label the data set with descriptive variable names
colnames(df) <- gsub("^f", "fft", names(df) )
colnames(df) <- gsub("^t", "Time", names(df) )
colnames(df) <- gsub("BodyBody", "Body", names(df) )
colnames(df) <- gsub("-std\\(\\)", "StdDev", names(df) )
colnames(df) <- gsub("-mean\\(\\)", "Mean", names(df) )
colnames(df) <- gsub("-X", "Xaxis", names(df) )
colnames(df) <- gsub("-Y", "Yaxis", names(df) )
colnames(df) <- gsub("-Z", "Zaxis", names(df) )

####################################
# Create a second, ind tidy data set with the avg of each
# variable for each activity and each subject
agg <- aggregate(df[,3:ncol(df)], 
                 list(activity=df$activity, subject=df$subject), mean)

write.table(agg, "TidyData.txt")
