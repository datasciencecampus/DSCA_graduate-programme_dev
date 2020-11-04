# ---------------------------------------------------------------------------- #
# ACTIVITY 1.4f  timeseries_3    MASTER
# This is the ui script for a Shiny web application. You can run the
# application by clicking 'Run App' above.
# ---------------------------------------------------------------------------- #

# Load in libraries
library(shiny)
library(dplyr)
library(ggplot2)

# Load in the raw data
raw_data <- read.csv("data/raw_data.csv", stringsAsFactors=FALSE)

# Collect a list of regions for the dropdown menu
options_list <- c("All Regions", sort(unique(raw_data$region)))

# Collect min and max ages for the slider
min_age <- min(raw_data$age)
max_age <- max(raw_data$age)

#------------------------------------------------------------------------------#
# Begin ui section
shinyUI(fluidPage(

  # Application title
  titlePanel("Exploratory plots: Timeseries_3 (Master)"),

  # Add a line break
  br(),

  # Add text section
  h4("This app is identical to the last, with a new widget: checkboxGroupInput"),
  h4("Using these widgets together, we can change the region, the species and the minimum/maximum age we want to view on the plot. The line showing 'all data' will always be visible!"),

  # Add a line break
  br(),

  # Add a sidebarLayout
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
                  min = min_age, max = max_age, value = c(min_age, max_age))

    ),

    # Show plot
    mainPanel(
      plotOutput("tsPlot", height=700)
    )
  )

))
