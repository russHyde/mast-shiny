# ch3 : ex1
# - used in sec 4.3
library(shiny)

ui <- fluidPage(
  textInput("name", "What's your name?"),
  textOutput("greeting")
)

server <- function(input, output, server) {
  output$greeting <- renderText({
    paste0("Hello ", input$name)
  })
}

shiny::shinyApp(ui, server)
