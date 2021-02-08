# sec 3.3.5 ex 4

library(shiny)
library(reactable)

ui <- fluidPage(
  reactableOutput("table")
)

server <- function(input, output, server) {
  output$table <- renderReactable(reactable(mtcars))
}

shiny::shinyApp(ui, server)
