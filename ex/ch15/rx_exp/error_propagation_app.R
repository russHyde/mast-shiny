# Ex 15.2.3
# Use reactlog to observe an error propagating through the reactives in the following app.
library(shiny)

ui <- fluidPage(
  checkboxInput("error", "error?"),
  textOutput("result")
)

server <- function(input, output, session) {
  a <- reactive({
    if (input$error) {
      stop("Error!")
    } else {
      1
    }
  })
  b <- reactive(a() + 1)
  c <- reactive(b() + 1)
  output$result <- renderText(c())
}

shinyApp(ui, server)