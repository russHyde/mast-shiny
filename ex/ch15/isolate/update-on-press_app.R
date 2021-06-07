# 15.4.3 Ex 1
# Make an app that updates output$out with the value of `x` only when the button is pressed

library(shiny)

ui <- fluidPage(
  numericInput("x", "x", value = 50, min = 0, max = 100),
  actionButton("capture", "capture"),
  textOutput("out")
)

server <- function(input, output, session) {
  capture_value <- eventReactive(
    input$capture,
    input$x
  )

  output$out <- renderText(capture_value())
}

shinyApp(ui, server)