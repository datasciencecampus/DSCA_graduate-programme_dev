# ---------------------------------------------------------------------------- #
# ACTIVITY 1.4g  timeseries_4   MASTER
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
  mutate(region="All regions")

# Summarise region and species data
region_species_summary <- raw_data %>%
  group_by(month, region, species, age) %>%
  summarise(n = length(month))

# Join summary data together
summary_data <- bind_rows(overall_summary, region_allspecies_summary, species_allregions_summary, region_species_summary)

# Create a dataframe that matches the end summary step in the reactive function below
start_df <- summary_data %>%
  filter(region=="All regions" | region=="All data") %>%
  group_by(month, region, species) %>%
  summarise(n = sum(n))

# Collect min and max ages for the slider
min_age <- min(raw_data$age)
max_age <- max(raw_data$age)

#------------------------------------------------------------------------------#
# Begin server section
shinyServer(function(input, output, session) {

  # Setup reactiveValues object that can be updated reactively
  data_subset <- reactiveValues(data = start_df)

  # Subset for the chosen region and species
  observeEvent(input$action_button, {

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
    data_subset$data = as.data.frame(data_sub)
  })

  # Reset the app
  observeEvent(input$reset_button, {

    # Use the default data when reset
    data_subset$data = as.data.frame(start_df)

    # Reset the widgets to their default values
    updateSelectInput(session, inputId = "select_region", selected = "All regions")
    updateCheckboxGroupInput(session, inputId = "select_species", selected = c("cat", "dog", "human", "jackal", "lion"))
    updateSliderInput(session, inputId = "age_slider", min = min_age, max = max_age, value = c(min_age, max_age))
  })

  # Produce plot
  output$tsPlot <- renderPlot({
    ggplot() +
      geom_path(data=data_subset$data, aes(x=month, y=n, color=species), size=1) +
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
