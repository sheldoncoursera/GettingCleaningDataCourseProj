## run_analysis.R
## 1. Merges the training and the test sets to create one data set;
## 2. Extracts only the measurements on the mean and standard deviation for each measurment;
## 3. Uses descriptive activity names to name the activities in the data set;
## 4. Appropriately labels the data set with descriptive variable names;
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each 
##    the average of each variable for each activity and each subject

library(dplyr)
# Read in the features (code and description)
features <- read.table("features.txt",sep=" ",header=FALSE,colClasses=c("numeric","character"))
colnames(features) <- c("FeatureCode","FeatureDescription")

# Read in the activities (code and description)
activities <- read.table("activity_labels.txt",sep=" ",header=FALSE,colClasses=c("numeric","character"))
colnames(activities) <- c("ActivityCode","ActivityDescription")

# Read in the training data set
trainLabels <- read.table("train/y_train.txt",header=FALSE)
trainData <- read.table("train/X_train.txt",header=FALSE)
trainSubject <- read.table("train/subject_train.txt",header=FALSE)
trainSet <- cbind(trainSubject,trainLabels,trainData)

# Read in the testing data set
testLabels <- read.table("test/y_test.txt",header=FALSE)
testData <- read.table("test/X_test.txt",header=FALSE)
testSubject <- read.table("test/subject_test.txt",header=FALSE)
testSet <- cbind(testSubject,testLabels,testData)

# Generate one data set with both the training and testing data
allSet <- rbind(trainSet,testSet)
colnames(allSet) <- c("Subject","ActivityCode",features$FeatureDescription)

# Select measurement columns with "mean" or "std" in their names
selectedFeatures <- features %>% 
  filter(grepl("mean",FeatureDescription) | grepl("std",FeatureDescription)) %>%
  select(FeatureDescription)
selectedSet <- subset(allSet, select=c("Subject","ActivityCode",selectedFeatures$FeatureDescription))

# A function to replace an old value with a new value in a data frame
recode <- function(data, oldvalue, newvalue) {
  # convert any factors to characters
  if (is.factor(data))     data     <- as.character(data)
  if (is.factor(oldvalue)) oldvalue <- as.character(oldvalue)
  if (is.factor(newvalue)) newvalue <- as.character(newvalue)
                        
  # create the return vector
  newvec <- data
                        
  # put recoded values into the correct position in the return vector
  for (i in unique(oldvalue)) newvec[data == i] <- newvalue[oldvalue == i]
  newvec
}
                     
# Use descriptive activity names in the data frame
readySet <- selectedSet %>% 
  mutate(ActivityName = recode(ActivityCode,
                                activities$ActivityCode,
                                activities$ActivityDescription)) %>%
  select(-ActivityCode)

# Create a tidy data set with the average of each variable for each activity and each subject
library(reshape2)
meltSet <- melt(readySet, id=c("Subject","ActivityName"), measure.vars=selectedFeatures$FeatureDescription)
tidySet <- dcast(meltSet, Subject+ActivityName ~ variable, mean)

# Output the tidy date set
write.table(tidySet, "tidy_dataset.csv", sep=",", row.name=FALSE)