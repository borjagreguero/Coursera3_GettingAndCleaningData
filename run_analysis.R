library(dplyr)
library(tidyr)
setwd("~/CURSOS/Data_Science_Programming/3-Getting_cleaning_data/project")
# You should create one R script called run_analysis.R that does the following. 

# 1 Merges the training and the test sets to create one data set.
data_folder ="./UCI HAR Dataset"
Xtraining  <- read.table(paste(data_folder,"/train/X_train.txt",sep=""))
Xtest      <- read.table(paste(data_folder,"/test/X_test.txt",sep=""))
dim(Xtraining)
dim(Xtest)

Ytraining  <- read.table(paste(data_folder,"/train/Y_train.txt",sep=""))
Ytest      <- read.table(paste(data_folder,"/test/Y_test.txt",sep=""))
dim(Ytraining)
dim(Ytest)
table(Ytest)

subj_training  <- read.table(paste(data_folder,"/train/subject_train.txt",sep=""))
subj_test      <- read.table(paste(data_folder,"/test/subject_test.txt",sep=""))
str(subj_training)
table(subj_test)

# merged.Xdata  <- merge(Xtraining,Xtest)
merged.Xdata  <- rbind(Xtraining,Xtest)
merged.Ydata  <- rbind(Ytraining,Ytest)
merged.Sdata  <- rbind(subj_training,subj_test)
dim(merged.Xdata)
dim(merged.Ydata)
dim(merged.Sdata)

rm(Xtraining,Xtest,Ytraining,Ytest,subj_training,subj_test)

# merge two data frames by ID and Country
#### total <- merge(data frameA,data frameB,by=c("ID","Country"))
#### merged.data <- merge(dataset1, dataset2, by="countryID")
#### merged.data <- merge(dataset1, dataset2, by.x="countryID", by.y="stateID")

# 2 Extracts only the measurements on the mean and standard deviation for each measurement. 
features <- read.table(paste(data_folder,"/features.txt",sep=""))
features = tbl_df(features)
names(features)=c("Id","name")
features 
cols <- grep("-mean\\(\\)|-std\\(\\)", features$name) # find correct columns 
features[cols,2]

merged.Xdata  <- merged.Xdata[,cols]; str(merged.Xdata) # select columns
names(merged.Xdata) <- features$name[cols] # give names 
names(merged.Xdata)  <- gsub("\\(\\)","",names(merged.Xdata))
names(merged.Xdata)  <- gsub("-"," | ",names(merged.Xdata))
names(merged.Xdata)

# names(data_selected.Xdata)  <- gsub("\\(|\\)", "", names(data_selected.Xdata) )
# names(data_selected.Xdata) <- tolower(names(data_selected.Xdata))

# 3 Uses descriptive activity names to name the activities in the data set
activities <- read.table(paste(data_folder,"/activity_labels.txt",sep=""))
activities[,2] <- as.character(activities[,2])

merged.Ydata.activity  <- activities[merged.Ydata[,1],2]
merged.Ydata <- cbind(merged.Ydata,merged.Ydata.activity)
names(merged.Ydata) <- c("code_activity","activity_description")
str(merged.Ydata)    

#selected <- filter(merged.Ydata,merged.Ydata==activities[1,1])
str(merged.Xdata)
str(merged.Sdata)
str(merged.Ydata)

# 4 Appropriately labels the data set with descriptive variable names. 
names(merged.Sdata) <- "subject" 

merged.all  <- cbind(merged.Ydata, merged.Sdata,merged.Xdata)
str(merged.all)

write.table(merged.all, "tidy_data.txt")

# 5 From the data set in step 4, creates a second, 
# independent tidy data set with the average of each variable for
# each activity and each subject.

# option 1
library(plyr)
### tidy_data <- ddply(merged.all,.(code_activity,subject),mean) # does not work on columns! 
result <- ddply(merged.all,.(code_activity,subject),numcolwise(mean))
str(result)
length(unique(result$subject))
length(unique(result$code_activity))
dim(result)

# option 2 - use group by + pipe 
result2 <- ddply(merged.all,.(code_activity,subject),function(x) {colMeans(x[,4:dim(x)[2]])})
str(result2)

write.table(result, "averages_data.txt")
