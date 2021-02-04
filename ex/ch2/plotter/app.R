library(shiny)
library(ggplot2)

datasets <- data(package = "ggplot2")$results[c(2, 4, 10), "Item"]

ui <- fluidPage(
  selectInput("dataset", "Dataset", choices = datasets),
  verbatimTextOutput("summary"),
  plotOutput("plot") # original used `tableOutput("plot")`
)

server <- function(input, output, session) {
  dataset <- reactive({
    get(input$dataset, "package:ggplot2")
  })

  # original used `output$summmry`
  output$summary <- renderPrint({
    summary(dataset())
  })

  output$plot <- renderPlot({
    # original used `plot(dataset)`
    plot(dataset())
  }, res = 96)
}

shiny::shinyApp(ui, server)
