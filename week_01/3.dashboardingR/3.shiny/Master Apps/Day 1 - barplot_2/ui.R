# ---------------------------------------------------------------------------- #
# ACTIVITY 1.4C  barplot_2    MASTER
# This is the ui script for a Shiny web application. You can run the
# application by clicking 'Run App' above.
# ---------------------------------------------------------------------------- #

library(shiny)

#------------------------------------------------------------------------------#
# Begin ui section
shinyUI(fluidPage(

  # Application title
  titlePanel("Exploratory plots: Barplot_2 (Master)"),

  # Add a line break
  br(),

  # Add text section
  h4("This app our first introduction to rShiny!"),
  h4("There is only 1 widget - a dropdown menu - but there is now also a text output below."),

  # Add a line break
  br(),

  # Add sidebar layout
  sidebarLayout(
    sidebarPanel(

      # Add a dropdown menu
      selectInput("xaxis", label = h3("Select the x-axis variable:"),
                  choices = list("Sex" = "sex", "Species" = "species", "Age" = "age"),
                  selected = 1),
      br(),

      # Add a text output
      verbatimTextOutput("output_text"),
      br(),

      # Add another text output
      verbatimTextOutput("output_values")

    ),

    # Show plot
    mainPanel(
      plotOutput("barPlot", height=700)
    )
  )

))
