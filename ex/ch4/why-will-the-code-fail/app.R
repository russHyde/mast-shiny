library(shiny)

df <- data.frame(x = 1:3, y = 4:6)

ui <- fluidPage(
  selectInput("var", "Choose a column:", choices = colnames(df)),
  textOutput("results")
)

server <- function(input, output, server) {
  # var() is a bad name for a reactive
  # - the local definition `var <- ...` "prevents" any call to stats::var using
  # var() syntax, which may cause some confusion for anyone who wants to
  # compute variance within the server function
  var <- reactive(df[input$var])
  # reactives are lazily evaluated
  # - the definition of the range variable here overwrites base::range
  # - so, when range() is evaluated, it calls itself recursively
  # - but, the newly defined range() takes to arguments
  # - so passing var(), na.rm = TRUE causes the reactive-evaluation to fail
  range <- reactive(range(var(), na.rm = TRUE))
  output$results <- renderText(range())
}

shiny::shinyApp(ui, server)
