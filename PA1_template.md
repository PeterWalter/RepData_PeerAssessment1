---
title: 'Reproducible Research: Peer Assignment 1'
author: "Peter Chifamba"
date: "Sunday, November 16, 2014"
output:
html_document:
keep_md: yes

---
opts_chunk$set(fig.path = "./figures/") # set path for figures
## Introduction
It is now possible to collect a large amount of data about personal
movement using activity monitoring devices such as a
[Fitbit](http://www.fitbit.com), [Nike
Fuelband](http://www.nike.com/us/en_us/c/nikeplus-fuelband), or
[Jawbone Up](https://jawbone.com/up). These type of devices are part of
the "quantified self" movement -- a group of enthusiasts who take
measurements about themselves regularly to improve their health, to
find patterns in their behavior, or because they are tech geeks. But
these data remain under-utilized both because the raw data are hard to
obtain and there is a lack of statistical methods and software for
processing and interpreting the data.

This assignment makes use of data from a personal activity monitoring
device. This device collects data at 5 minute intervals through out the
day. The data consists of two months of data from an anonymous
individual collected during the months of October and November, 2012
and include the number of steps taken in 5 minute intervals each day.

##Data

The data for this assignment can be downloaded from the course web
site:

* Dataset: [Activity monitoring data](https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip) [52K]

The variables included in this dataset are:

* **steps**: Number of steps taking in a 5-minute interval (missing
values are coded as `NA`)

* **date**: The date on which the measurement was taken in YYYY-MM-DD
format

* **interval**: Identifier for the 5-minute interval in which
measurement was taken




The dataset is stored in a comma-separated-value (CSV) file and there
are a total of 17,568 observations in this
dataset.  

### Loading and processing the data
Firts of all is to load all the required libraries for processing

```r
library(dplyr)
library(ggplot2)
library(lattice)
```
#### Load the Data
The data was loaded from the provided file **activity.csv** which was in the [Github fork](http://github.com/rdpeng/RepData_PeerAssessment1).

```r
Data <- read.csv("activity.csv",  na.strings ="NA", stringsAsFactor = FALSE)
```

The state of the data was checked by performing a `summary` of the data, checking the `header`, `tail` and `structure` of the data.


```r
summary(Data)
```

```
##      steps            date              interval     
##  Min.   :  0.00   Length:17568       Min.   :   0.0  
##  1st Qu.:  0.00   Class :character   1st Qu.: 588.8  
##  Median :  0.00   Mode  :character   Median :1177.5  
##  Mean   : 37.38                      Mean   :1177.5  
##  3rd Qu.: 12.00                      3rd Qu.:1766.2  
##  Max.   :806.00                      Max.   :2355.0  
##  NA's   :2304
```

```r
head(Data)
```

```
##   steps       date interval
## 1    NA 2012-10-01        0
## 2    NA 2012-10-01        5
## 3    NA 2012-10-01       10
## 4    NA 2012-10-01       15
## 5    NA 2012-10-01       20
## 6    NA 2012-10-01       25
```

```r
tail(Data)
```

```
##       steps       date interval
## 17563    NA 2012-11-30     2330
## 17564    NA 2012-11-30     2335
## 17565    NA 2012-11-30     2340
## 17566    NA 2012-11-30     2345
## 17567    NA 2012-11-30     2350
## 17568    NA 2012-11-30     2355
```

```r
str(Data)
```

```
## 'data.frame':	17568 obs. of  3 variables:
##  $ steps   : int  NA NA NA NA NA NA NA NA NA NA ...
##  $ date    : chr  "2012-10-01" "2012-10-01" "2012-10-01" "2012-10-01" ...
##  $ interval: int  0 5 10 15 20 25 30 35 40 45 ...
```
#### Process the data into a suitable format for analysis 
Change the date values to date and then the data frame to data table using dplyr for processing


```r
DT <- tbl_df(Data)
DT$date <- as.Date(DT$date)
```
#### Steps taken per Day
Group the data by date and then create a new column called sum which will be the sum of steps taken per day

```r
# group the data by date
by_date <- group_by(DT, date)
stepsum <- summarize(by_date, sum = sum(steps, na.rm = TRUE))
```
Generate histogram

```r
hist(stepsum$sum, breaks = 5, main ="Total Steps Taken per Day", xlab =" Steps taken", col = "green")
```

![plot of chunk Total_steps_histo](./figure/Total_steps_histo-1.png) 
Calculate the mean and median

```r
meansteps <- mean(stepsum$sum)
mediansteps <- median(stepsum$sum)
```

The mean total steps taken per day is **9354.2295082** and the median is **10395**.  

#### Average daily activity pattern
plot of the  5-minute interval and average number of steps taken


```r
ave_steps <- DT %>%
        group_by(interval) %>%
        select(steps)%>%
        summarize(average = mean(steps, na.rm= TRUE)) 

plot(ave_steps$interval, ave_steps$average,  type ="l", xlab = " 5-minute Steps Intervals", ylab ="Average steps", main = "Average Daily Activity", col ="blue")
```

![plot of chunk A_5-minute_interval](./figure/A_5-minute_interval-1.png) 

```r
max <- filter(ave_steps, average == max(average))
HighestAve <- max[,1]
```
It can be said that the highest 5-minute interval is **835**.  

#### Imputing missing values

```r
MissingTotal <- sum(is.na(DT$steps))
```
The total number of missng values is **2304**.  
  
    
For the calculation for filling missing values will be done using the average of all total values in the dataset. this is because some days do not have values at all.  
  

```r
# creating a new column with taotal step average
DTA <-mutate(DT, meanI = mean(steps, na.rm = TRUE), fnlsteps = ifelse(is.na(steps),meanI, steps))
```

```r
# creating new Data Table with no missing values.
newDT <- select(DTA, steps = fnlsteps, date, interval)
```
Histogram of total steps taken each data.

```r
date_group <- group_by(newDT, date)
stepsum1 <- summarize(date_group, sum = sum(steps))
hist(stepsum1$sum, breaks = 5, main ="Total Steps Taken per Day", xlab =" Steps taken", col = "blue")
```

![plot of chunk New_Histo](./figure/New_Histo-1.png) 

```r
means <- mean(stepsum1$sum)
medians <- median(stepsum1$sum)
```
The new mean total steps taken per day is **1.0766189 &times; 10<sup>4</sup>** and the median is **1.0766189 &times; 10<sup>4</sup>**.    
These values totally differ from the ones which had missing values. The impact of imputing missing values is that we end up with different results from the original data, whilst we do not have a reason of why the data was missing in the first place. So imputing values total affect the outcome of the research.  

#### Activity patterns between weekdays and weekends

```r
days <- mutate(newDT, dayname = weekdays(date))
DTT <- mutate(days, day = as.factor(ifelse(dayname == "Saturday"| dayname == "Sunday", "Weekend", "Weekday")))
Weekends <- DTT %>%
        filter(day == "Weekend")
      
Weekdays <- DTT %>%
        filter(day == "Weekend")

activity_wend <- aggregate(steps ~ interval, Weekends, mean)
activity_wdy <- aggregate(steps ~ interval, Weekdays, mean)
```
The plot of the weekday and weekend is shown below

```r
par(mfrow = c(2,1))

plot(activity_wend$interval, activity_wend$steps, type ="l", main ="Weekend mean Steps", xlab = "5-minute intervals", ylab ="Number of Steps")
plot(activity_wdy$interval, activity_wdy$steps, type ="l", main ="Weekdays mean Steps", ylab = "Number of Steps", xlab = " 5- Minute Intervals")
```

![plot of chunk planel_plot](./figure/planel_plot-1.png) 


