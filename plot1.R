## plot1.R - David Colomer - June 2015
##
## R script to reproduce exploratory graph plot1 from assignement.
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

##
## Plotting data
##
png("./plot1.png",bg="transparent",width=480,height=480,units="px")
hist(data$Global_active_power,col="red",main="Global Active Power",xlab="Global Active Power (kilowatts)")
dev.off()


##
## Script's end.
##