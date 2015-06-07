# This is the server.R file of my final project for
# Coursera John Hopkins University Data Science Specialization: 
# Developing Data Products course.
# The file, together with the corresponding ui.R file,
# produces a shiny application that is an educational website on 
# Body Mass Index.

library(shiny)
library(googleVis)
require(rCharts)
library(rCharts)
library(rattle)

# Define functions that are used to create some of the outputs.

BMI <- function(feet, inch, pound) round((pound*0.453592)/(((feet*0.3048+0.0001)+(inch*0.0254))^2), digits=1)
CATEGORY <- function(feet, inch, pound) {
  index <- (pound*0.453592)/(((feet*0.3048+0.0001)+(inch*0.0254))^2)
  if (index<18.5){
    "Underweight"
  } else if (18.5<=index && index<25){
    "Normal Weight"
  } else if (25<=index && index<30){
    "Overweight"
  } else {
    "Obese"
  }
}

# Input data. Content of "data2" was manually input from the WHO website 
# WHO Global Database on Body Mass Index, http://apps.who.int/bmi/index.jsp'.
# Content of "data" was obtained by the following R operations:
#
# raw = read.csv("Mostrecent.csv")
# data <- raw[,c(1,3,4,5,7)]
# names(data)[names(data)=="country...indicator"] <- "Country"
# names(data)[names(data)=="BMI.adults...normal..18.5.24.99."] <- "Normal"
# names(data)[names(data)=="BMI.adults...obese....30.0."] <- "Obese"
# names(data)[names(data)=="BMI.adults...overweight....25.0."] <- "Overweight"
# names(data)[names(data)=="BMI.adults...underweight...18.5."] <- "Underweight"
# data <- data[complete.cases(data[,2:5]),]
# write.csv(data$Country,row.names = FALSE, eol = ",")
# write.csv(data$Normal,row.names = FALSE, eol = ",")
# write.csv(data$Obese,row.names = FALSE, eol = ",")
# write.csv(data$Overweight,row.names = FALSE, eol = ",")
# write.csv(data$Underweight,row.names = FALSE, eol = ",")

Country <- c("Australia","Austria","Belgium","Brazil","Bulgaria","Canada","China","Colombia","Croatia","Cuba","Cyprus","Czech Republic","Denmark","Estonia","Fiji","Finland","France","Ghana","Hungary","Iceland","India","Iran (Islamic Republic of)","Ireland","Italy","Japan","Jordan","Kiribati","Kuwait","Kyrgyzstan","Lao People's Democratic Republic","Latvia","Lithuania","Malaysia","Malta","Mongolia","Morocco","New Zealand","Norway","Pakistan","Panama","Philippines","Poland","Portugal","Republic of Korea","Romania","Saudi Arabia","Singapore","Slovakia","South Africa","Spain","Sweden","Switzerland","Thailand","Turkey","United Kingdom of Great Britain and Northern Ireland","United States of America","Vanuatu","Viet Nam","Zimbabwe")
Normal <- c(39.2,56,55.3,55.4,50.1,46.7,58.9,50.2,35.4,51.8,49.6,45.9,55.3,60.1,37.6,52.7,53.5,72.4,44.8,49.4,62.5,51.5,42.4,52.6,68.9,43,18,33.3,61.2,77.1,51.3,48.6,49.3,35.1,66.6,59.4,36.1,51,54.4,31.5,63.7,45.6,44.2,63.2,55.2,42.1,58.3,48.6,46.2,44.9,52,59.2,57,40.1,33.9,35.7,49.3,68.5,53.7)
Obese <- c(16.4,11,10.8,11.1,12.4,23.1,2.9,13.7,22.3,11.8,12.3,15.1,11.4,14.4,23.9,15.7,16.9,3.1,17.7,12.4,0.7,14.2,13,9.8,3.1,19.5,50.6,28.8,8.7,1.2,15.6,19.7,16.3,20.7,9.8,16,26.5,10,3.4,34.7,4.3,18,14.2,3.2,8.6,35.6,6.9,14.3,21.6,15.6,12,8.2,7.8,16.1,22.7,33.9,15.9,0.5,15.7)
Overweight <- c(49,42,44.1,40.6,46,59.1,18.9,46,61.4,42.5,46,51.7,41.7,42.8,56.2,48.8,49.3,11.2,53.2,48.2,4.5,42.8,56.8,44,23.2,57,81.5,64.2,35,8.5,45.2,52,47.9,62.3,31.6,35.4,62.7,44,14.4,67.4,24,52.2,53.5,32.1,41.7,72.5,32.5,46.7,45.1,53.4,45,37.3,31.5,56.4,61,66.9,48.8,5.2,37.3)-Obese
Underweight <- c(1,2,3.8,4,3.9,2.6,8,3.9,0.2,7.3,4.3,2.4,2.2,4.6,6.1,2.4,4.9,16.4,2,2.3,32.9,5.7,0.8,3.4,11.5,3,0.5,2.5,3.7,13.5,3.5,2.4,9.6,2.6,4.9,5.3,1.3,5,31.2,1,12.3,2.2,2.2,4.7,3,7,9.2,4.7,8.6,1.8,2,3.5,19.2,3.5,5.1,2.4,1.9,26.5,9.9)
data <- data.frame(Country,Normal,Obese,Overweight,Underweight)

Category <- c(rep("Underweight",15),rep("Normal",15),rep("Overweight",15),rep("Obese",15))
Year <- as.numeric(as.POSIXct(paste0(seq(from = 1988, to = 2002, by = 1),
                                     "-01-01")))
Year <- c(rep(Year,4))
USNormal <- c(42.5,42.5,42.5,42.5,42.5,42.5,42.5,61.9,61.9,61.9,36.1,39.3,38.7,38.4,40.1)
USObese <- c(22.7,22.7,11.6,12.6,13.7,22.7,22.0,16.8,16.6,18.3,19.7,30.7,21.9,27.2,13.5)
USOverweight <-c(55.0,55.0,55.0,55.0,55.0,55.0,55.0,36.7,36.7,36.7,62.5,58.3,59.2,59.2,57.5)-USObese
USUnderweight <- c(2.5,2.5,2.5,2.5,2.5,2.5,2.5,1.4,1.4,1.4,1.4,2.4,2.1,2.4,2.4)
Values <- c(USUnderweight,USNormal,USOverweight,USObese)
data2 <- data.frame(Category,Year,Values)

# shinyServer function, listing the outputs.

shinyServer(
  function(input, output) {
    
    # Text outputs for "Calculating Your BMI" tab.
    # Take as inputs the slidebar values.
    
    output$textheight <- renderText({
      paste("Your height is", input$feet, "feet and", input$inch, "inches.")
    })
    output$textweight <- renderText({
      paste("Your weight is", input$pound, "pounds.")
    })
    output$bmi <- renderText({
      paste(BMI(input$feet, input$inch, input$pound))
      })
    output$category <- renderText({
      paste(CATEGORY(input$feet, input$inch, input$pound))
      })
    
    # Graph output for "BMI Trend in the World" tab.
    # Uses GoogleVis to create interactive maps.
    # Takes as input the dropdown value.
    
    observe({
      if (input$select=="Obese") {
        output$map <- renderGvis({
          gvisGeoChart(data, locationvar="Country", 
                       colorvar="Obese",
                       options=list(projection="kavrayskiy-vii", colorAxis="{colors:['lightgrey','red']}")
          )
        })
        output$title <- renderText({"Percentage of Adult Population that is Obese"})
      } else if (input$select=="Underweight") {
        output$map <- renderGvis({
          gvisGeoChart(data, locationvar="Country", 
                       colorvar="Underweight",
                       options=list(projection="kavrayskiy-vii", colorAxis="{colors:['lightgrey','blue']}")
          )
        })
        output$title <- renderText({"Percentage of Adult Population that is Underweight"})
      } else if (input$select=="Overweight") {
        output$map <- renderGvis({
          gvisGeoChart(data, locationvar="Country", 
                       colorvar="Overweight",
                       options=list(projection="kavrayskiy-vii", colorAxis="{colors:['lightgrey','orange']}")
          )
        })
        output$title <- renderText({"Percentage of Adult Population that is Overweight"})
      } else {
        output$map <- renderGvis({
          gvisGeoChart(data, locationvar="Country", 
                       colorvar="Normal",
                       options=list(projection="kavrayskiy-vii", colorAxis="{colors:['lightgrey','green']}")
          )
        })
        output$title <- renderText({"Percentage of Adult Population that is Normal"})
      }
    })
    
    # Graph output for "BMI Trend in the US" tab.
    # Uses rChart to create an interactive chart.
    
    output$chart <- renderChart2({
      ch = Rickshaw$new()
      ch$layer ( 
        Values ~ Year,
        data = data2,
        groups = "Category",
        height = 240,
        width = 500
      )
      ch$set(
             shelving = FALSE,
             slider = FALSE,
             highlight = FALSE)
      return(ch)
    })
})