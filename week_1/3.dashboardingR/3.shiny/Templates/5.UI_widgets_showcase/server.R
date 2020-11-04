# Server logic showing the input values (more on that in the next section)

shinyServer(function(input, output) {
    output$inputvals <- renderText( {
        paste0(capture.output(str(reactiveValuesToList(input))), collapse="\n")
    } )
}) 
