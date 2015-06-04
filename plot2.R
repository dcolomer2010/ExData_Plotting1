## plot2.R - David Colomer - June 2015
##
## R script to reproduce exploratory graph plot2 from assignement.
##

##
## Libraries
##
if (!require(grDevices)){
  install.packages("grDevices")
}

require (grDevices)

if (!require(sqldf)){        # To allow queries on datafile
  install.packages("sqldf")
}

require(sqldf)

##
## Loading data
##

### Memory usage is reduced selecting only the required data.
data <- NULL

for(x in c('1/2/2007','2/2/2007')) {
  query <- paste("select * from file where Date = '", x,"' ",sep="")
  data_day <- read.csv.sql(file="./household_power_consumption.txt",
                           sql=query,
                           header=TRUE,
                           sep=";",
  )
  data <- rbind(data, data_day)
}

data$DateTime <- as.POSIXct(strptime(paste(data$Date,data$Time), "%d/%m/%Y %H:%M:%S"))
data$Weekday <- weekdays(data$DateTime)

##
## Plotting data
##



locale <- Sys.getlocale("LC_TIME")
Sys.setlocale("LC_TIME","en_US.UTF-8") #Setting locale in English for a non-English locale in Linux
                                       #For other configurations locale should be changed.

png("./plot2.png",bg="transparent",width=480,height=480,units="px")
plot(data$DateTime,data$Global_active_power,type="l",ylab="Global Active Power (kilowatts)",xlab="")
dev.off()

Sys.setlocale("LC_TIME",locale)


##
## Script's end.
##