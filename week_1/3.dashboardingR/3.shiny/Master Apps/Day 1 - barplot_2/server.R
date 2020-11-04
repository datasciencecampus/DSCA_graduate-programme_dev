# ---------------------------------------------------------------------------- #
# ACTIVITY 1.4C  barplot_2    MASTER
# This is the server script for a Shiny web application. You can run the
# application by clicking 'Run App' above.
# ---------------------------------------------------------------------------- #

library(shiny)
library(dplyr)
library(ggplot2)
library(RColorBrewer)

raw_data <- read.csv("data/raw_data.csv", stringsAsFactors=FALSE)

# Create a colour palette
col_palette <- brewer.pal(name="Dark2", n=8)

#------------------------------------------------------------------------------#
# Begin server section
shinyServer(function(input, output) {

  # Produce plot
  output$barPlot <- renderPlot({
   ggplot() +
      geom_bar(data=raw_data, aes(x=raw_data[[input$xaxis]]), fill=col_palette[1]) +
      labs(x=paste0("\n", input$xaxis), y="Number of records\n") +
      # Extra plotting code to control appearence
      theme_classic() +
      theme(axis.text = element_text(size=14),
            axis.title = element_text(size=18),
            plot.title = element_text(size=20),
            legend.title = element_text(size=18),
            legend.text = element_text(size=14))
  })

  # Produce text output
  output$output_text <- renderPrint({
    paste0("You have chosen to show '", input$xaxis, "' on the x-axis.")
    })

  # Produce a second text output
  output$output_values <- renderPrint({
    summary(raw_data[[input$xaxis]])
  })

})
