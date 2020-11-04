# ---------------------------------------------------------------------------- #
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
# ---------------------------------------------------------------------------- #

################################################################################
# SECTION 1: LOAD LIBRARIES AND DATA, THEN PROCESS DATA READY FOR THE APP      #
################################################################################

# Load in libraries
library(shiny)
library(dplyr)
library(ggplot2)
library(RColorBrewer)
library(leaflet)
library(lubridate)
library(rgdal)
library(rgeos)


# Load in data
raw_data <- read.csv("data/raw_data.csv", stringsAsFactors=FALSE)

# Create a colour palette
col_palette <- brewer.pal(name="Dark2", n=8)

# Collect list of years
yrs <- sort(unique(substr(raw_data$date, 1, 4)))

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
  mutate(region="All regions")

# Summarise region and sex data
region_species_summary <- raw_data %>%
  group_by(month, region, species, age) %>%
  summarise(n = length(month))

# Join summary data together
summary_data <- bind_rows(overall_summary, region_allspecies_summary, species_allregions_summary, region_species_summary)

# Create a dataframe that matches the
start_df <- summary_data %>%
  filter(region=="All regions" | region=="All data") %>%
  group_by(month, region, species) %>%
  summarise(n = sum(n))

# Create edited dataset for the map component, and add year and decimal date
leaflet_data <- raw_data %>% 
  mutate(year = substr(date, 1,4), date=ymd(date), date_decimal = decimal_date(date)) 

## Create a colour palette for map points
map_palette <- c("#231D51", "#178B8B", "#63C963", "#FFE31D")

## Load region shapefile
regions <- readOGR("data/TZ_Region_2012_small","TZ_Region_2012.small")

## Load protected areas shapefile
PAs <- readOGR("data/TZprotected_areas","TZprotected_areas")



#------------------------------------------------------------------------------#
# Define server logic
shinyServer(function(input, output) {

  ##############################################################################
  # SECTION 2: ADD SERVER CODE FROM THE SIMPLE BARPLOT APP                     #
  ##############################################################################

  # Produce plot
  output$barPlot <- renderPlot({
    ggplot() +
      geom_bar(data=raw_data, aes(x=raw_data[[input$xaxis]]), fill=col_palette[1]) +
      labs(x=paste0("\n", input$xaxis), y="Number of records\n") +
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

  ##############################################################################
  # SECTION 3: ADD SERVER CODE FROM THE TIME SERIES PLOT APP                   #
  ##############################################################################

  # Setup reactiveValues object that can be updated reactively
  data_subset <- reactiveValues(data = start_df)

  # Subset for the chosen region and sexes
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
    data_subset$data <- as.data.frame(data_sub)
  })

  # Produce plot
  output$tsPlot <- renderPlot({
    ggplot() +
      geom_path(data=data_subset$data, aes(x=month, y=n, color=species), size=1) +
      scale_color_manual(name="Species", values=col_palette) +
      ggtitle(paste0(input$select_region, "\n")) +
      labs(x="\nMonth", y="Number of records\n") +
      scale_x_continuous(breaks=plot_breaks, labels=yrs, limits=c(min(overall_summary$month), max(overall_summary$month))) +
      scale_y_continuous(limits=c(min(overall_summary$month), max(overall_summary$month))) +
      theme_classic() +
      theme(axis.text = element_text(size=14),
            axis.title = element_text(size=18),
            plot.title = element_text(size=20),
            legend.title = element_text(size=18),
            legend.text = element_text(size=14))
  })

  ##############################################################################
  # SECTION 4: ADD CODE FROM THE LEAFLET MAP APP                               #
  ##############################################################################

  ## Subset data based on inputs
  leaflet_data_sub<- reactive({
    leaflet_data %>% 
      filter(date>input$date[1] & date<input$date[2] & species %in% input$species)
    
  })
  
  
  ## Create text pop-up information for each point in subsetted data
  popupInfo <- reactive({
    paste("Date: ", leaflet_data_sub()$date, "<br>",
          "Species: ", leaflet_data_sub()$species, "<br>",
          "Age: ", leaflet_data_sub()$age, "<br>",
          "Sex: ", leaflet_data_sub()$sex, "<br>",
          sep = " ")
  })
  
  
  # Get point colours based on chosen variable
  pal <- reactive({
    colourby_col <- ifelse(input$colourby!="date",input$colourby,"date_decimal")
    if(input$colourby %in% c("species","sex")){ 
      colorFactor(map_palette, domain = sort(unique(leaflet_data[,colourby_col])))  
    }else if(input$colourby %in% c("date","age")){
      colorNumeric(map_palette, range(leaflet_data[,colourby_col]))
    }
  })
  
  
  ## Render map
  output$map <- renderLeaflet({
    
    ## Initialise map with tile. Set central point of viewing window and initial amount of zoom.
    m <- leaflet() %>% 
      addProviderTiles("Stamen.Terrain") %>%
      setView(c(gCentroid(regions)@coords)[1], c(gCentroid(regions)@coords)[2], zoom = 6)
    
    
    ## Add selected shapefiles
    if("regions" %in% input$shapefiles){
      m <- m %>% 
        addPolygons(data=regions,color="black",fillColor = "white",
                    label=regions$Region_Nam, weight=1, fillOpacity=0.7)}
    if("protected areas" %in% input$shapefiles){
      m <- m %>% 
        addPolygons(data=PAs,color="transparent",fillColor = "tomato",
                    weight=1, fillOpacity=0.7)}
    
    ## Add coloured points and legend
    colourby_col <- ifelse(input$colourby!="date",input$colourby,"date_decimal")
    m %>% 
      addCircles(data=leaflet_data_sub(),lng=~leaflet_data_sub()$x,lat=~leaflet_data_sub()$y,
                 color = pal()(leaflet_data_sub()[,colourby_col]),
                 opacity=1, fillOpacity=1, popup = popupInfo()) %>%
      addLegend(position = "bottomright", title = input$colourby,
                pal = pal(), values = leaflet_data[,colourby_col], opacity=1,
                labFormat = labelFormat(big.mark = "")) 
    
  })
})
