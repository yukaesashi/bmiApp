# This is the ui.R file of my final project for
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

# The page has 4 tabs: About, Calculate Your BMI, BMI Trend in the World, and
# BMI Trend in the US.

shinyUI(navbarPage("Body Mass Index (BMI)",
                   
             # This tab, "About", introduces the concept of BMI and navigates
             # Users to the rest of the website.
             # It uses MathJax to print mathematical formulas.
                   
             tabPanel("About",
                      h4('This is an educational application on Body Mass Index.'),
                      p('Body Mass Index (BMI) is a measure of a person\'s body fat 
                      based on height and weight. It is defined as:'),
                      withMathJax(),
                      helpText('$$\\text{BMI}=\\frac{{\\text{mass }}_{\\text{kg}}}{{\\text{height }}_{\\text{m}}^2}=\\frac{{\\text{mass }}_{\\text{lb}}}{{\\text{height }}_{\\text{inch}}^2}\\times702$$'),
                      p('It can be used to place you in one 
                      of the following weight categories:'),
                      helpText('$$\\text{Underweight: BMI}<18.5$$'),
                      helpText('$$\\text{Normal: } 18.5\\leq\\text{BMI}<25$$'),
                      helpText('$$\\text{Overweight: } 25\\leq\\text{BMI}<30$$'),
                      helpText('$$\\text{Obese: } 30<\\text{BMI}$$'),
                      h4('Click on the tab...'),
                      tags$div(
                      tags$ul(
                      tags$li("\"Calculate Your BMI\" to find out what your
                      BMI is by entering your height and weight."),
                      tags$li("\"BMI Trend in the World\" to 
                        view interactive maps that show percentage of adult population in different countries 
                          that is underweight, normal, overweight or underweight."),
                      tags$li("\"BMI Trend in the US\" to 
                        view an interactive chart that shows the change in percentage distribution of 
                        weight categories in the US.")
                      ))
             ),
             
             # This tab, "Calculate Your BMI", lets users
             # calculate their BMI by inputting their height and weight
             # using slidebars.
             
             tabPanel("Calculate Your BMI",
                sidebarLayout(
                  sidebarPanel(
                    p('Find out your BMI and weight category by
                      entering your weight and height using the sliders below.'),
                    h4('Your height in feet and inches'),
                    sliderInput('feet','Feet', min=0, max=10, value=0),
                    sliderInput('inch','Inches', min=0, max=11, value=0),
                    h4('Your weight in pounds'),
                    sliderInput('pound','Pounds', min=50, max=300, value=0)
                  ),
                  mainPanel(
                    h3('Results'),
                    textOutput("textheight"),
                    textOutput("textweight"),
                    
                    h4('Your BMI:'),
                    textOutput("bmi"),
                    h4('Your Weight Category:'),
                    textOutput("category")
                  )
                  )
                ),
             
             # This tab, "BMI Trend in the World",
             # displays maps showing percentage of adult population in different countries 
             # that is underweight, normal, overweight or underweight, depending on 
             # user input in the dropdown list.
             
             tabPanel("BMI Trend in the World",
                      sidebarLayout(
                        sidebarPanel(         
                          p('Select one of the categories below to view a map showing the 
                          percentage of adult population in different countries 
                          that is underweight, normal, overweight or underweight.'),
                          p('(See tab "About" for details on these categories)'),
                          p('Hover the mouse over the maps to view the percentage for different countries.'),
                          p('Source: WHO Global Database on Body Mass Index, http://apps.who.int/bmi/index.jsp'),
                          p('Figures are taken from the most recent record available for each country.'),
                          selectInput("select", label=h4("Select Category"),
                                      choices = list("Underweight","Normal","Overweight","Obese")
                                      )
                        ),
                        mainPanel(
                          h4(textOutput("title")),
                          htmlOutput("map")
                        )
                      )
             ),
             
             # This tab, "BMI Trend in the US", displays
             # chart on the right showing the change in percentage distribution of 
             # BMI categories in the US over the years.
             
             tabPanel("BMI Trend in the US",
                      sidebarLayout(
                        sidebarPanel(
                          p('The chart on the right shows the change in percentage distribution of 
                        BMI categories in the US over the years. Hover your mouse over the chart
                            to see the values of individual plots.'),
                          p('Source: Most of the data points were obtained from WHO Global Database on Body Mass Index, http://apps.who.int/bmi/index.jsp,
                            however some numbers have been modified to demonstrate the functionality 
                            of this chart.
                            ')
                        ),
                         mainPanel(
                           h4('Change in Percentage Distribution of BMI Categories in the US'),
                           div(
                              # This is CSS code that the Rickshaw chart depends on.
                              HTML("<style>
                                  .chart_container {
                                  position: relative;
                                  display: inline-block;
                                  font-family: Arial, Helvetica, sans-serif;
                                  }
                                  .rChart {
                                  display: inline-block;
                                  margin-left: 40px;
                                  }
                                  .yAxis {
                                  position: absolute;
                                  top: 0;
                                  bottom: 0;
                                  width: 40px;
                                  }
                                  .legend {
                                  position: absolute;
                                  top: 0;
                                  right: -160px;
                                  vertical-align: top;
                                  }
                                  .slider {
                                  margin-left: 40px;
                                  margin-top: 12px;
                                  }
                                  </style>"),
                             showOutput("chart","rickshaw"))
                         )
                      )
               
             )
))
