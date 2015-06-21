# Check for data.table
if (!require("data.table")) {
  install.packages("data.table")
}
#Check for reshape2
if (!require("reshape2")) {
  install.packages("reshape2")
}

require("data.table")
require("reshape2")

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]                  # Create activity_labels by subsetting and extracting column
features <- read.table("./UCI HAR Dataset/features.txt")[,2]                                # Create features by subsetting and extracting column
extract_features <- grepl("mean|std", features)                                             # Use grepl on features to search for mean and std
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")                                   # read X_test
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")                                   # read y_test
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")                       # read subject_test
names(X_test) = features                                                                    # name variables in X_test using features
X_test = X_test[,extract_features]                                                          # subset and set X_test using extract_features
y_test[,2] = activity_labels[y_test[,1]]                                                    # set a new variable in y_test by using activity_labels
names(y_test) = c("Activity_ID", "Activity_Label")                                          # set variable names in y_test 
names(subject_test) = "subject"                                                             # set variable name for subject_test
test_data <- cbind(as.data.table(subject_test), y_test, X_test)                             # make a test_data matrix
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")                                # read X_train
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")                                # read y_train
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")                    # subject_train  
names(X_train) = features                                                                   # name variables in X_train using features
X_train = X_train[,extract_features]                                                        # subset and set X_train using extract_features
y_train[,2] = activity_labels[y_train[,1]]                                                  # set a new variable in y_train by using activity_labels
names(y_train) = c("Activity_ID", "Activity_Label")                                         # set variable names for y_train
names(subject_train) = "subject"                                                            # set variable name in subject_train
train_data <- cbind(as.data.table(subject_train), y_train, X_train)                         # make a train_data matrix
data = rbind(test_data, train_data)                                                         # Combine Testing and Training Data
id_labels   = c("subject", "Activity_ID", "Activity_Label")                                 # Initialize id_labels
data_labels = setdiff(colnames(data), id_labels)                                            # find colnames(data) not present in id_labels using setdiff
melt_data = melt(data, id = id_labels, measure.vars = data_labels)                          # using melt function from reshape2 to create a molten dataframe  
tidy_data_set = dcast(melt_data, subject + Activity_Label ~ variable, mean)                 # use dcast function to cast a new dataframe tidy_data_set
write.table(tidy_data_set, file = "./tidy_data_set.txt",row.name = FALSE)                   # create a new file called tidy_data_set.txt in working directory
