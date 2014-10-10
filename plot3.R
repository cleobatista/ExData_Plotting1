#check if the file was already extracted from zip file
if(!file.exists("household_power_consumption.txt"))
  unzip("exdata-data-household_power_consumption.zip")

#this is for the plot shows the week days in english, I live in Brazil :)
Sys.setlocale("LC_TIME", "en_US.utf8")

#this is to load the sqldf package and create only the necessary rows from the file in workspace
library(sqldf)
x<-read.csv.sql("household_power_consumption.txt",sql="SELECT * FROM file WHERE Date IN ('1/2/2007','2/2/2007')",sep=";",header=T)

#here, I concatenate the columns Date and Time for only one and after I convert it to time format, using strptime()
#The new column, I rename with "Date_time
newCol<-paste(x$Date,x$Time,sep=" ")
newTime<-strptime(newCol, "%d/%m/%Y %T")
x<-cbind(newTime,x)
x<-x[,-c(2,3)]
names(x)[1]<-"Date_Time"

#here, I create the respective png file
png(file = "plot3.png",width=480,height=480) 
plot(x$Date_Time,x$Sub_metering_1,type="l",ylab="Energy sub metering", xlab="")
lines(x$Date_Time,x$Sub_metering_2,type="l",ylab="Global Active Power(kilowatts)",col="red", xlab="")
lines(x$Date_Time,x$Sub_metering_3,type="l",ylab="Global Active Power(kilowatts)",col="blue", xlab="")
legend("topright", lty=1, col = c("black","red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"))
dev.off()
