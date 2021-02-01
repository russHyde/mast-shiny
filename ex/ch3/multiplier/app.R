# Ch3 Ex2

library(shiny)

ui <- fluidPage(
  sliderInput("x", label = "If x is", min = 1, max = 50, value = 30),
  sliderInput("y", label = "and y is", min = 1, max = 50, value = 5),
  "then, x times y is",
  textOutput("product")
)

server <- function(input, output, server) {
  output$product <- renderText({
    input[["x"]] * input[["y"]]
  })
}

shiny::shinyApp(ui, server)
