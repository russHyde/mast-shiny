library(shiny)

ui <- fluidPage(
  selectInput(
    "choices",
    "Favourite animal?",
    choices = list(
      Hairy = list("Dog" = "dog", "Llama" = "llama"),
      Scaly = list("Fish" = "fish"),
      Feathery = list("Bird" = "bird", "Dinosaur" = "dinosaur")
    )
  )
)

server <- function(input, output, server) {}

shiny::shinyApp(ui, server)
