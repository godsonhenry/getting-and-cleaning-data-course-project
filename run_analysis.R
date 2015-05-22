## The goal is to prepare tidy data that can be used for later analysis. 
## In this project, following documents should be submitted: 
## 1) a tidy data set as described below, 
# 2) a link to a Github repository with script for performing the analysis, 
# 3) a code book that describes the variables, the data, and any transformations or work called CodeBook.md. 
# 4) README.md in the repo with scripts is required explaining how all of the scripts work and how they are connected.  

## please check the follows:

## anounce the required packages
if ("reshape2" %in% rownames(installed.packages()) == FALSE) {
   print ("the 'reshape2' package is required")
}else{
## check the required data exists or not
if (!file.exists("getdata_projectfiles_UCI HAR Dataset")) {
   print (" The directory which includes required data, named 'getdata_projectfiles_UCI HAR Dataset', is required!")
   }else{

## read all test and trainning data into R
   trainSet=read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
   testSet=read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
## change the names of variables to feature names
   ColumnNames=read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt")
   ColumnNames=ColumnNames[,2]
   ColumnNames=as.character(ColumnNames)
   names(trainSet)=ColumnNames
   names(testSet)=ColumnNames
## read the files of labels and subjects into R and correct the names
   testLable=read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
   trainLable=read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
   testSubject=read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
   trainSubject=read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/Subject_train.txt")
   names(trainLable)="Label"
   names(testLable)="Label"
   names(trainSubject)="Subject"
   names(testSubject)="Subject"
## create the integral data of test and trainning
   trainData=cbind(trainLable,trainSubject,trainSet)
   testData=cbind(testLable,testSubject,testSet)
## merge trainData and test Data into one data set
   mergeData=rbind(trainData,testData)
## replace the code of label in mergeData with names shown in the activity_labels.txt
   lables=read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")
   names(lables)=c("Label","Names")
   DataonLable=merge(lables,mergeData,by="Label",all=TRUE)
   DataonLable=DataonLable[,2:564]
   names(DataonLable)[[1]]="Label"
## subset DaraonLable into data only containing mean and standard deviation information.
   DataSelect=subset(DataonLable, select=c("Label","Subject",colnames(DataonLable)[grep("mean()",colnames(DataonLable),fixed=TRUE)],colnames(DataonLable)[grep("std()",colnames(DataonLable),fixed=TRUE)]))
## create the final tidy data
   library(reshape2)
   DataReshape=melt(DataSelect, id=c("Label","Subject"))
   DataTidy=dcast(DataReshape,Label+Subject~variable,mean)
## write DataTidy into Project.txt on disk
   write.table(DataTidy, file="Project.txt", row.name=FALSE)
   }
}

