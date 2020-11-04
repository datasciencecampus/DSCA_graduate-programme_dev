# ---------------------------------------------------------------------------- #
#                             SIDEBAR PANEL TEMPLATE                           #
#                                                                              #
# This is the user-interface definition of a Shiny web application. You can    #
# run the application by clicking 'Run App' above.                             #
# ---------------------------------------------------------------------------- #

library(shiny)

# Define UI for app
shinyUI(fluidPage(

  # Application title
  titlePanel("Panel Title"),

  sidebarLayout(

    # Add sidebar Panel
    sidebarPanel("Sidebar panel contents"),

    # Show a plot of the generated distribution
    mainPanel("Main panel contents")
  )

))
