library("dplyr", lib.loc="/Library/Frameworks/R.framework/Versions/3.1/Resources/library")
library("tidyr", lib.loc="/Library/Frameworks/R.framework/Versions/3.1/Resources/library")

# Path to data sets
path <- "~/Dropbox/on-line/coursera/03_GettingData/03_project/UCI HAR Dataset/"

# Read in data, subjects, labels, and activities for train and test data
activity_labels <- read.table(paste(path,"activity_labels.txt",sep = ''), quote="\"")

# View(activity_labels)
features <- read.table(paste(path, "features.txt", sep = ''), quote="\"")

# View(features)
x_test <- read.table(paste(path, "test/X_test.txt", sep = ''), quote="\"")
x_train <- read.table(paste(path, "train/X_train.txt", sep = ''), quote="\"")

# View(X_test)
y_test <- read.table(paste(path, "test/y_test.txt", sep = ''), quote="\"")
y_train <- read.table(paste(path, "train/y_train.txt", sep = ''), quote="\"")


# View(y_test)
subjects_test <- read.table(paste(path,'test/subject_test.txt', sep = ''), quote="\"")
subjects_train <- read.table(paste(path,'train/subject_train.txt', sep = ''), quote="\"")


# Name columns of the data frames

# test data
colnames(x_test) <- features[,2]
colnames(y_test) <- c('activity')
colnames(activity_labels) <- c('activity', 'activity.description')
colnames(subjects_test) <- c('subject')

# train data
colnames(x_train) <- features[,2]
colnames(y_train) <- c('activity')
colnames(activity_labels) <- c('activity', 'activity.description')
colnames(subjects_train) <- c('subject')


# Thin the data frame for only data concerning means and standard deviations
x_test_thin <- x_test[grepl('std\\(\\)', names(x_test)) | grepl('mean\\(\\)', names(x_test))]
x_train_thin <- x_train[grepl('std\\(\\)', names(x_train)) | grepl('mean\\(\\)', names(x_train))]

# Renemae vaiables to remove ()
# fname <- gsub('-', '_', names(x_test_thin))
# fname <- gsub('\\(\\)', '',fname)
# colnames(x_test_thin) <- fname

# Combine activities with observations
z_test <- cbind(y_test, x_test_thin)
z_train <- cbind(y_train, x_train_thin)


# Combine subjects with activities and observations
z_test_subjects <- cbind(subjects_test, z_test)
z_train_subjects <- cbind(subjects_train, z_train)

# combine test and train data
z_combined <- rbind(z_test_subjects, z_train_subjects)

# Add activity descriptions
z_combined_activities <- merge(activity_labels, z_combined)

# remvome numberic activities
z_combined_complete <- select(z_combined_activities,2:68)


# group by subject and activity
z_group_by = group_by(z_combined_complete, subject, activity.description)

final <- summarise_each(z_group_by, funs(mean))

# last renaming of columns to reflect the reporting of averages of obervations for each feature 
newlist <- list()
lis <- names(final)[3:67]

for (i in lis) {
    newlist <- c(newlist,paste('average[',i,']', sep = ''))
}

colnames(final)[3:67] <- newlist

# Output dataframe to file
write.table(final, file = 'UCI_HAR_subject_averages.txt', row.name = FALSE)
