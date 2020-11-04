# ---------------------------------------------------------------------------- #
# ACTIVITY 1.4f  timeseries_3    MASTER
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
yrs <- c(unique(year(raw_data$date)), 2015) #Extract year and take only the unique years

# Set plot breaks
plot_breaks = seq(from=0, to=12*length(yrs)-1, by=12)

# Summarise for 'all' data - this will always be plotted
overall_summary <- raw_data %>%
  group_by(month) %>%
  summarise(n = length(month)) %>%
  mutate(region="All data",
         species="All data")

# Summarise for 'all' species, divided by region data
region_allspecies_summary <- raw_data %>%
  group_by(month, region, age) %>%
  summarise(n = length(month)) %>%
  mutate(species="All species")

# Summarise for 'all' region, divided by species data
species_allregions_summary <- raw_data %>%
  group_by(month, species, age) %>%
  summarise(n = length(month)) %>%
  mutate(region="All Regions")

# Summarise region and species data
region_species_summary <- raw_data %>%
  group_by(month, region, species, age) %>%
  summarise(n = length(month))

# Join summary data together
summary_data <- bind_rows(overall_summary, region_allspecies_summary, species_allregions_summary, region_species_summary)

#------------------------------------------------------------------------------#
# Begin server section
shinyServer(function(input, output) {

  # Subset for the chosen region and species
  data_subset <- reactive({

    # Subset for region
    data_sub = summary_data %>%
      filter(region==input$select_region | region=="All data")

    # Subset for sex
    if(length(input$select_species)>0){
      data_sub = data_sub %>%
        filter(species %in% input$select_species | species=="All species" | species=="All data")
    } else {
      data_sub = data_sub %>%
        filter(species=="All species" | species=="All data")
    }

    # Subset for age
    data_sub = data_sub %>%
      filter(age >= input$age_slider[1] & age <= input$age_slider[2] | is.na(age))

    # Summarise data using subsets created above
    data_sub = data_sub %>%
      group_by(month, region, species) %>%
      summarise(n = sum(n))
    as.data.frame(data_sub)
  })

  # Produce plot
  output$tsPlot <- renderPlot({
   ggplot() +
      geom_path(data=data_subset(), aes(x=month, y=n, color=species), size=1) +
      scale_color_manual(name="Species", values=col_palette) +
      labs(title=input$select_region, x="Date (Month)", y="Number of records") +
      # Extra plotting code to control appearence
      scale_x_continuous(breaks=plot_breaks, labels=yrs, limits=c(min(overall_summary$month), max(overall_summary$month))) +
      theme_classic() +
      theme(axis.text = element_text(size=14),
            axis.title = element_text(size=18),
            plot.title = element_text(size=20),
            legend.title = element_text(size=18),
            legend.text = element_text(size=14))
  })

})
