These libarary were used for this project
```
 library(tidyr)
 library(dplyr)
 library(reshape2)
```
R code is written to create tidy data txt file. Dtaa is downloaded using code with the file name ActRecUsingSmartphones_dataset.zip.   This file is unzipped at set directory. After file is unzipped data from files.The dataset includes the following files:
 
- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second.  

Based on above description training and test data frames are created and merged with below code
 
```
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
```
Below code is create to tiidy data and create a text file tidy.txt with comma as seperator

```
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
```
