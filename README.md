# Notes for working on "Mastering Shiny"

## Env

Use conda environment 'shiny'
- see env/environment.yml and env/requirements.txt
- this was cloned from env 'rstudio-prereqs' (uses R=4.0.3)
- then "r-shiny" (1.6.0) was installed
- all packages mentioned in the preface of "Mastering Shiny" were added as
  needed
    - (used the most recent version of each package, rather than the book's
      chosen versions)
    - note 'thematic' is not available on conda-forge
    - added a 'r-thematic' build for R-4.0.3 to my anaconda account
    - many conflicts found (eg, r-xml2 and r-tidyverse conflict when installing
      en masse, hence installed as needed)
    - installed individual tidyverse packages (rather than tidyverse)
    - first part of the book only needs shiny, ggplot2, dplyr, vroom

`rstudio` is installed outside conda, so it can be used by all conda envs

## Deployment

"Mastering Shiny" doesn't claim to cover deployment

But, I'd like to work out how to deploy to
- localhost
- digital ocean
- shinyapps.io
- heroku
- aws

## Projects

Some simple apps I'd like to build

- Homebrew statistics: Is my brew ready to bottle (fed by googlesheets data)
- R package analysis: app for `code_as_data` project

## Things I learned

These might be:

- [Sh]iny
- [Web]
- [R]
- [RS]tudio
- or [Comp]uting tips / concepts

### Ch3

- [Sh] uses reactive programming
- [Comp] reactive programming: kind of a dynamically updated data pipeline
- [Sh] to make a new app, add app.R, with function 'server' and 'ui' then call
  shiny::shinyApp(ui, server)
- [RS] to run an app "[Ctrl][Shift][Enter]" or click the run-app button
- [R] to run an app: run source(app_path) or shiny::runApp(app_path)
- [R] to launch in the browser, set options("browser" = "chromium-browser"),
  then call shiny::runApp(path, launch.browser = TRUE)
- [R] add options() calls to ./.Rprofile and they will automatically be
  included at startup (if you start R from the correct working-directory)
- [Sh] options("shiny.port" = 1234) to define a fixed port for shiny to listen
  on
- [Sh] layout functions: eg, `fluidPage(..., title = NULL, etc)` takes any
  number of inputs/widgets as arguments
- [Sh] input functions: eg, `selectInput` adds a drop-down list
- [Sh] output functions: eg, verbatimTextOutput, tableOutput
- [Sh] layout, input, output functions evaluate to html
- [Sh] server <- function(input, output, server) {}
- [Sh] in server function, add recipes for how to update the output based on
  (changes in) the input; the dependencies are encoded implicitly
- [Sh] updates to "app.R" will autopopulate in the browser if you reload the
  browser's page (you don't need to restart the local server)
- [Sh] don't use functions/variables to deduplicate code, use `reactive({})`
  wrapper (this returns a reactive expression)
- [Sh] use a reactive expression by calling it like a function

## Errors
- [RS] - problem with running runApp within rstudio (looks like rcpp is trying
  to use the system libstdc++, rather than the conda-environment's version and
  the system libstdc++ can't be updated for some reason):
```
Error in dyn.load(file,
  DLLpath = DLLpath, ...) :
  unable to load shared object
'/home/russ/tools/miniconda3/envs/shiny/lib/R/library/Rcpp/libs/Rcpp.so':
  /usr/lib/x86_64-linux-gnu/libstdc++.so.6: version `GLIBCXX_3.4.26' not found
(required by
/home/russ/tools/miniconda3/envs/shiny/lib/R/library/Rcpp/libs/Rcpp.so)
```

- [Sh] - Ch3/Ex1 - numericInput should have a default value; ie, the provided
  code should be `numericInput("age", "How old are you?", 0)`