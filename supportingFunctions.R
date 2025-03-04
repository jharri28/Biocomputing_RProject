# supportingFunctions.R : a script containing serveral functions to manage the data for RProject
setwd("~/Desktop/Biocomputing/Rnovice/TestRProject/")
#I moved all files from RProject2022 dir into RProject, so the path may need to be edited

# Create a function to convert all Tab and Space delimited .txt files into comma delimited .csv files
convert_files <- function(countries) {
  #First make it so that your function enters the correct dir for the countries
  for (name in countries){ 
    dir <- paste("~/Desktop/Biocomputing/Rnovice/TestRProject/country", name, sep = ' ')
    setwd(dir)
  }
  #Then make a for loop to convert each file with a .txt ending to a csv file
  file_list <- list.files
  for (file in file_list){
    data <- read.table(file, sep = c(" ", "\t"), header = TRUE)
    write.csv(data, file = paste0(file, ".csv"))
  }


}

#a function to combine all .csv files in a dir into a single .csv file
compiled_data <- function(countries, naOption){  
  #create empty data frame to put all data into
  compiledfiles <- data.frame(matrix(ncol = 14, nrow = 0))
  colnames(compiledfiles) = c('gender','age','marker01','marker02','marker03','marker04','marker05','marker06','marker07','marker08','marker09','marker10','country','dayofYear')
  #make sure in correct dir
  for (name in countries){ 
    dir <- paste("~/Desktop/Biocomputing/Rnovice/TestRProject/country", name, sep = ' ')
    setwd(dir)
  #get all .csv files in the dir
  files <- list.files(directory, pattern = .csv)
  #create for loop to go through each file in dir
  for (file in files){
    data <- read.csv(file)
    # create if else statement to accommodate user's NA choice
    if (naOption == "remove") {
      data <- data[complete.cases(data),]
    } else if(naOption == "warn"){
      if (any(is.na(data))) {
        print("Warning: NA values present in data")
    }
    }
    else if(naOption == "include"){
      data <- data
    }
    compiledfiles <- rbind(compiledfiles, data)
  }

  }
  setwd("~/Desktop/Biocomputing/Rnovice/Biocomputing_RProject/")
  write.csv(compiledfiles, file = "compiledfiles.csv")
}


#Still Need to Add country and day columns 

#Summarize data by number of screens run, percent of patients screened...
#that were infected, male vs. female patients, and the age distribution of patients.

summarize <- function(file){
  #find the number of rows and subtract the header to count the number of screens
  screens <- unique(file$doyofYear)
  print("Number of Screens:")
  print(screens)
  #Find percent of patients that were positive
  infected <- integer()
  notinfected <- integer()
  data <- read.csv("allData.csv")
  for (i in 1:nrow(data)) {
    if (any(data[i, 3:12] == 1)) {
      infected <- c(infected, i)
    }
    else{
      notinfected <-  c(notinfected, i)
    }
  }
#output data
print(paste("number of infected:", length(infected)))
print(paste("number of not infected:", length(notinfected)))
print(paste("number of total number of patients:", sum(length(infected) + length(notinfected))))
print(paste("percent postive:", (length(infected)/(length(infected) + length(notinfected))*100)))

#males infected
maleinfected <- integer()
malenotinfected <- integer()
data <- read.csv(file)
males <- data[data$gender == "male",]
for (i in 1:nrow(males)) {
  if (any(males[i, 3:12] == 1)) {
    maleinfected <- c(maleinfected, i)
  }
  else{
    malenotinfected <-  c(malenotinfected, i)
  }
}
print(paste("males infected:", length(maleinfected)))

#female infected
femaleinfected <- integer()
femalenotinfected <- integer()
data <- read.csv("allData.csv")
females <- data[data$gender == "female",]
for (i in 1:nrow(males)) {
  if (any(males[i, 3:12] == 1)) {
    femaleinfected <- c(femaleinfected, i)
  }
  else{
    femalenotinfected <-  c(femalenotinfected, i)
  }
}
print(paste("females infected:", length(femaleinfected)))

#graphing the ages
library(ggplot2)
library(cowplot)
data <- read.csv(file)
infecteddata <- data[infected,]
notinfecteddata <- data[notinfected,]
#make the infected graph first with limits to better view the data
infected_plot <- ggplot(infecteddata, aes(x=age)) +
  geom_density() + xlim(0,110) + ggtitle("Age Distribution of Infected Patients") + theme_classic()
infected_plot
#make the uninfected graph 
uninfected_plot <- ggplot(notinfecteddata, aes(x=age)) +
  geom_density() + xlim (0,110) + ggtitle("Age Distribution of Uninfected Patients") + theme_classic()
uninfected_plot

return(file)
}






