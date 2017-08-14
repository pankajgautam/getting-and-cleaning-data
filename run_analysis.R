# Tasks for assignment are
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set with the average of 
# each variable for each activity and each subject.


setwd("C:/Git/Workspace/GettingandCleaningData/Assignment1")
#getwd()
#install.packages("reshape2")
library(tidyr)
library(dplyr)
library(reshape2)


# Cname of the file to store Human Activity Recognition Using Smartphones data 
filename <- "ActRecUsingSmartphones_dataset.zip"

## Download data to ActivityRecognitionUsingSmartphones_dataset.zip file
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  filePath <- file.path(getwd(), filename)
  download.file(fileURL, filePath)
} 

# check if file was
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

# Load activity labels + features
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# this esction is created to 
# Extract only the data on mean and standard deviation
featuresWanted <- grep(".*mean.*|.*std.*", features[,2])
featuresWanted.names <- features[featuresWanted,2]
featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)


# get training dataset
train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresWanted]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

#get test data set
test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresWanted]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# merge datasets and add labels
allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", featuresWanted.names)


# turn activities & subjects into factors
allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$subject <- as.factor(allData$subject)


# sort data to check 
sortedData <- allData %>% arrange(subject,activity)

# This section takes multiple columns and collapses into key-value pair
gatheredData <-
  sortedData %>% gather(key = subject,
                        value = activity)
# renaming column headers
colnames(gatheredData) <- c("subject", "activity", "variable","mean")

# clculating mean from data to create a clean dataset
allData.mean <- dcast(gatheredData, subject + activity ~ variable, mean)

# This section creates a , seperated text file with name tidy.txt
write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE,sep = ",")