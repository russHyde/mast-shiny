# Section 3.2.8 / Ex1
library(shiny)

ui <- fluidPage(
  textInput("name", NULL, placeholder = "Your name")
)

server <- function(input, output, server) {}

shiny::shinyApp(ui, server)
