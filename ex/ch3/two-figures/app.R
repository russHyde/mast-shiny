# sec 3.4.6 ex 1: create an app that contains two plots, each taking half of
# the page

library(shiny)

ui <- fluidPage(
  fluidRow(
    column(6, plotOutput("plot1")),
    column(6, plotOutput("plot2"))
  )
)

server <- function(input, output, server) {
  output$plot1 <- renderPlot({
    plot(1:10, rnorm(10))
  })

  output$plot2 <- renderPlot({
    hist(rnorm(100))
  })
}

shiny::shinyApp(ui, server)
