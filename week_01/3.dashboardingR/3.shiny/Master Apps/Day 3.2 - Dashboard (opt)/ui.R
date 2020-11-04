# ---------------------------------------------------------------------------- #
# Day 3 - Day 3 - Dashboard (opt)
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
# ---------------------------------------------------------------------------- #

# Load in libraries
library(shiny)
library(dplyr)
library(ggplot2)
library(shinydashboard)
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

# Define UI for application that draws a histogram
shinyUI(dashboardPage(

  dashboardHeader(
    title="Dashboard App"
  ),

  dashboardSidebar(
    sidebarMenu(
      menuItem("Simple Barplot", tabName = "barplot", icon = icon("chart-bar")),
      menuItem("Timeseries", tabName = "timeseries", icon = icon("chart-line")),
      menuItem("Leaflet Map", tabName = "map", icon = icon("globe-africa")),
      menuItem("More info", tabName = "help", icon = icon("info"))
    )
  ),

  dashboardBody(
    tabItems(

      # First tab content
      tabItem(tabName = "barplot",
              fluidRow(
                # Section title
                titlePanel("Exploratory plots: Barplot"),

                # Add a line break
                br(),

                # Add a dropdown menu
                box(
                  selectInput("xaxis", label = h3("Select the x-axis variable:"),
                              choices = list("Sex" = "sex", "Species" = "species", "Age" = "age"),
                              selected = 1),
                  br(),

                  # Add a text output
                  verbatimTextOutput("output_text")
                ),

                box(
                  plotOutput("barPlot", height=600)
                )
              )
      ),

      tabItem(tabName = "timeseries",
              fluidRow(
                # Section title
                titlePanel("Exploratory plots: Timeseries"),

                # Add a line break
                br(),

                # Add a dropdown menu widget
                    box(width=4, height=600,
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

                box(width=8, height=600,
                    plotOutput("tsPlot", height=580))
              )
      ),

      tabItem(tabName = "map",
              fluidRow(
                # Section title
                titlePanel("Exploratory plots: Leaflet Map"),
                
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
      ),

      tabItem(tabName = "help",
              fluidRow(
                box(width=12,
                    titlePanel("More information"),
                    h4("For more information on styling and organising the Dashboard layout, please see:"),
                    h4(a(href="https://rstudio.github.io/shinydashboard/structure.html", "Structure Guide")),
                    h4(a(href="https://rstudio.github.io/shinydashboard/appearance.html", "Appearance Guide")),
                    h4(a(href="https://rstudio.github.io/shinydashboard/examples.html", "Examples"))
                )
              ))
    )
  )

))
