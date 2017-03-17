
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(shinythemes)

shinyUI(fluidPage(theme = shinytheme('slate'),

  # Application title
  titlePanel("Your Carbon Footprint", windowTitle = "CarbonFootprint"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30),
      selectInput('classes', 'Category', 
                  choices = c('All', 'Transportation', 'Electricity', 'Natural Gas'), multiple = FALSE),
      HTML("<h2>Electricity Source</h2>"),
      sliderInput('select_coal', "Renewable, Natural Gas, Coal", min = 0, max = 100, value = c(10, 49), step = 1),
      htmlOutput("Percentages")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      fluidRow(
        column(12,
               plotOutput("distPlot"),
               fluidRow(
                 column(4, align="center", HTML("<h3>Renewables</h3>")),
                 column(4, align="center", HTML("<h3>Natural Gas</h3>")),
                 column(4, align="center", HTML("<h3>Coal</h3>")),
                 fluidRow(column(4, align="center", plotOutput('renewable')),
                          column(4, align="center", plotOutput('nat_gas')),
                          column(4, align="center", plotOutput('coal'))))
        )
      ))
  )
))
