# Before launching the code, set the working directory and make sure all files are in the working directory

# Reading the data in R

subject_train <- read.table("./train/subject_train.txt")
subject_test <- read.table("./test/subject_test.txt")

# Setting an identifier to both datasets
names(subject_train) <- "ID"
names(subject_test) <- "ID"

# Reading the other datasets
X_train <- read.table("./train/X_train.txt")
X_test <- read.table("./test/X_test.txt")
y_train <- read.table("./train/y_train.txt")
y_test <- read.table("./test/y_test.txt")


# Measurement names
featureNames <- read.table("features.txt")
names(X_train) <- featureNames[,2]
names(X_test) <- featureNames[,2]

# Activity names
names(y_train) <- "activity"
names(y_test) <- "activity"

# Add the two files into a single file
training_set <- cbind(subject_train, y_train, X_train)
test_set <- cbind(subject_test, y_test, X_test)
full_data <- rbind(training_set, test_set)

#Take only the measurements on the mean and standard deviation for each measurement. We use here the grepl function
measurements <- grepl("mean\\(\\)", names(full_data)) | grepl("std\\(\\)", names(full_data))

# Keep the ID and activity columns
measurements[1:2] <- TRUE

# Keep only the columns that interest us
full_data <- full_data[, measurements]

# Give a name to each activity (instead of an integer)
full_data$activity <- factor(full_data$activity, labels=c("Walking","Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))

# load the package reshape2
require(reshape2)
merge <- melt(full_data, id=c("ID","activity"))
tidy_data <- dcast(merge, ID+activity ~ variable, mean)

# write the tidy data set to a file names tidy.txt with a tabulation as separator (for conveniency)
write.table(tidy_data, "tidy.txt", row.names=FALSE, sep = "\t")



