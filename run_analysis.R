# Install packages
install.packages("data.table")
install.packages("reshape2")

# Read: data from txt files
subject_train <- read.table("subject_train.txt")
subject_test <- read.table("subject_test.txt")
X_train <- read.table("X_train.txt")
X_test <- read.table("X_test.txt")
y_train <- read.table("y_train.txt")
y_test <- read.table("y_test.txt")

# add column name for subject files
names(subject_train) <- "subjectID"
names(subject_test) <- "subjectID"
names(y_train) <- "activity"
names(y_test) <- "activity"

# merge files 
train <- cbind(subject_train, y_train, X_train)
test <- cbind(subject_test, y_test, X_test)
mergeded <- rbind(train, test)


# Extract only the measurements on the mean and standard deviation for each measurement.
extract_meanstd <- grepl("std\\(\\)", names(merged))

# convert the activity column from integer to factor
merged$activity <- factor(merged$activity, labels=c("Walking",
                                                    "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))

## Create a second, tidy data set with the average of each variable for each activity and each ## subject
melted <- melt(merged, id=c("subjectID","activity"))
tidy <- dcast(melted, subjectID+activity ~ variable, mean)

# write the tidy data set to a file
write.csv(tidy, "tidy.csv", row.names=FALSE)
