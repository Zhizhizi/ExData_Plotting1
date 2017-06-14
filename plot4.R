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

#Making plot 4
par(mfrow = c(2, 2), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))

with(householdpowerconsumption, plot(Global_active_power~datetime, 
                                     type= "l", 
                                     ylab= "Global Active Power", 
                                     xlab= ""))

with(householdpowerconsumption, plot(Voltage~datetime, type = "l"))

with(householdpowerconsumption, {
    plot(Sub_metering_1~datetime, type="l", ylab="Energy sub metering", xlab="")
    lines(Sub_metering_2~datetime, col = "red")
    lines(Sub_metering_3~datetime, col = "blue")
    legend("topright", lty = 1, lwd = 1, bty = "n", col=c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), cex = 0.8)
})

with(householdpowerconsumption, plot(Global_reactive_power~datetime, type = "l"))


#Export plot 4 to plot4.png
dev.copy(png, file="ExData_Plotting1/plot4.png", height=480, width=480)
dev.off()