# ---------------------------------------------------------------------------- #
# ACTIVITY 1.4g  timeseries_4   MASTER
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
options_list <- c("All regions", sort(unique(raw_data$region)))

# Collect min and max ages for the slider
min_age <- min(raw_data$age)
max_age <- max(raw_data$age)

#------------------------------------------------------------------------------#
# Begin ui section
shinyUI(fluidPage(

  # Application title
  titlePanel("Day 1 - Timeseries_4"),

  # Add a line break
  br(),

  # Add text section
  h4("This app is identical to the last, with a new widget: actionButton"),
  h4("One action button triggers the plot update after the user has set the other widget values, the other resets the plot and widget values to the default."),

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
      actionButton("action_button", label = "Update plot"),

      # Add another action button
      actionButton("reset_button", label = "Reset plot")

    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("tsPlot", height=700)
    )
  )

))
