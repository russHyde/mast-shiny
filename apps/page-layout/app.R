# See section 3.4

library(shiny)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(),
    mainPanel()
  )
)

server <- function(input, output, server) {}

shiny::shinyApp(ui, server)
