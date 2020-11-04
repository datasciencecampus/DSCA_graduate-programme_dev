#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)



# load_cache --------------------------------------------------------------


gapminder_full <- readRDS("cache/gapminder.rds")
gapminder_africa <- readRDS("cache/gapminder_africa.rds")

#list the data available at this point
available_data <- objects()

listed_data <- list(gapminder_africa = gapminder_africa,
                    gapminder_full = gapminder_full)


join_list <- list(left_join =  left_join,
                  right_join = right_join,
                  inner_join = inner_join,
                  semi_join = semi_join,
                  full_join = full_join,
                  anti_join = anti_join)



# UI ----------------------------------------------------------------------


# Define UI for application that draws a histogram
ui <- fluidPage(theme = "C:\\Users\\leyshr\\OneDrive - Office for National Statistics\\Graduate Curriculum\\DSCA_graduate-curriculum_dev\\week_1\\3.dashboardingR\\www\\style.css",

    # Application title
    titlePanel("unifyR"),

    # Sidebar with a slider input for number of bins 
fluidRow(
    column(width = 12,
tags$h1('Step 1. Select datasets to join.')),

column(width = 6,
       selectInput(inputId = "df_a",
                   label = "Select First Dataset:",
                   choices = available_data,
                   selected = "gapminder_africa")),

column(width = 6,
       selectInput("df_b",
                   "Select Second Dataset:",
                   available_data,
                   selected = "gapminder_full"))
),

# Selcted dataframe heads

fluidRow(
    column(width = 6, h3("Head of dataset 1"), tableOutput(outputId = 'table_a_head')),
    column(width = 6, h3("Head of dataset 2"), tableOutput('table_b_head'))
    ),


#specify join
column(width = 12,
       tags$h1('Step 2. Select a join type to execute.')),


column(width = 12,
       selectInput("join_type",
                   "Select the type of join to perform:",
                   c('left_join', 'right_join', 'inner_join',
                     'semi_join', 'full_join', 'anti_join'),
                   selected = "left_join")),

#ouput view
column(width = 12,
       tags$h1('Step 3. View the resultant dataframe.')),


fluidRow(
    column(width = 12, h3("Output dataframe"), tableOutput('tableOut'))
) #end of fluid row


)#end of fluid page




# server ------------------------------------------------------------------





# Define server logic required to draw a histogram
server <- function(input, output) {

    # function to execute join
    execute_join <- function(df_a, df_b, join_type) {
        data_joined <-  join_type(df_a, df_b)
        return(data_joined)
    }
    
  
#generate df for selection 1
    
    df_a_full <- reactive({
      
        a <- data.frame(listed_data[[input$df_a]])
        return(a)
        
    })
    
    
    #genereate head for display
    df_a_head <- reactive({
        a_head <- head(df_a_full())
        return(a_head)
        })
    
    
    #generate df for selection 2
    df_b_full <- reactive({
        b <- data.frame(listed_data[[input$df_b]])
        return(b)
    })
#generate head for display
    df_b_head <- reactive({
        b_head <- head(df_b_full())
        return(b_head)
        })
    
    
    join_function <- reactive({

        joining_with <- join_list[[input$join_type]]
        return(joining_with)
    })
    
    
    
    #render the heads for display
    output$table_a_head <- renderTable(df_a_head())
    output$table_b_head <- renderTable(df_b_head())
    
    #render the joined df
    output$tableOut <- renderTable(execute_join(df_a_full(),
                                                df_b_full(),
                                                join_function())) #Note how df_subset() was used and not df_subset
    "This will work with statis join type, but not picking up reactive join type"
   
    
    #reactive({ browser(); join(a(), b()) })
} # End of server
        



#listed_data[[available_data[2]]]

# Run the application 
shinyApp(ui = ui, server = server)
