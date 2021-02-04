library(shiny)

ui <- fluidPage(
  sliderInput(
    "chosen_number",
    "Pick a number",
    min = 0, max = 100, value = 20, step = 5, animate = TRUE
  )
)

server <- function(input, output, server) {}

shinyApp(ui, server)
