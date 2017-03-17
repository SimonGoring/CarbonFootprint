
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

# Transportation, Electricity, Natural Gas

library(shiny)
library(ggplot2)
library(tidyr)
library(dplyr)

shinyServer(function(input, output, session) {

  width_calc <- reactive({ diff(c(0, input$select_coal, 100)) * 2 })
  
  e_use <- read.csv('data/energy_use.csv')
  
  output$distPlot <- renderPlot({

    e_use$electricity <- e_use$electricity * sum(width_calc() * c(0.2, 0.8, 1.50)) / 100
    
    if (input$classes == 'All') {
      
      e_use$all <- e_use %>% select(electricity:natural_gas) %>% rowSums
      
      elec_use <- e_use %>% select(students, day, all)
      
    } else if (input$classes == 'Transportation') {
      elec_use <- e_use %>% select(students, day, transportation)
    } else if (input$classes == 'Electricity') {
      elec_use <- e_use %>% select(students, day, electricity)
    } else if (input$classes == 'Natural Gas') {
      elec_use <- e_use %>% select(students, day, natural_gas)
    }
    
    colnames(elec_use)[3] <- 'measurement'
    
    ggplot(elec_use, aes(x = measurement, fill = as.factor(day))) + 
      geom_histogram(bins = input$bins, alpha = 0.5) +
      xlab('Carbon Footprint') +
      ylab('Individuals') +
      theme_bw() +
      theme(
        panel.background = element_rect(fill = "transparent"),
        plot.background = element_rect(fill = "transparent"),
        axis.text = element_text(size = 12),
        axis.title = element_text(size = 18))

  }, bg="transparent")

  output$renewable <- renderImage({ 
    return(list(
      src = 'images/noun_909391_cc.svg',
      contentType = 'image/svg+xml',
      width = width_calc()[1]
    ))
  }, deleteFile = FALSE)

  output$nat_gas <- renderImage({ 
    return(list(
      src = 'images/noun_175778_cc.svg',
      contentType = 'image/svg+xml',
      width = width_calc()[2]
    ))
  }, deleteFile = FALSE)  

  output$coal <- renderImage({ 
    return(list(
      src = 'images/noun_146997_cc.svg',
      contentType = 'image/svg+xml',
      width = width_calc()[3]
    ))
  }, deleteFile = FALSE)  

})
