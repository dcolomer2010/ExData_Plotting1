## plot4.R - David Colomer - June 2015
##
## R script to reproduce exploratory graph plot3 from assignement.
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

min_serie <- min(data$Sub_metering_1)
if (min_serie > min(data$Sub_metering_2)) {min_serie <- min(data$Sub_metering_2)}
if (min_serie > min(data$Sub_metering_3)) {min_serie <- min(data$Sub_metering_3)}

max_serie <- max(data$Sub_metering_1)
if (max_serie < max(data$Sub_metering_2)) {max_serie <- max(data$Sub_metering_2)}
if (max_serie < max(data$Sub_metering_3)) {max_serie <- max(data$Sub_metering_3)}

locale <- Sys.getlocale("LC_TIME")
Sys.setlocale("LC_TIME","en_US.UTF-8") #Setting locale in English for a non-English locale in Linux
                                       #For other configurations locale should be changed.

png("./plot4.png",bg="transparent",width=480,height=480,units="px")
par(mfrow=c(2,2)) # 2 by 2 graph grid

#Graph 1


plot(data$DateTime,data$Global_active_power,type="l",ylab="Global Active Power (kilowatts)",xlab="")

#Graph 2
plot(data$DateTime,data$Voltage,type="l",xlab="datetime",ylab="Voltage")

#Graph 3
plot(data$DateTime,data$Sub_metering_1,type="l",ylab="Energy sub metering",xlab="",ylim=c(min_serie,max_serie))
par(new=T)
plot(data$DateTime,data$Sub_metering_2,type="l",ylab="",xlab="",col="red",ylim=c(min_serie,max_serie))
par(new=T)
plot(data$DateTime,data$Sub_metering_3,type="l",ylab="",xlab="",col="blue",ylim=c(min_serie,max_serie))
legend("toprigh",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),col=c("black","red","blue"),lwd=1)
par(new=F)

#Graph 4

plot(data$DateTime,data$Global_reactive_power,type="l",xlab="datetime")

dev.off()

Sys.setlocale("LC_TIME",locale)