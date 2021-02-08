# Notes for working on "Mastering Shiny"

## Env

Use conda environment 'shiny'
- see conda/environment.yml and conda/requirements.txt
- this was cloned from env 'rstudio-prereqs' (uses R=4.0.3)
- then "r-shiny" (1.6.0) was installed
- all packages mentioned in the preface of "Mastering Shiny" were added as
  needed
    - (used the most recent version of each package that was on conda-forge,
      rather than the book's chosen versions)
    - note 'thematic' is not available on conda-forge
    - added a 'r-thematic' build for R-4.0.3 to my anaconda account
    - many conflicts found (eg, r-xml2 and r-tidyverse conflict when installing
      en masse, hence installed as needed)
    - installed individual tidyverse packages (rather than tidyverse)
    - first part of the book only needs:
        - dplyr, ggplot2, lubridate, reactable, shiny, vroom,

`rstudio` is installed outside conda, so it can be used by all conda envs

## Deployment & Testing

Deployment isn't covered in Mastering Shiny. See my notes in DEPLOYING-SHINY.md

I don't think functional testing is covered in Mastering Shiny and, I'd like to
try using Rselenium (and related tools) for testing shiny apps.

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

### Ch2 {Your first Shiny app}

- [Sh] to make a new app, add app.R, with function 'server' and 'ui' then call
  shiny::shinyApp(ui, server)
- [Sh] server <- function(input, output, server) {}

- Local deployment (see DEPLOYING-SHINY.md for more details):
    - [RS] to run an app "[Ctrl][Shift][Enter]" or click the run-app button
    - [R] to run an app: run  `shiny::runApp("app_path")`
    - [R] to launch in the browser, set options("browser" =
      "chromium-browser"), then call shiny::runApp(path, launch.browser = TRUE)
    - [R] add options() calls to ./.Rprofile and they will automatically be
      included at startup (if you start R from the correct working-directory)
    - [Sh] options("shiny.port" = 1234) to define a fixed port for shiny to
      listen on
    - [Sh] updates to "app.R" will autopopulate in the browser if you reload
      the browser's page (you don't need to restart the local server)

- [Sh] uses reactive programming
- [Comp] reactive programming: kind of a dynamically updated data pipeline
- [Sh] layout functions: eg, `fluidPage(..., title = NULL, etc)` takes any
  number of inputs/widgets as arguments
- [Sh] input functions: See Ch3 for the choices of input-function, and the html
  elements that they correspond to
- [Sh] output functions: See Ch3 for the choices of output-function.
- [Sh] layout, input, output functions evaluate to html
- [Sh] in server function, add recipes for how to update the output based on
  (changes in) the input; the dependencies are encoded implicitly
- [Sh] don't use functions/variables to deduplicate code, use `reactive({})`
  wrapper (this returns a reactive expression)
- [Sh] use a reactive expression by calling it like a function

### Ch3 {Basic UI}

- [Sh] Inputs for
    - text: `textInput`, `passwordInput`, `textAreaInput`
    - numbers: `numericInput`, `sliderInput` (can use the latter to
    define ranges)
    - dates: `dateInput`, `dateRangeInput`
    - choices: `selectInput`, `radioButtons`, `checkboxInput`,
    `checkboxGroupInput`
    - files: `fileInput`
    - actions: `actionButton`, `actionLink`

- [Sh] `validate` function for checking text-input validity
- [Sh] Can distinguish the 'choiceNames' (what is presented to the user) from
  the 'choiceValues' (what is sent back to R) when using radioButtons
- [Sh] match input-actions with `observeEvent` / `eventReactive` in the server
  function
- [Sh] the class="..." argument in `actionButton()` is passed down to the html,
  so you can use bootstrap class names for formatting.
- [Sh] sliderInput can take Date or POSIXt objects for min/max/value
- [Sh] sliderInput with animate=TRUE will iterate through all available choices
- [Sh] step argument in numericInput constrains the values that clicking can
  reach, but not the values the user can type in.

- [Sh] Outputs for
    - text:
        - `textOutput` (flowing text; pair with `renderText`),
        - `verbatimTextOutput` (as if output by the R console; pair with
          renderPrint)
    - tables:
        - `tableOutput` (static tables; pair with `renderTable`)
        - `dataTableOutput` (dynamic tables; pair with `renderDataTable`)
        - `reactable::reactableOutput` (dynamic; pair with
          `reactable::renderReactable(reactable(some_df))`)
    - plots:
        - `plotOutput` (paired with `renderPlot`)
    - downloads:
        - `downloadButton`
        - `downloadLink`
- [Sh] `<type>Output()` functions in the UI should be paired with a
  `render<type>()` function in the server function
- [R] package `reactable` for neat dynamic tables
- [Sh] plots that are output to the browser can be used as inputs (eg,
  following user clicks)
- [Sh] options = list(...) is passed through to JS library DataTables when
  calling renderDataTable()

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
