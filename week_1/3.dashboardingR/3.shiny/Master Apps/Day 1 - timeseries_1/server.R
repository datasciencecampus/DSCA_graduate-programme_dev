# ---------------------------------------------------------------------------- #
# ACTIVITY 1.4d  timeseries_1    MASTER
# This is the server script for a Shiny web application. You can run the
# application by clicking 'Run App' above.
# ---------------------------------------------------------------------------- #

# Load in libraries
library(shiny)
library(dplyr)
library(ggplot2)
library(RColorBrewer)
library(lubridate)

# Load in the raw data
raw_data <- read.csv("data/raw_data.csv", stringsAsFactors=FALSE)

# Create a colour palette
col_palette <- brewer.pal(name="Dark2", n=8)

# Collect list of years
raw_data$date <- as.Date(raw_data$date) # Change the structure of 'date' to a date
yrs <- c(unique(year(raw_data$date)), 2015) # Extract year and take only the unique years

# Plot Breaks
plot_breaks = seq(from=0, to=12*length(yrs)-1, by=12)

# Summarise for 'all' data
overall_summary <- raw_data %>%
  group_by(month) %>%
  summarise(n = length(month)) %>%
  mutate(region = "All Regions")

# Summarise data by region
region_summary <- raw_data %>%
  group_by(month, region) %>%
  summarise(n = length(month))

# Join summary data together
summary_data <- bind_rows(overall_summary, region_summary)

#------------------------------------------------------------------------------#
# Begin server section
shinyServer(function(input, output) {

  # Subset for the chosen region
  data_subset <- reactive({
      data_sub = summary_data %>%
        filter(region==input$select_region | region=="All Regions")
      as.data.frame(data_sub)
    })

  # Produce plot
  output$tsPlot <- renderPlot({
   ggplot() +
      geom_path(data=data_subset(), aes(x=month, y=n, color=region), size=1) +
      scale_color_manual(name="Region", values=col_palette) +
      labs(title=input$select_region, x="Date (Month)", y="Number of records") +
      # Extra plotting code to control appearence
      scale_x_continuous(breaks=plot_breaks, labels=yrs,
                         limits=c(min(overall_summary$month), max(overall_summary$month))) +
      theme_classic() +
      theme(axis.text = element_text(size=14), legend.text = element_text(size=14),
            axis.title = element_text(size=18), legend.title = element_text(size=18),
            plot.title = element_text(size=20))
  })

})
