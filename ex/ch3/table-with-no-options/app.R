# sec 3.3.5 ex 4

library(shiny)

ui <- fluidPage(
  dataTableOutput("table")
)

server <- function(input, output, server) {
  output$table <- renderDataTable(
    mtcars,
    options = list(
      pageLength = 5,
      searching = FALSE,
      rowReorder = FALSE,
      rowReorder.enable = FALSE
    )
  )
}

shiny::shinyApp(ui, server)
