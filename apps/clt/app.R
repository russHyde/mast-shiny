# See section 3.4.3

library(shiny)
library(shinythemes)

ui <- fluidPage(
  titlePanel("Central Limit Theorem"),
  sidebarLayout(
    sidebarPanel(
      numericInput(
        "m", "Number of samples:", 2, min = 1, max = 100
      )
    ),
    mainPanel(
      plotOutput("hist"),
      shinythemes::themeSelector()
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
