# ---------------------------------------------------------------------------- #
# Day 3 - Click/Hover (opt)
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
# ---------------------------------------------------------------------------- #

# Load in libraries
library(shiny)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  titlePanel("Use hover/click functions"),

  # Add a line
  hr(),

  h4(
    tags$ul(
      tags$li("The ", em("'plotly'"), " package has an built-in hover function for plots, that will display data when the user hovers over a data point."),
      tags$li("You have to replace ", code("renderPlot()"), " with ", code("renderPlotly()"), ", and ", code("plotOutput()"), " with ", code("plotlyOutput()"), "."),
      tags$li("You can either use ", code("ggplot()"), " within the ",  code("renderPlotly()"), " function, or use ", code("plot_ly()"), "."),
      tags$li(code("plot_ly()"), " is a little more complicated, but is similar in format to ", code("ggplot()"), " and ", code("leaflet()"), "."),
      tags$li("The small toolbar at the top-right of the plot gives the user more control than a standard plot."))
  ),
  br(),
  fluidRow(
    column(6,
           h4("Made in ggplot2:"),
           plotlyOutput("ggPlot", height = 400)),
    column(6,
           h4("Made in plotly: "),
           plotlyOutput("plotlyPlot", height = 400))
  ),

  br(), br(), hr(), br(),

  h4(
    tags$ul(
      tags$li("You can also get click information from a plot, which can be used to print results or feed into another plot. Try clicking on a bar on the barplot below:"))
  ),
  br(),

  fluidRow(
    column(6,
           plotlyOutput("plotlyBarPlot", height = 400)),
    column(6,
           h4(textOutput("mapText"), align = "center"),
           plotlyOutput("plotlyMap", height = 400))
  )

))
