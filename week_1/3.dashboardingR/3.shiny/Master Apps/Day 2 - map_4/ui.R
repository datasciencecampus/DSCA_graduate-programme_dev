# ---------------------------------------------------------------------------- #
# Day 2 - 2.3d Map Master App
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

# Get the unique names of the species for the drop down menu
all_species <- unique(leaflet_data$species)


#------------------------------------------------------------------------------#
# Define UI for application 
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Day 2 - Map_4"),
  
  # Add a line break
  br(),
  
  # Add text section
  h4("A map app, where we can select the species to display and the variable to colour points by.  
     Optional display of region and protected area shapefiles.  This app now also has a slider to 
     select the date range of the points displayed"),
  
  # Add a line break
  br(),
  
  sidebarLayout(
    
    # Sidebar containing the widgets
    sidebarPanel(
      
      # Slider for date selection
      sliderInput(inputId = "date", label = "Date:", 
                  min = min(leaflet_data$date), max =max(leaflet_data$date),
                  value=c(min(leaflet_data$date), max(leaflet_data$date)),
                  timeFormat="%b %Y"),
      
      br(),
      
      # Drop down menu to choose variable by which points will be coloured
      selectInput(inputId="colourby", label="Colour Cases By:",
                  choices = c("species","date","sex","age"),
                  selected="species"),
      
      br(),
      
      # Menu for selecting which species to display
      pickerInput(inputId = "species", label = "Species:",
                  sort(all_species), selected= all_species, # Use sort to get names in alphabetical order
                  options = list(`actions-box` = TRUE,`live-search` = TRUE), multiple = T),
      
      br(),
      
      # Checkboxes for choosing shapefiles to be displayed 
      checkboxGroupInput("shapefiles", label = "Select background polygons:",
                         choices =  c("regions", "protected areas"),
                         selected = c("regions"))
      
      
    ),
    
    
    # Show a plot of the map
    mainPanel(
      leafletOutput("mymap",width=800,height=500)
    )
    
    
  )
  

))
