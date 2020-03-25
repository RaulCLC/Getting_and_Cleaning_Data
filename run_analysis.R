#Download files to environment. Folder needs to be saved to working directory

x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
train_activity <- read.table("./UCI HAR Dataset/train/y_train.txt")
test_activity <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

#Rename test and train data columns to match feature. rename activity and subject col name 

names(x_train) <- features[,2]
names(x_test) <- features[,2]
subject_test <- rename(subject_test, Subject = V1)
subject_train <- rename(subject_train, Subject = V1)
test_activity <- rename(test_activity, Activity = V1)
train_activity <- rename(train_activity, Activity = V1)

#find index of "mean" and "std" columns, and select from train and test data sets.

mean_idx <- grep("mean", features$V2)
std_idx <- grep("std", features$V2)
all_idx <- rbind(mean_idx, std_idx)
x_test_select <- x_test[sort(all_idx)]
x_train_select <- x_train[sort(all_idx)]

#renaming activity labels to meaningful names
train_activity$Activity <- activity_labels[train_activity$Activity,2]
test_activity$Activity <- activity_labels[test_activity$Activity,2]

#Merging data into 1 dataset
x_train_select <- cbind(subject_train, train_activity, x_train_select)
x_test_select <- cbind(subject_test, test_activity, x_test_select)
complete_dataset <- rbind(x_test_select, x_train_select)

#creating averages dataset
grouped_data <- group_by(complete_dataset, Subject, Activity)
averages <- summarize_all(grouped_data, funs(mean))

