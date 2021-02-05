# sec 3.3.5, ex1

library(shiny)

ui <- fluidPage(
  plotOutput("plot", height = "300px", width = "700px")
)

server <- function(input, output, server) {
  output$plot <- renderPlot(plot(1:5), res = 96)
}

shiny::shinyApp(ui, server)
