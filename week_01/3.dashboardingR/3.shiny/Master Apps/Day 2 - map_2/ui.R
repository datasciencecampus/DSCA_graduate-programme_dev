# ---------------------------------------------------------------------------- #
# Day 2 - 2.3b Map Master App
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
# ---------------------------------------------------------------------------- #

# Load libraries
library(shiny)
library(leaflet)
library(shinyWidgets)
library(dplyr)
library(lubridate)

# Load in the raw data
raw_data <- read.csv("data/raw_data.csv", stringsAsFactors=FALSE)

# Tranform dates from characters to date objects
leaflet_data <- raw_data %>% mutate(date=ymd(date)) 

# Get the unique names of the regions for the drop down menu
all_regions <- unique(leaflet_data$region)




#------------------------------------------------------------------------------#
# Define UI for application 
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Day 2 - Map_2"),
  
  # Add a line break
  br(),
  
  # Add text section
  h4("A map app, where we can select the species to display and the variable to colour points by"),
  
  # Add a line break
  br(),
  
  sidebarLayout(
    
    # Sidebar containing the widgets
    sidebarPanel(
      
      # Drop down menu to choose variable by which points will be coloured
      selectInput(inputId="colourby", label="Colour Cases By:",
                  choices = c("species","date","sex","age"),
                  selected="species"),
      
      br(),
      
      # Menu for selecting which region to display
      pickerInput(inputId = "region", label = "Region:",
                  sort(all_regions), selected= all_regions, # Use sort to get names in alphabetical order
                  options = list(`actions-box` = TRUE,`live-search` = TRUE), multiple = T)
      
      
    ),
    
    
    # Show a plot of the map
    mainPanel(
      leafletOutput("mymap",width=800,height=500)
    )
    
  )
  

))
