library(shiny)
library(vroom)
library(tidyverse)

library(here)

injuries <- vroom::vroom(here("neiss", "injuries.tsv.gz"))
products <- vroom::vroom(here("neiss", "products.tsv"))
population <- vroom::vroom(here("neiss", "population.tsv"))

# pull out toilet-based injuries
selected <- injuries %>%
  filter(prod_code == 649)

selected %>%
  count(location, wt = weight, sort = TRUE)

selected %>%
  count(body_part, wt = weight, sort = TRUE)

selected %>%
  count(diag, wt = weight, sort = TRUE)

# Estimated count of injuries by age
#
summary <- selected %>%
  count(age, sex, wt = weight)

summary %>%
  ggplot(aes(age, n, colour = sex)) +
  geom_line() +
  labs(y = "Estimated number of injuries")

# Relative frequency of injuries, per 10000 individuals, by age
#
summary <- selected %>%
  count(age, sex, wt = weight) %>%
  left_join(population, by = c("age", "sex")) %>%
  mutate(rate = n / population * 1e4)

summary

summary %>%
  ggplot(aes(age, rate, colour = sex)) +
  geom_line(na.rm = TRUE) +
  labs(y = "Injuries per 10,000 people")

selected %>%
  sample_n(10) %>%
  pull(narrative)
