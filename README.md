###Project for Coursera: Getting and Cleaning Data (011)

The R script run_analysis.R works on datasets retrieved from observations from the Samsung Galaxy S smartphone. 

The script reads in the activities, subjects and reporting features values from two groupings called test and train. Once combined, the data is thinned to include only the variables for mean and standard deviations of the observed measurements. The data is then matched with the associated activity and subjects. After having the relevant fields combined into one data frame, the observations are then averaged  to create a table grouped by subject and activity. The naming of the variables follows that as described by the names found in the features.txt file of the original data and modified to show that the reporting values in the volumes is an average of all the reporting data. 

The script ends with the output of a final table and is written to a file UCI_HAR_subject_averages.txt. 

