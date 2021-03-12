library(shiny)
library(vroom)
library(tidyverse)
library(here)

# == Data == #
injuries <- vroom::vroom(here("neiss", "injuries.tsv.gz"))
products <- vroom::vroom(here("neiss", "products.tsv"))
population <- vroom::vroom(here("neiss", "population.tsv"))

prod_codes <- setNames(products$prod_code, products$title)

# == Functions == #

count_top <- function(df, var, n = 5) {
  df %>%
    mutate({{ var }} := fct_lump(fct_infreq({{ var }}), n = n)) %>%
    group_by({{ var }}) %>%
    summarise(n = as.integer(sum(weight)))
}

summarise_injuries <- function(df) {
  df %>%
    count(age, sex, wt = weight) %>%
    left_join(population, by = c("age", "sex")) %>%
    mutate(rate = n / population * 1e4)
}

summary_plot <- function(df, y = c("rate", "count")) {
  y <- match.arg(y)
  if (y == "count") {
    df %>%
      ggplot(aes(age, n, colour = sex)) +
      geom_line() +
      labs(y = "Estimated number of injuries")
  } else {
    df %>%
      ggplot(aes(age, rate, colour = sex)) +
      geom_line(na.rm = TRUE) +
      labs(y = "Injuries per 10,000 people")
  }
}

# == APP == #

ui <- fluidPage(
  # Inputs
  fluidRow(
    column(
      8,
      selectInput("code", "Product", choices = prod_codes, width = "100%")
    ),
    column(2, selectInput("y", "Y axis", c("rate", "count")))
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
    count_top(selected(), diag),
    width = "100%"
  )
  output$body_part <- renderTable(
    count_top(selected(), body_part),
    width = "100%"
  )
  output$location <- renderTable(
    count_top(selected(), location),
    width = "100%"
  )

  summary <- reactive({
    summarise_injuries(selected())
  })

  output$age_sex <- renderPlot(
    {
      summary_plot(summary(), y = input$y)
    },
    res = 96
  )
}

shinyApp(ui, server)
