library(reshape2)

# Download file
if(!file.exists("UCI HAR Dataset") {
        fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileUrl, "Dataset.zip")
}

# Unzip dataset
unzip("Dataset.zip")

# Read data
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subj_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subj_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

features <- read.table("UCI HAR Dataset/features.txt")
activity <- read.table("UCI HAR Dataset/activity_labels.txt")

# Assign column names
colnames(x_train) <- features[,2]
colnames(y_train) <- "activity"
colnames(subj_train) <- "subject"

colnames(x_test) <- features[,2]
colnames(y_test) <- "activity"
colnames(subj_test) <- "subject"

colnames(activity) <- c("activity", "activityDescription")

# Merge data into one set
train_merge <- cbind(y_train, subj_train, x_train)
test_merge <- cbind(y_test, subj_test, x_test)
all_merge <- rbind(train_merge, test_merge)

# Extract only mean and standard deviation
mean_std <- all_merge[ , grepl("activity|subject|*mean*|*std*", colnames(all_merge))]

# Use descriptive activity names
desc_names <- merge(activity, mean_std, by = "activity", all = TRUE)

# Create second independent tidy data set with average of each variable for each activity and subject
melted_data <- melt(desc_names, id=c("subject", "activityDescription"))
tidy_data <- dcast(melted_data, subject + activityDescription ~ variable, mean)

# Write tidy data set to text file
write.table(tidy_data, "tidy_data.txt", row.names = FALSE)
