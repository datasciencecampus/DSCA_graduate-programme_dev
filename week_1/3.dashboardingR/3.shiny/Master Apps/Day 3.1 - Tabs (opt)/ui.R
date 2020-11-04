# ---------------------------------------------------------------------------- #
#                             TOP-TABS LAYOUT TEMPLATE                         #
#                                                                              #
# This is the user-interface definition of a Shiny web application. You can    #
# run the application by clicking 'Run App' above.                             #
# ---------------------------------------------------------------------------- #

################################################################################
# SECTION 1: LOAD LIBRARIES AND DATA, THEN PROCESS DATA READY FOR THE APP      #
################################################################################

# Load in libraries
library(shiny)
library(dplyr)
library(ggplot2)
library(shinyWidgets)
library(leaflet)
library(lubridate)

# Load in data
raw_data <- read.csv("data/raw_data.csv", stringsAsFactors=FALSE)

# Tranform dates from characters to date objects
leaflet_data <- raw_data %>% mutate(date=ymd(date)) 

# Get the unique names of the species for the drop down menu
all_species <- unique(leaflet_data$species)

# Collect a list of regions for the dropdown menu
options_list <- c("All regions", sort(unique(raw_data$region)))

# Collect min and max ages for the slider
min_age <- min(raw_data$age)
max_age <- max(raw_data$age)

# Define UI for application
shinyUI(fluidPage(

  navbarPage(title="App with all the plots",

    # -------------------------------------------------------------------------#
    # Add a tab panel
    tabPanel("Barplots",

             ###################################################################
             # SECTION 2: ADD UI CODE FROM THE SIMPLE BARPLOT APP              #
             ###################################################################

             # Section title
             titlePanel("Exploratory plots: Barplot"),

             # Add a line break
             br(),

             # Add text section
             h4("Here is the first plot we made..."),

             # Add a line break
             br(),

             # Sidebar with a slider input for number of bins
             sidebarLayout(
               sidebarPanel(

                 # Add a dropdown menu
                 selectInput("xaxis", label = h3("Select the x-axis variable:"),
                             choices = list("Sex" = "sex", "Species" = "species", "Age" = "age"),
                             selected = 1),
                 br(),

                 # Add a text output
                 verbatimTextOutput("output_text")

               ),

               # Show a plot of the generated distribution
               mainPanel(
                 plotOutput("barPlot", height=300)
               )
             ),

             # ----------------------------------------------------------------#
             # Add a horizontal line
             hr(),

             ###################################################################
             # SECTION 3: ADD UI CODE FROM THE TIME SERIES PLOT APP            #
             ###################################################################

             # Section title
             titlePanel("Exploratory plots: Timeseries"),

             # Add a line break
             br(),

             # Add text section
             h4("... and here is the second plot..."),

             # Add a line break
             br(),

             # Sidebar with a slider input for number of bins
             sidebarLayout(
               sidebarPanel(

                 # Add a dropdown menu widget
                 selectInput("select_region", label = h3("Select a Region:"),
                             choices = options_list,
                             selected = 1),
                 br(),

                 # Add a checkbox widget
                 checkboxGroupInput("select_species", label = h3("Select a Species"),
                                    choices = list("Cat" = "cat", "Dog" = "dog", "Human"="human", "Jackal"="jackal", "Lion"="lion"),
                                    selected = c("cat", "dog", "human", "jackal", "lion")),
                 br(),

                 # Add a slider
                 sliderInput("age_slider", label = h3("Select a maximum age"),
                             min = min_age, max = max_age, value = c(min_age, max_age)),
                 br(),

                 # Add an action button
                 actionButton("action_button", label = "Update plot")

               ),

               # Show a plot of the generated distribution
               mainPanel(
                 plotOutput("tsPlot", height=600)
               )
             )
             ),

    # -------------------------------------------------------------------------#
    # Add a tab panel
    tabPanel("Map",

             ###################################################################
             # SECTION 4: ADD UI CODE FROM THE LEAFLET MAP APP                 #
             ###################################################################

             # Application title
             titlePanel("Exploratory plots: Leaflet Map"),
             
             # Add a line break
             br(),
             
             # Add text section
             h4("...and here is our leaflet map."),
             
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
                 leafletOutput("map",width=800,height=500)
               )
               
               
             )
    )
  )

))
