# ---------------------------------------------------------------------------- #
#                             TOP-TABS LAYOUT TEMPLATE                         #
#                                                                              #
# This is the user-interface definition of a Shiny web application. You can    #
# run the application by clicking 'Run App' above.                             #
# ---------------------------------------------------------------------------- #

library(shiny)

# Define UI for app
shinyUI(fluidPage(

  navbarPage(title="Page title",

    # Add a tab panel
    tabPanel("tab 1 name",
             "tab 1 contents"),

    # Add a tab panel
    tabPanel("tab 2 name",
             "tab 2 contents")
  )

))
