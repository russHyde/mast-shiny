# Sec 3.4.6 ex 2
# CLT app with selection bar on the RHS

library(shiny)
library(shinythemes)

ui <- fluidPage(
  titlePanel("Central Limit Theorem"),
  sidebarLayout(
    mainPanel(
      plotOutput("hist")
    ),
    sidebarPanel(
      numericInput(
        "m", "Number of samples:", 2, min = 1, max = 100
      )
    )
  )
)

server <- function(input, output, server) {
  output$hist <- renderPlot({
    means <- replicate(1e4, mean(runif(input[["m"]])))
    hist(means, breaks = 20)
  }, res = 96)
}

shiny::shinyApp(ui, server)
