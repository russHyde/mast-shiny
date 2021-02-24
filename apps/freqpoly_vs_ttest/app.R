library(shiny)
library(ggplot2)

freqpoly <- function(x1, x2, binwidth = 0.1, xlim = c(-3, 3)) {
  df <- data.frame(
    x = c(x1, x2),
    g = c(rep("x1", length(x1)), rep("x2", rep(length(x2))))
  )

  ggplot(df, aes(x, colour = g)) +
    geom_freqpoly(binwidth = binwidth, size = 1) +
    coord_cartesian(xlim = xlim)
}

t_test <- function(x1, x2) {
  test <- t.test(x1, x2)

  # use sprintf to format t.test() results compactly
  sprintf(
    "p value: %0.3f\n[%0.2f, %0.2f]",
    test$p.value, test$conf.int[1], test$conf.int[2]
  )
}

rnorm_selector <- function(id_distribution, width = 4) {
  column(
    width,
    paste("Distribution", id_distribution),
    numericInput(paste0("n", id_distribution), label = "n", value = 1000, min = 1),
    numericInput(paste0("mean", id_distribution), label = "μ", value = 0, step = 0.1),
    numericInput(paste0("sd", id_distribution), label = "σ", value = 0.5, min = 0.1, step = 0.1)
  )
}

ui <- fluidPage(
  fluidRow(
    rnorm_selector(1),
    rnorm_selector(2),
    column(
      4,
      "Frequency polygon",
      numericInput("binwidth", label = "Bin width", value = 0.1, step = 0.1),
      sliderInput("range", label = "range", value = c(-3, 3), min = -5, max = 5)
    )
  ),
  fluidRow(
    column(9, plotOutput("hist")),
    column(3, verbatimTextOutput("ttest"))
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  output$hist <- renderPlot(
    {
      x1 <- rnorm(input$n1, input$mean1, input$sd1)
      x2 <- rnorm(input$n2, input$mean2, input$sd2)

      freqpoly(x1, x2, binwidth = input$binwidth, xlim = input$range)
    },
    res = 96
  )

  output$ttest <- renderText({
    x1 <- rnorm(input$n1, input$mean1, input$sd1)
    x2 <- rnorm(input$n2, input$mean2, input$sd2)

    t_test(x1, x2)
  })
}

# Run the application
shinyApp(ui = ui, server = server)
