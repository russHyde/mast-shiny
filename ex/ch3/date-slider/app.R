library(shiny)
library(lubridate)

ui <- fluidPage(
  sliderInput(
    "delivery_date",
    "When should we deliver?",
    min = ymd("2020-09-16"),
    max = ymd("2020-09-23"),
    value = ymd("2020-09-17"),
    timeFormat = "%F"
  )
)

server <- function(input, output, server) {}

shiny::shinyApp(ui, server)
