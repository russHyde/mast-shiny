library(shiny)
library(readr)
library(dplyr)

sales <- readr::read_csv(
  "https://raw.githubusercontent.com/hadley/mastering-shiny/master/sales-dashboard/sales_data_sample.csv"
)
sales <- sales[c(
  "TERRITORY", "ORDERDATE", "ORDERNUMBER", "PRODUCTCODE", "QUANTITYORDERED",
  "PRICEEACH"
)]

ui <- fluidPage(
  selectInput("territory", "territory", choices = unique(sales$TERRITORY)),
  tableOutput("selected")
)

server <- function(input, output, session) {
  selected <- reactive({
    if (input$territory == "NA") {
      subset(sales, is.na(TERRITORY))
    } else {
      subset(sales, TERRITORY == input$territory)
    }
  })
  output$selected <- renderTable(head(selected(), 10))
}

shinyApp(ui, server)