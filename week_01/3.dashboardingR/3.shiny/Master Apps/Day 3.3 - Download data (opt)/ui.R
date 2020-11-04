# ---------------------------------------------------------------------------- #
# Day 3 - Download data (opt)
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
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

# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  titlePanel("Download data and plots"),

  # Add a line break
  br(),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(

      # Add a dropdown menu widget
      selectInput("select_region", label = h4("Select a Region:"),
                  choices = options_list,
                  selected = 1),
      br(),

      # Add a checkbox widget
      checkboxGroupInput("select_species", label = h4("Select a Species"),
                         choices = list("Cat" = "cat", "Dog" = "dog", "Human"="human", "Jackal"="jackal", "Lion"="lion"),
                         selected = c("cat", "dog", "human", "jackal", "lion")),
      br(),

      # Add a slider
      sliderInput("age_slider", label = h4("Select a maximum age"),
                  min = min_age, max = max_age, value = c(min_age, max_age)),

      # Add a horizontal line
      hr(),

      h4("Download a .csv file of the time-series data:"),

      # Add a download button
      downloadButton(outputId = "download_data", label = "Download Data"),

      br(), br(),

      # Add radio button to set the file type for plot image downloads
      radioButtons(inputId = "plot_filetype", label = h4("Select a file type for plot image download:"),
                   choices = c("png", "jpeg", "pdf"),
                   inline = TRUE),

      # Add a download button
      downloadButton(outputId = "download_plot", label = "Download Plot")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("tsPlot", height = 600)
    )
  )
))
