# kiosk <- read.csv('./Austin_B-Cycle_Kiosk_Locations.csv')
# trips <- read.csv('./Austin_B-Cycle_Trips.csv')
# 
# #cleaning ups####
# 
# trips <- kiosk %>%
#   select(Kiosk.ID, Kiosk.Name, Kiosk.Status, Latitude, Longitude, Location) %>%
#   rename(Checkout.Kiosk.ID = Kiosk.ID,
#          Checkout.Kiosk = Kiosk.Name,
#          Checkout.Kiosk.Status = Kiosk.Status,
#          Checkout.Kiosk.Latitude = Latitude,
#          Checkout.Kiosk.Longitude = Longitude,
#          Checkout.Kiosk.Location = Location) %>%
#   left_join(trips %>% select(-Checkout.Kiosk.ID), ., by = 'Checkout.Kiosk')
# 
# trips <- kiosk %>%
#   select(Kiosk.ID, Kiosk.Name, Kiosk.Status, Latitude, Longitude, Location) %>%
#   rename(Return.Kiosk.ID = Kiosk.ID,
#          Return.Kiosk = Kiosk.Name,
#          Return.Kiosk.Status = Kiosk.Status,
#          Return.Kiosk.Latitude = Latitude,
#          Return.Kiosk.Longitude = Longitude,
#          Return.Kiosk.Location = Location) %>%
#   left_join(trips %>% select(-Return.Kiosk.ID), ., by = 'Return.Kiosk')
# 
# trips <- trips %>%
#   mutate(Checkout.DateTime = lubridate::mdy_hms(paste(trips$Checkout.Date, trips$Checkout.Time, sep = ' '))) %>%
#   select(-Checkout.Date, -Checkout.Time, -Month, -Year)
# 
# DistTwoCoords <- function(lat1, lon1, lat2, lon2) {
#   earth_radius = 6371009 #meters
#   phi = (lat1+lat2)/2
#   return(earth_radius*sqrt(((lat2-lat1)*pi/180)^2+(cos(phi*pi/180)*(lon2-lon1)*pi/180)^2))
#   #should return in meters?
# }
# 
# trips <- trips %>% mutate(tripdist = DistTwoCoords(Checkout.Kiosk.Latitude,
#                                                    Checkout.Kiosk.Longitude,
#                                                    Return.Kiosk.Latitude,
#                                                    Return.Kiosk.Longitude))
# 
# #aggregating membership types into 8 types
# 
# memtypes <- trips$Membership.Type %>% levels()
# 
# unknown <- c(memtypes[1], memtypes[14], memtypes[60], memtypes[63])
# single <- c(memtypes[2], memtypes[3], memtypes[59], memtypes[64], memtypes[67],memtypes[68], memtypes[69],memtypes[70], memtypes[71], memtypes[74])
# daily <- c(memtypes[4], memtypes[5], memtypes[6], memtypes[7], memtypes[40], memtypes[41])
# threeday <- c(memtypes[8], memtypes[9], memtypes[12], memtypes[13], memtypes[44], memtypes[75], memtypes[76])
# weekly <- c(memtypes[10], memtypes[11])
# monthly <- c(memtypes[45], memtypes[47], memtypes[48], memtypes[49], memtypes[50], memtypes[51], memtypes[52], memtypes[53], memtypes[54], memtypes[55], memtypes[56], memtypes[57])
# annual <- c(memtypes[15], memtypes[16], memtypes[17], memtypes[18], memtypes[19], memtypes[20], memtypes[21], memtypes[22], memtypes[23], memtypes[24], memtypes[25], memtypes[26], memtypes[27], memtypes[28], memtypes[29], memtypes[30], memtypes[31], memtypes[32], memtypes[33], memtypes[34], memtypes[35], memtypes[36], memtypes[37], memtypes[38], memtypes[46], memtypes[58], memtypes[61], memtypes[62], memtypes[65], memtypes[66], memtypes[72], memtypes[73])
# founding <- c(memtypes[39], memtypes[42], memtypes[43])
# 
# MembershipTypeCleaning <- function(typ) {
#   if(typ %in% unknown) return('UNKNOWN')
#   else if(typ %in% single) return('SINGLE')
#   else if(typ %in% daily) return('DAILY')
#   else if(typ %in% threeday) return('THREEDAY')
#   else if(typ %in% weekly) return('WEEKLY')
#   else if(typ %in% monthly) return('MONTHLY')
#   else if(typ %in% annual) return('ANNUAL')
#   else if(typ %in% founding) return('FOUNDING')
#   return('ERROR')
# }
# 
# trips$memtype <- map(trips$Membership.Type, MembershipTypeCleaning)
# trips$memtype = as.character(trips$memtype)
library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)
library(tidyverse)
library(lubridate)
library(leaflet)
library(leaflet.extras)
library(RColorBrewer)
library(shinydashboard)
library(shinyWidgets)

trips <- read.csv('./trips_final.csv')
trips <- trips %>% mutate(Checkout.DateTime = lubridate::ymd_hms(Checkout.DateTime))

