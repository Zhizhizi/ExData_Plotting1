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

#Making plot 2
with(householdpowerconsumption, plot(Global_active_power~datetime, 
                                     type= "l", 
                                     ylab= "Global Active Power (kilowatts)", 
                                     xlab= ""))

#Export plot 2 to plot2.png
dev.copy(png, file="ExData_Plotting1/plot2.png", height=480, width=480)
dev.off()