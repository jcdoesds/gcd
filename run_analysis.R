## run_analysis.R

# download and unzip the data
myurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
td = tempdir() # create  temporary directory
tf = tempfile(tmpdir=td, fileext=".zip") # create the placeholder file
download.file(myurl, tf) # download into the placeholder file
fname = unzip(tf, list=TRUE) #get the file names and information
# unzip the files to the temporary directory
unzip(tf, files=fname$Name, exdir=td, overwrite=TRUE)

# get activity labels and features
activity_labels <- read.table(file.path(td,fname$Name[grep("activity_labels.txt", fname$Name)]),sep="",header=FALSE, stringsAsFactors = FALSE, col.names=c("i","activity"))
features <- read.table(file.path(td,fname$Name[grep("features.txt", fname$Name)]),sep="",header=FALSE, stringsAsFactors = FALSE, col.names=c("i","feature"))

# there are a lot of features, but we are only interested in mean and std
features_rows_to_keep <- grep(".*mean.*|.*std.*", features$feature)
features <- features[features_rows_to_keep,2]  # drop other features; keep only desc
features <- gsub('-mean', 'Mean', features)
features <- gsub('-std', 'Std', features)
features <- gsub('[-()]', '', features)

# get train and test data
train <- read.table(file.path(td,fname$Name[grep("train/X_train.txt", fname$Name)]),sep="",header=FALSE, stringsAsFactors = FALSE)[wanted_features_rows]
train_activity <- read.table(file.path(td,fname$Name[grep("train/y_train.txt", fname$Name)]),sep="",header=FALSE, stringsAsFactors = FALSE)
train_subject <- read.table(file.path(td,fname$Name[grep("train/subject_train.txt", fname$Name)]),sep="",header=FALSE, stringsAsFactors = FALSE)
train <- cbind(train_subject, train_activity, train)

test <- read.table(file.path(td,fname$Name[grep("test/X_test.txt", fname$Name)]),sep="",header=FALSE, stringsAsFactors = FALSE)[wanted_features_rows]
test_activity <- read.table(file.path(td,fname$Name[grep("test/y_test.txt", fname$Name)]),sep="",header=FALSE, stringsAsFactors = FALSE)
test_subject <- read.table(file.path(td,fname$Name[grep("test/subject_test.txt", fname$Name)]),sep="",header=FALSE, stringsAsFactors = FALSE)
test <- cbind(test_subject, test_activity, test)

# the combined dataset
df <- rbind(train, test)
colnames(df) <- c("subject", "i", features) # add some names
df <- df %>%
  left_join(activity_labels) %>% # add activity labels instead of number
  select(-i)

# the last tidy dataset should only be the means for each subject, activity, and feature
mean_df <- df %>%
  group_by(subject, activity) %>%
  summarise(across(where(is.numeric),mean))

# save tidy data
write.table(mean_df, "tidy_data.txt", row.names = FALSE, quote = FALSE)

# clean up 
rm(fname, activity_labels, features, train, train_activity, train_subject, test, test_activity, test_subject)
