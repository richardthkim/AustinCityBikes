

shinyUI(dashboardPage(
  dashboardHeader(title = "Austin B-cycle"),
  dashboardSidebar(
    sidebarMenu(
      menuItem('Home',                                  tabName = '0', icon = icon('home')),
      menuItem('Membership types',                      tabName = 'memtype', icon = icon('chart-bar')),
      menuItem('Usage since Launch',                    tabName = '1', icon = icon('chart-area')),
      menuItem('Usage per month',                       tabName = '2', icon = icon('chart-area')),
      menuItem('Busiest hours of day',                  tabName = '3', icon = icon('chart-area')),
      menuItem('Distance per trip',                     tabName = '4', icon = icon('chart-area')),
      # menuItem('Duration per trip - all',               tabName = '5', icon = icon('chart-area')),
      menuItem('Duration per trip',                     tabName = '6', icon = icon('chart-area')),
      menuItem('Hottest Locations',                     tabName = '7', icon = icon('map-marked-alt')),
      # menuItem('Hottest Locations - Dropoff',           tabName = '8', icon = icon('map-marked-alt')),
      # menuItem('Hottest Locations - Combined',          tabName = '9', icon = icon('map-marked-alt')),
      menuItem('Hottest Locations - Hourly', tabName = '10', icon = icon('map-marked-alt')),
      # menuItem('Hottest Locations - Hourly - Dropoff',  tabName = '11', icon = icon('map-marked-alt'))
      menuItem('Hottest Locations - Daily', tabName = '12', icon = icon('map-marked-alt'))
      
    )
  ),
  dashboardBody(
    tags$head(
      
      
    ),
    tabItems(
      tabItem(tabName = '0', #Home
              h1('Austin\'s City Bike: B-cycle'),
              img(src="https://austin.bcycle.com/images/librariesprovider14/AustinBcycleImages/austin-logo.jpg?sfvrsn=d1214ec5_0"),
              br(),
              "Austin has brought in bike-sharing brand B-cycle for city's City Bike program, and has been rolling since December of 2013.
              Here, I've done analyses that show the usage patterns of citybikes throughout rough course of six years. "
              
              
              
      ),
      tabItem(tabName = 'memtype', #Membership types
              h1('Types of Memberships'),
              plotOutput('memtype_plot')
      ),
      tabItem(tabName = '1', #Usage since launch
              h1('Usage of Austin\'s B-cycle since Launch'),
              plotOutput('plot1')
      ),
      tabItem(tabName = '2', #Usage per month
              h1('Usage of Austin\'s B-cycle per month'),
              plotOutput('plot2')
      ),
      tabItem(tabName = '3', #busiest hours of day
              h1('Busiest hours of Austin B-cycle\'s day'),
              plotOutput('plot3'),
              plotOutput('plot3.1')
      
      ),
      tabItem(tabName = '4', #distance per trip
              h1('Average Displacement per Trip'),
              plotOutput('plot4'),
              plotOutput('plot5')
      ),
      # tabItem(tabName = '5', #distance per trip - all
      #         
      # ),
      tabItem(tabName = '6', #duration per trip
              h1('Average Duration per Trip'),
              #plotOutput('plot6.1'),
              plotOutput('plot6.2')
              
      ),
      tabItem(tabName = '7', #hottest locations - checkout
              h1('Hottest Locations to use B-cycle'),
              fluidRow(box('Checkout Locations', leafletOutput('checkout')), box('Dropoff Locations', leafletOutput('dropoff')))
              
              
      ),
      # tabItem(tabName = '8', #hottest locations - dropoff
      #         
      # ),
      # tabItem(tabName = '9', #hottest locations - combined
      #         
      # ),
      tabItem(tabName = '10', #hottest locations - hourly
              h1('Hourly usage of Austin\'s B-cycle'),
              fluidRow(box(sliderInput(inputId = 'hr', label = 'Hour of the Day', value = 9, min = 0, max = 23, step = 1, round = TRUE))),
              
              fluidRow(box('Checkout Locations',leafletOutput('hourly_checkout')),box('Dropoff Locations',leafletOutput('hourly_dropoff')))
      ),
      tabItem(tabName = '12', #hottest locations - daily
              h1('Daily usage of Austin\'s B-cycle'),
              fluidRow(box(dateRangeInput(inputId = 'dayrange', label = 'Range of Days', 
                                          start = '2018-10-05', end = '2018-10-14',
                                          min = '2013-12-21', max = '2019-11-30'))),
              fluidRow(box('Checkout Loactions', leafletOutput('daily_checkout')),box('Dropoff Locations',leafletOutput('daily_dropoff')))
      )
    )
  )
))

