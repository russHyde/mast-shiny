# Ch3 Ex2

library(shiny)

ui <- fluidPage(
  sliderInput("x", label = "If x is", min = 1, max = 50, value = 30),
  "then x times 5 is",
  textOutput("product")
)

server <- function(input, output, server) {
  output$product <- renderText({
    input[["x"]] * 5
  })
}

shiny::shinyApp(ui, server)
