# ---------------------------------------------------------------------------- #
# ACTIVITY 1.4b  barplot_1    MASTER
# This is the ui script for a Shiny web application. You can run the
# application by clicking 'Run App' above.
# ---------------------------------------------------------------------------- #

library(shiny)

#------------------------------------------------------------------------------#
# Begin ui section
shinyUI(fluidPage(

  # Application title
  titlePanel("Exploratory plots: Barplot_1 (Master)"),

  # Add a line break
  br(),

  # Add text section
  h4("This app our first introduction to rShiny!"),
  h4("There is only 1 widget: selectInput - a dropdown menu. We have set this up to change the variable that is plotted on the x-axis."),

  # Add a line break
  br(),

  # Create a sidebar layout
  sidebarLayout(

    # Add content to the sidebar
    sidebarPanel(

      # Add a dropdown menu
      selectInput("xaxis", label = h3("Select the x-axis variable:"),
                  choices = list("Sex" = "sex", "Species" = "species", "Age" = "age"),
                  selected = 1)

    ),

    # Show plot
    mainPanel(
      plotOutput("barPlot", height=700)

    ) # Close the main panel

  )# Close the sidebarLayout

)) # Close the fluidPage and shinyUI
