# We will use this for categorical input. RHS is what is used inside app.
# LHS are the labels shown to the user
choices <- c("Option 1"="option1", "Option 2"="option2",
             "Option 3"="option3", "Option 4"="option4")

fluidPage(
    titlePanel("Popular input controls"),
    fluidRow(
        column(3,
            wellPanel(                      
                h4("Numerical inputs"),
                numericInput("numeric1", "numericInput", value=35,
                    min=0, max=100, step=0.1   # optional
                ),
                sliderInput("slider1","sliderInput (regular slider)",
                    value=35, min=0, max=100,
                    step=1                      # optional
                ),                    
                sliderInput("slider2","sliderInput (range slider)",
                    value=c(35, 48), min=0, max=100,
                    step=1                       # optional
                )
            )   
        ),
        column(3,
            wellPanel(
                h4("Categorical inputs"),
                checkboxInput("checkbox1", "checkboxInput", value=TRUE),
                checkboxGroupInput("checkboxGroup1", "checkboxGroupInput",
                    selected=c("option1", "option3"),
                    choices=choices
                ),
                selectizeInput("selectize1", "selectizeInput", selected="option4",
                    choices=choices,
                    multiple=FALSE            # optional
                ),
                radioButtons("radioButtons1", "radioButton", selected="option3",
                    choices=choices
                )
            )
        ),
        column(3,
            wellPanel(
                h4("Date inputs"),
                dateInput("date1", "dateInput", value="2017-10-03",
                    min="2017-01-01", max="2017-12-31", # optional
                    format="dd/mm/yyyy"       # optional
                ),
                dateRangeInput("dateRange1", "dateRangeInput",
                    start="2017-10-03", end="2017-12-24",
                    min="2017-01-01", max="2017-12-31", # optional
                    format="dd/mm/yyyy"       # optional
                ),
                sliderInput("siderDate1", "sliderInput for dates",
                    value=as.Date("2017-10-03"),
                    min=as.Date("2017-01-01"), max=as.Date("2017-12-31"), #optional
                    timeFormat="%d/%m/%Y"     # optional                
                ),
                sliderInput("siderDate2", "sliderInput for dates (range slider)",
                    value=as.Date(c("2017-10-03","2017-12-24")),
                    min=as.Date("2017-01-01"), max=as.Date("2017-12-31"), #optional
                    timeFormat="%d/%m/%Y"     # optional 
                )
            )
        ),
        column(3,
            wellPanel(
               h4("Text inputs"),
               textInput("text1", "textInput", value="default content")
            ),
            wellPanel(
                h4("Buttons"),
                actionButton("button1", "actionButton",
                    icon=icon("paw")                 # optional
                )
            ),
            wellPanel(
                h4("File uploads"),
                fileInput("file1", "fileInput")
            )
        )
    ),    
    # Ignore the output for the moment, we'll look at it in the next section
    h4("Reading out the values of the input controls in R (next section)"),
    verbatimTextOutput("inputvals")
)
