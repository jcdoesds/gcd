## CodeBook.md

### The Tidy Data
The Tidy Data for this work are in `tidy_data.txt`.

It contains 180 observations of 81 variables. 

 - The 180 observations are: means of features data collected for a smart device study of 30 subjects in 5 activities (30 * 5 = 180). 
 - The 81 variables are: two grouping variables (subject and activity) and 79 features. The features are means and standard deviations for each measurement. The measurements are: 

    -- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration (indicated by "Acc" and one direction, like X, Y, or Z)
    -- Triaxial Angular velocity from the gyroscope (indicated by "Gyro" and one direction, like X, Y, or Z)
    -- Time and frequency domain variables  (Time variables start with t and Frequency variables start with f)
    
### Manipulations from the raw data
The tidy data are limited to only the mean values (over all observations) for only those features that were Mean or Std. 

The data, which were split into training and test data were read in and combined. Only those features that included Mean or Std were kept. At this point, there are 10299 observations because each subject has multiple observations for each activity. 

The mean of observations for each activity is retained.