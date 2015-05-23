### Getting and Cleaning Data Course Project

For the course project, an R script named run_analysis.R was written to

1. Merges the training and the test sets to create one data set;
2. Extracts only the measurements on the mean and standard deviation for each measurment;
3. Uses descriptive activity names to name the activities in the data set;
4. Appropriately labels the data set with descriptive variable names;
5. From the data set in step 4, creates a second, independent tidy data set with the
average of each the average of each variable for each activity and each subject

First, the features.txt with the code and description of the measurements and activity_
labels.txt with the code and descript of activities were read in. The labels, subject,
and measurement data of training and testing data set were read and stored in different
variables. They were subsequently combined using cbind and rbind functions to create
a single data set. The column names were set with Subject, ActivityCode, and
the description of the features.

Then, the features whose name contain "mean" for mean of each measurment and "std" for
standard deviation of each measurement were selected using the *filter* and
*select* functions of dplyr package. A subset of the whole data was generated
using *subset* function.

To replace the code of activities in the data frame with the descriptions, a function
named *recode* was first defined to replace an old value with a new value in a data frame
and then applied to the data subset so that the names of the activities are used instead
of the codes. *mutate* and *select* functions of dplyr page were used during the process.

The *melt* and *dcast* functions of reshape2 package were used to calcualte the average
of each variable for each activity and each subject. The results were stored in
a variable of tidySet and later written to an output file of tidy_data.csv.

The resulted tidy data set contains the average values of 79 measurements for 30 subjects
and 6 activities.