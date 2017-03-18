
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(shinythemes)

shinyUI(fluidPage(theme = shinytheme('journal'),

  tags$head(
    tags$style(HTML("

      .icon-row{height:100%px;padding:1%;}

      .donut-box{height:100%px;padding:3%;border-color:#000;}

      .clearfix::after {
          content: '';
          clear: both;
          display: table;
      }
      .color-box-d1{
          float:left;
          background-color:#F78D3F;
          border-style:solid;
          border-color:#000;
          border-width:2px;
          font-color: #000;
          width:30%; 
          height:auto; 
          padding:10%;
          display:inline-table;}

      .color-box-d2 {
          float:left;
          border-style:solid;
          border-color:#000;
          border-width:2px;
          background-color:#2BBBD8; 
          width:30%; 
          height:auto; 
          padding:10%;
          display:inline-table;
      }

      .child {
          display: table-cell;
          vertical-align: middle;
      }

      .image { 
         position: relative; 
         width: 100%; /* for IE 6 */
         top: 50%;
      }
      
      h5 { 
         position: absolute;
         text-align: top;
         letter-spacing: 3px;
         text-shadow: 2px 2px silver;
         font-size:100px;
         left: 0; 
         width: 100%; 
      }

    "))),
                  
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
      HTML("<h2>Legend</h2>"),
      HTML('<div class=clearfix><div class=color-box-d1>Day 1</div> <b>Baseline Observation Date</b>.  Students were expected to observe energy consumption on a "normal" day.</div>'),
      
      HTML('<div class=clearfix><div class=color-box-d2>Day 2</div> <b>Energy Conservation Date</b>. Students were expected to try their best to reduct their consumption.</div>')
    ),

    # Show a plot of the generated distribution
    mainPanel(
      fluidRow(class = 'icon-row', style='padding:0px;border-color:black;',
               column(2, align='center', HTML(paste0('<div class="child"><h2>Donuts</h2><img src="noun_781313_cc.svg" width = "100%"',
                                                     'alt="" /><h5>', 90, '</h5></div>'))),
        column(9, offset = 1, style='border-style:solid;border-color:black;border-width:2px;margin-bottom:20px;',
          fluidRow(column(3, align="center", HTML("<h3>Renewables</h3>")),
          column(3, align="center", HTML("<h3>Natural Gas</h3>")),
          column(3, align="center", HTML("<h3>Coal</h3>"))),
          fluidRow(column(3, align="center", plotOutput('renewable')),
                   column(3, align="center", plotOutput('nat_gas')),
                   column(3, align="center", plotOutput('coal')), HTML("<h2>Proportion of Energy<h2>"))),
      fluidRow(class = 'icon-row',
        column(6, plotOutput("distPlot")),
        column(6, style='height:200px;', plotOutput('boxPlot'))))
    )
  )
))
