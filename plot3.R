library(dplyr)
library(lubridate)

#Downloadding file
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if (!file.exists("./data/household_power_consumption.txt")) {
    download.file(fileUrl, "./data/household_power_consumption.zip", 
                  method = "curl")
    unzip ("household_power_consumption.zip", exdir = "./data")
}

#Loading data from the dates 2007-02-01 and 2007-02-02
name <- c("Date", "Time", "Global_active_power", "Global_reactive_power",
          "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", 
          "Sub_metering_3")
householdpowerconsumption <- tbl_df(read.csv(
    "./data/household_power_consumption.txt", sep=";", header = FALSE, 
    na.strings = "?", col.names = name, stringsAsFactors = FALSE, 
    nrows = 2880, skip = 66637))

#Converting the Date and Time variables to Date/Time classes and creat datetime
householdpowerconsumption <- mutate(householdpowerconsumption, 
                                    datetime = dmy_hms(paste(Date, Time)))
householdpowerconsumption <- mutate(householdpowerconsumption,
                                    Date = dmy(Date),Time = hms(Time))

#Making plot 3 and export plot 3 to plot3.png
png("ExData_Plotting1/plot3.png", width=480, height=480)

with(householdpowerconsumption, plot(Sub_metering_1~datetime, type="l", 
     ylab="Energy sub metering", xlab=""))
with(householdpowerconsumption, lines(Sub_metering_2~datetime, col = "red"))
with(householdpowerconsumption, lines(Sub_metering_3~datetime, col = "blue"))
legend("topright", lty = 1, lwd = 1, col=c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
                                 
dev.off()