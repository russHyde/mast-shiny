library(shiny)
library(vroom)
library(tidyverse)
library(here)

injuries <- vroom::vroom(here("neiss", "injuries.tsv.gz"))
products <- vroom::vroom(here("neiss", "products.tsv"))
population <- vroom::vroom(here("neiss", "population.tsv"))

prod_codes <- setNames(products$prod_code, products$title)

ui <- fluidPage(
  # Inputs
  fluidRow(
    column(6, selectInput("code", "Product", choices = prod_codes))
  ),
  # Tables
  fluidRow(
    column(4, tableOutput("diag")),
    column(4, tableOutput("body_part")),
    column(4, tableOutput("location"))
  ),
  # Figure
  fluidRow(
    column(12, plotOutput("age_sex"))
  )
)

server <- function(input, output, session) {
  selected <- reactive(injuries %>% filter(prod_code == input$code))

  output$diag <- renderTable(
    selected() %>% count(diag, wt = weight, sort = TRUE)
  )
  output$body_part <- renderTable(
    selected() %>% count(body_part, wt = weight, sort = TRUE)
  )
  output$location <- renderTable(
    selected() %>% count(location, wt = weight, sort = TRUE)
  )

  summary <- reactive({
    selected() %>%
      count(age, sex, wt = weight) %>%
      left_join(population, by = c("age", "sex")) %>%
      mutate(rate = n / population * 1e4)
  })

  output$age_sex <- renderPlot({
    summary() %>%
      ggplot(aes(age, n, colour = sex)) +
      geom_line() +
      labs(y = "Estimated number of injuries")
  }, res = 96)
}

shinyApp(ui, server)