
function(input, output){
  
  output$memtype_plot <- renderPlot(
    trips %>% group_by(memtype) %>% summarise(count = n()) %>% 
      mutate(memtype = factor(memtype, levels = c('SINGLE', 'DAILY', 'THREEDAY', 'WEEKLY', 'MONTHLY', 'ANNUAL', 'FOUNDING', 'UNKNOWN'))) %>% 
      ggplot(data = .) +
      geom_bar(aes(x = memtype, y=count, fill = memtype), stat = 'identity') +
      scale_x_discrete(name = 'Type of Memberships') +
      scale_y_continuous(name = 'number of users', breaks = c(0,100000,200000,300000,400000), labels = c('0', '100k', '200k', '300k', '400k')) +
      coord_flip() +
      labs(fill = 'Membership Type')
  )
  
  output$plot1 <- renderPlot(
    ggplot(data = trips, aes(x=Checkout.DateTime)) +
      geom_density() +
      scale_x_datetime(name = 'dates', breaks = "1 year", date_labels = '%Y') +
      theme(
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank())
  )
  
  output$plot2 <- renderPlot(
    ggplot(data = trips, aes(x=month(Checkout.DateTime))) + 
      geom_histogram(binwidth = 1, colour = 'black', fill = 'white') +
      ggtitle(label = 'Number of uses per month') +
      scale_x_discrete(name = 'months', limits = 1:12, labels = c('JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC')) +
      scale_y_continuous(name = 'number of users', breaks = c(0,50000,100000,150000,200000), labels = c('0', '50k', '100k', '150k', '200k'))
  )
  
  output$plot3 <- renderPlot(
    ggplot(data = trips %>% filter(year(Checkout.DateTime) > 2015), aes(x=hour(Checkout.DateTime)+minute(Checkout.DateTime)/60)) +
      geom_density() +
      ggtitle('Number of users per time in a day') +
      scale_x_continuous(name ='Hour', limits = c(0,24)) +
      theme(
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank())
  )
  
  output$plot3.1 <- renderPlot(
    ggplot(data = trips, aes(x=hour(Checkout.DateTime))) + 
      geom_histogram(stat='count') +
      ggtitle('Number of users per Hour in a day') +
      scale_x_discrete(limits = 0:23, name = 'hour of the day') +
      scale_y_continuous(name = 'number of users', breaks = c(0,25000,50000,75000,100000),labels = c('0','25k', '50k', '75k', '100k'))
    
  )
  
  output$plot4 <- renderPlot(
    ggplot(data = trips %>% filter(tripdist != 0), aes(x=tripdist)) + xlim(0,6000) +
      geom_density() + labs(title = 'Trip Displ excl zero-displ.', x = 'Trip Displacement (in meters)') +
      theme(
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank())
  )
  
  output$plot5 <- renderPlot(
    ggplot(data = trips, aes(x=tripdist)) + xlim(0,6000) +
      geom_density() + labs(title = 'Trip Displ including zero-displacements', x = 'Trip Displacement (in meters)') +
      theme(
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank())
      
  )
  
  output$plot6.1 <- renderPlot(
    ggplot(data = trips, aes(x=log(Trip.Duration.Minutes))) + 
      geom_density() + labs(title = 'Trip Durations', x = 'log(minutes)') +
      scale_x_continuous(breaks = c(0:10)) +
      theme(
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank())
  )
  
  output$plot6.2 <- renderPlot(
    ggplot(data = trips, aes(x=Trip.Duration.Minutes)) +
      geom_density() +
      xlim(0,150) + labs(title = 'Trip Durations under 2.5 hours', x = 'Minutes') +
      theme(
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank())
  )
  
  output$checkout <- renderLeaflet(
    trips %>% select(Checkout.Kiosk.Latitude, Checkout.Kiosk.Longitude) %>% 
      rename(lat = Checkout.Kiosk.Latitude, lng = Checkout.Kiosk.Longitude) %>% 
      drop_na(lat) %>% 
      leaflet() %>% 
      addTiles() %>% 
      addHeatmap(lng = ~lng, lat = ~lat, radius = 9.5)
  )
    
  output$dropoff <- renderLeaflet(
    trips %>% select(Return.Kiosk.Latitude, Return.Kiosk.Longitude) %>% 
      rename(lat = Return.Kiosk.Latitude, lng = Return.Kiosk.Longitude) %>%
      drop_na(lat) %>% 
      leaflet() %>% 
      addTiles() %>% 
      addHeatmap(lng = ~lng, lat = ~lat, radius = 9.5)
  )
  
  output$hourly_checkout <- renderLeaflet(
    trips %>% filter(hour(Checkout.DateTime) == input$hr) %>%
      select(Checkout.Kiosk.Latitude, Checkout.Kiosk.Longitude) %>%
      rename(lat = Checkout.Kiosk.Latitude, lng = Checkout.Kiosk.Longitude) %>%
      drop_na(lat) %>%
      leaflet() %>%
      addTiles() %>%
      addHeatmap(lng = ~lng, lat = ~lat, radius = 9.5, gradient = 'Greens')
  )

  output$hourly_dropoff <- renderLeaflet(
    trips %>% filter(hour(Checkout.DateTime) == input$hr) %>%
      select(Return.Kiosk.Latitude, Return.Kiosk.Longitude) %>%
      rename(lat = Return.Kiosk.Latitude, lng = Return.Kiosk.Longitude) %>%
      drop_na(lat) %>% 
      leaflet() %>%
      addTiles() %>%
      addHeatmap(lng = ~lng, lat = ~lat, radius = 9.5, gradient = 'Blues')
  )
  
  output$daily_checkout <- renderLeaflet(
    trips %>% 
      filter(Checkout.DateTime %within% interval(input$dayrange[1], input$dayrange[2])) %>% 
      select(Checkout.Kiosk.Latitude, Checkout.Kiosk.Longitude) %>% 
      rename(lat = Checkout.Kiosk.Latitude, lng = Checkout.Kiosk.Longitude) %>% 
      drop_na(lat) %>%
      leaflet() %>%
      addTiles() %>%
      addHeatmap(lng = ~lng, lat = ~lat, radius = 9.5, gradient = 'Greens')
  )
  
  output$daily_dropoff <- renderLeaflet(
    trips %>% 
      filter(Checkout.DateTime %within% interval(input$dayrange[1], input$dayrange[2])) %>% 
      select(Return.Kiosk.Latitude, Return.Kiosk.Longitude) %>%
      rename(lat = Return.Kiosk.Latitude, lng = Return.Kiosk.Longitude) %>% 
      drop_na(lat) %>%
      leaflet() %>%
      addTiles() %>%
      addHeatmap(lng = ~lng, lat = ~lat, radius = 9.5, gradient = 'Blues')
  )

}
