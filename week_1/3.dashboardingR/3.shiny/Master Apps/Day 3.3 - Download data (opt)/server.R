# ---------------------------------------------------------------------------- #
# Day 3 - Download data (opt)
# This is the server logic of a Shiny web application. You can run the
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
#col_palette <- c("#231D51", "#178B8B", "#63C963", "#FFE31D")
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

# Summarise for 'all' sexes, divided by region data
region_allspecies_summary <- raw_data %>%
  group_by(month, region, age) %>%
  summarise(n = length(month)) %>%
  mutate(species="All species")

# Summarise for 'all' region, divided by sex data
species_allregions_summary <- raw_data %>%
  group_by(month, species, age) %>%
  summarise(n = length(month)) %>%
  mutate(region="All Regions")

# Summarise region and sex data
region_species_summary <- raw_data %>%
  group_by(month, region, species, age) %>%
  summarise(n = length(month))

# Join summary data together
summary_data <- bind_rows(overall_summary, region_allspecies_summary, species_allregions_summary, region_species_summary)

#------------------------------------------------------------------------------#
# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  # Subset for the chosen region and sexes
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


  # Prepare reactive object that creates the plot
  plotInput <- reactive({
    ts_plot <- ggplot() +
      geom_path(data=data_subset(), aes(x=month, y=n, color=species), size=1) +
      scale_color_manual(name="Species", values=col_palette) +
      ggtitle(input$select_region) +
      labs(x="Month", y="Number of records") +
      scale_x_continuous(breaks=plot_breaks, labels=yrs, limits=c(min(overall_summary$month), max(overall_summary$month))) +
      scale_y_continuous(limits=c(min(overall_summary$month), max(overall_summary$month))) +
      theme_classic() +
      theme(axis.text = element_text(size=14),
            axis.title = element_text(size=18),
            plot.title = element_text(size=20),
            legend.title = element_text(size=18),
            legend.text = element_text(size=14))
  })

  # Print the plotInput() object to render the plot correctly
  output$tsPlot <- renderPlot({
    print(plotInput())
  })

  #----------------------------------------------------------------------------#
  # Prepare file for downloading the data
  output$download_data <- downloadHandler(

    # This function returns a string which tells the client
    # browser what name to use when saving the file.
    filename = function() {
      paste0("rShiny_Timeseries_data_", Sys.Date(), ".csv")
    },

    # This function should write data to a file given to it by
    # the argument 'file'.
    content = function(file) {
      write.csv(data_subset(), file, row.names = FALSE)
    }
  )

  #----------------------------------------------------------------------------#
  # Prepare file for downloading the plot image
  output$download_plot <- downloadHandler(

    # This function returns a string which tells the client
    # browser what name to use when saving the file.
    filename = function() {
      paste0("rShiny_Timeseries_plot_", Sys.Date(), ".", input$plot_filetype)
    },

    # This function should write data to a file given to it by
    # the argument 'file'.
    content = function(file) {

      # Write to a file specified by the 'file' argument
      ggsave(file, plot = plotInput(), device = input$plot_filetype,
             width = 15, height = 10, units = "in")
    }
  )

})
