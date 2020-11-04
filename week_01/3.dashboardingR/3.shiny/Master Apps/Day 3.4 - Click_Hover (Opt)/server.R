# ---------------------------------------------------------------------------- #
# Day 3 - Click/Hover (opt)
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
# ---------------------------------------------------------------------------- #

# Load in libraries
library(shiny)
library(ggplot2)
library(RColorBrewer)
library(lubridate)
library(plotly)
library(scales)
library(rgdal)
library(dplyr)

# Load in the raw data
raw_data <- read.csv("data/raw_data.csv", stringsAsFactors=FALSE)
region_shp <- readOGR("data/TZ_Region_2012", "TZ_Region_2012")

# Transform shapefile to dataframe
region_shp <- region_shp[which(region_shp$Region_Nam %in% c("Mara", "Arusha", "Simiyu")),]
region_shp@data$id <- rownames(region_shp@data)
region_df <- fortify(region_shp, region = "id")
region_df <- merge(region_df, region_shp@data, by = "id")

# Create a colour palette
col_palette <- brewer.pal(name="Dark2", n=8)

# Format as a date
raw_data$date <- as.Date(raw_data$date)
raw_data$year <- substr(raw_data$date, 1,4)

# Create subset for plotting
raw_data_subset <- raw_data %>%
  filter(year==2014)

# Summarise data by year and species
summary_data <- raw_data %>%
  filter(region %in% c("Mara", "Arusha", "Simiyu")) %>%
  group_by(year, species) %>%
  summarise(n = length(species))
map_data <- raw_data %>%
  filter(region %in% c("Mara", "Arusha", "Simiyu"))

#------------------------------------------------------------------------------#
# Begin shinyServer section
shinyServer(function(input, output) {

  # Produce ggplot rendered by plotly
  output$ggPlot <- renderPlotly({
    ggplot() +
      geom_point(data = raw_data_subset, aes(x = date, y = age, color = species)) +
      labs(x = "Date", y = "Age") +
      scale_color_manual(name="", values = col_palette) +
      theme_classic()
  })

  # Produce plot_ly rendered by plotly
  output$plotlyPlot <- renderPlotly({
    plot_ly(
      data = raw_data_subset, x = ~date, y = ~age, color = ~species,
      text = ~paste("Date: ", date, "<br>Age: ", age, "<br>Species: ", species),
      hoverinfo = 'text',
      type = "scatter", mode = "markers") %>%
      layout(xaxis = list(title = "Date", showgrid = FALSE, showline = TRUE, zeroline = FALSE, ticks = "outside"),
             yaxis = list(title = "Age", showgrid = FALSE, showline = TRUE, zeroline = FALSE, ticks = "outside"))
  })

  # Produce ggplot barplot with a conversion to ggplotly to allow it to produce a click "input"
  output$plotlyBarPlot <- renderPlotly({
    ggbarplot = ggplot() +
      geom_col(data=summary_data, aes(x=species, y=n, fill=species)) +
      ggtitle("Species totals across Mara, Arusha and Simiyu regions.") +
      scale_fill_manual(values=col_palette) +
      theme_classic()

    # Convert to a plotly object to get click data
    ggplotly(ggbarplot, source="barplot")
  })

  # Produce text output using click "input"
  output$mapText <- renderText({

    click_point = event_data("plotly_click", source = "barplot")
    if(length(click_point)){

      x = as.numeric(click_point[["x"]])
      species_list = sort(unique(map_data$species))
      clicked_species = species_list[x]

      print(paste0("You have selected: ", clicked_species, " (n=", length(which(map_data$species == clicked_species)), ")"))
    } else {
      print(paste0("Click on a bar (left) to view species locations."))
    }

  })

  # Produce map output using click "input", rendered with plotly
  output$plotlyMap <- renderPlotly({

    map_plot = ggplot() +
      geom_polygon(data=region_df, aes(x=long, y=lat, group=group), color="black", fill="white") +
      theme_void() + theme(axis.line=element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
      coord_equal()

    click_point = event_data("plotly_click", source = "barplot")
    if(length(click_point)){

      x = as.numeric(click_point[["x"]])
      species_list = sort(unique(map_data$species))
      clicked_species = species_list[x]

      data_subset = map_data[which(map_data$species == clicked_species),]

      map_plot = map_plot + geom_point(data=data_subset, aes(x=x, y=y, color=species)) +
        scale_color_manual(values = c("cat" = col_palette[1], "dog" = col_palette[2], "human" = col_palette[3],
                                      "jackal" = col_palette[4], "lion" = col_palette[5])) +
        theme(legend.position="none")
    }

    print(map_plot)

  })

})
