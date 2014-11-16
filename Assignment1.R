Data <- read.csv("activity.csv",  na.strings ="NA", stringsAsFactor = FALSE)
#Data <- Data1[!is.na(Data1$steps),]
head(Data)
tail(Data)
summary(Data)
str(Data)
library(dplyr)
hist(DT$steps)
DT <- tbl_df(Data)
DT$date <- as.Date(DT$date)

by_date <- DT%>%
        group_by(date)
                        %>%
        Sum_perday <- mutate(by_date,sum= sum(steps))
p <- 
hist(aggregate(by_date$steps ~ by_date$date , data= by_date, sum)[,2], xlab = "Steps taken", col = "red", main ="Total Steps taken per day")
summary <-   summarize(by_date, mean = mean(steps, na.rm = TRUE), median = median(steps, na.rm = TRUE))
Total_day <- summarize(by_date, sum = sum(steps, na.rm = TRUE))
Total_day
hist(Total_day$sum, xlab =" Steps per day", main ="Number of steps taken per Day", col = "red")
summary
x <- mutate(by_date, sum = sum(steps, na.rm = TRUE))
x
