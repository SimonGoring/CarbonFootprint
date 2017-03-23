
# Transportation, Electricity, Natural Gas

library(shiny)
library(ggplot2)
library(tidyr)
library(dplyr)

shinyServer(function(input, output, session) {

  width_calc <- reactive({ diff(c(0, input$select_coal, 100)) * 2 })
  
  e_use <- read.csv('data/energy_use.csv')
  
  output$distPlot <- renderPlot({
    
    e_use$transportation <- e_use$transportation * 2400  # L fuel to g Carbon / L fuel.
    e_use$natural_gas    <- e_use$natural_gas    * 453   # kwh to g Carbon / kwh
    e_use$electricity    <- e_use$electricity * width_calc()[2] / 100 * 453 +
      e_use$electricity * width_calc()[3] / 100 * 1024
    
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
      geom_histogram(bins = input$bins, alpha = 0.9, color = 'black') +
      xlab('Carbon Footprint (kg of Carbon)') +
      ylab('Number of Individuals') +
      theme_bw() +
      scale_fill_manual(values = c('#F78D3F', '#2BBBD8')) +
      theme(
        panel.background = element_rect(fill = "transparent"),
        plot.background = element_rect(fill = "transparent"),
        axis.text = element_text(size = 16, color = '#000000'),
        axis.title = element_text(size = 20),
        legend.position = 'none')

  }, bg="transparent")

  output$boxPlot <- renderPlot({
    
    e_use$transportation <- e_use$transportation * 2400  # L fuel to g Carbon / L fuel.
    e_use$natural_gas    <- e_use$natural_gas    * 453   # kwh to g Carbon / kwh
    e_use$electricity    <- e_use$electricity * width_calc()[2] / 100 * 453 +
      e_use$electricity * width_calc()[3] / 100 * 1024
    
    e_use <- e_use %>% gather(consumption, measurement, electricity:natural_gas)
    
    ggplot(e_use, aes(x = consumption, fill = as.factor(day), y = measurement)) + 
      geom_boxplot(alpha = 0.9) +
      theme_bw() +
      scale_x_discrete(labels = c('Electricity', 'Natural Gas', 'Transportation')) +
      xlab('Energy Consumption') +
      ylab('kg of Carbon') +
      theme(
        panel.background = element_rect(fill = "transparent"),
        plot.background = element_rect(fill = "transparent"),
        axis.text = element_text(size = 16, color = '#000000'),
        axis.title = element_text(size = 20),
        legend.position = 'none') + 
      scale_fill_manual(values = c('#F78D3F', '#2BBBD8'))
    
  })
  
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

  output$donut <- renderImage({ 
    return(list(
      src = 'images/noun_781313_cc.svg',
      contentType = 'image/svg+xml'
    ))
  }, deleteFile = FALSE)  
  
  output$donut_wt <- renderText({
    e_use$transportation <- e_use$transportation * 2400  # L fuel to g Carbon / L fuel.
    e_use$natural_gas    <- e_use$natural_gas    * 453   # kwh to g Carbon / kwh
    e_use$electricity    <- e_use$electricity * width_calc()[2] / 100 * 453 +
      e_use$electricity * width_calc()[3] / 100 * 1024
    e_use$all <- e_use %>% select(electricity:natural_gas) %>% rowSums
    
    return(as.character(mean(e_use$all, na.rm=TRUE)))
      
  })
  
})
