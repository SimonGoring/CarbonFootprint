
e_use <- read.csv('data/energy_use.csv')

for(i in 1:10){
  
  day_1elec <- e_use %>% filter(day == 1) %>% select(electricity) %>% unlist %>% sample(10, replace = TRUE) %>% jitter()
  day_1ngas <- e_use %>% filter(day == 1) %>% select(natural_gas) %>% unlist %>% sample(10, replace = TRUE) %>% jitter()
  day_1tran <- e_use %>% filter(day == 1) %>% select(transportation) %>% unlist %>% sample(10, replace = TRUE) %>% jitter()
  
  day_2elec <- e_use %>% filter(day == 2) %>% select(electricity) %>% unlist %>% sample(10, replace = TRUE) %>% jitter()
  day_2ngas <- e_use %>% filter(day == 2) %>% select(natural_gas) %>% unlist %>% sample(10, replace = TRUE) %>% jitter()
  day_2tran <- e_use %>% filter(day == 2) %>% select(transportation) %>% unlist %>% sample(10, replace = TRUE) %>% jitter()
  
  e_use_add1 <- data.frame(students       = (max(e_use$student)+ 1):(max(e_use$student)+ 10),
                           day            = 1,
                           electricity    = day_1elec,
                           natural_gas    = day_1ngas,
                           transportation = day_1tran)
  
  e_use_add2 <- data.frame(students       = (max(e_use$student)+ 1):(max(e_use$student)+ 10),
                           day            = 2,
                           electricity    = day_2elec,
                           natural_gas    = day_2ngas,
                           transportation = day_2tran)
  
  e_use <- rbind(e_use, e_use_add1, e_use_add2)
}


write.csv(e_use, 'data/energy_use.csv', row.names = FALSE)

e_use <- energy_use %>% gather(consumption, measurement, electricity:natural_gas)


ggplot(e_use, aes(x = students, y = measurement)) + 
  geom_bar(stat='identity', position = 'stack', aes(fill = consumption)) +
  facet_wrap(~day)