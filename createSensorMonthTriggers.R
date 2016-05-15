require(dplyr)
require(tidyr)

#Begin Stijn's code
db <- read.csv("data/DustData_w_MissingMonthFixed.csv")
dt <- tbl_df(db) %>%
  mutate(date = as.Date(as.character(Sample.Date), format = "%d-%m-%y"))
dt$datetime <- as.POSIXct(paste(dt$Sample.Date,dt$Sample.Time),
                          format = "%d-%m-%y %H:%M:%S")           
daily_av <- dt %>%
  group_by(date, Sample.Point) %>%
  summarise(av = mean(Clean_PM10.10min, na.rm = T),
            sd = sd(Clean_PM10.10min, na.rm = T))
#End Stijn's code

#Create a new binary column to indicate if the average for the day was above 70 or not
daily_av$isHigh<-with(daily_av, ifelse(av>70,1,0))

#Remove unnecessary columns and change the dates to indicate just month and year
daily_av_2 <- subset(daily_av, select=-c(av,sd))
daily_av_2$date <- substr(daily_av_2$date,1,7)

#Sum up the number of above 70 triggers per sensor by month
daily_av_3 <- daily_av_2 %>% group_by(date, Sample.Point) %>% summarise(numberOfTriggers=sum(isHigh, na.rm = TRUE))

#Reformat the dataframe so it's easier to interact with
daily_av_4 <- spread(daily_av_3, date, numberOfTriggers)

#Remove NAs and the airport sensor
daily_av_4[is.na(daily_av_4)] <- 0
daily_av_4 <- daily_av_4[-c(8),]
