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
        - dplyr, ggplot2, lubridate, reactable, shiny, shinythemes, vroom,

`rstudio` is installed outside conda, so it can be used by all conda envs

## Deployment & Testing

Deployment isn't covered in Mastering Shiny. See my notes in DEPLOYING-SHINY.md

I don't think functional testing is covered in Mastering Shiny and, I'd like to
try using Rselenium (and related tools) for testing shiny apps.

## Projects

Some simple apps I'd like to build

- Wordcloud: Stackoverflow tags for a user
- Homebrew statistics: Is my brew ready to bottle (fed by googlesheets data)
- R package analysis: app for `code_as_data` project

## Things I learned

These might be:

- [Sh]iny
- [Web]
- [R]
- [RS]tudio
- or [CS] Computing tips / concepts

### Chapter 1 {Your first Shiny app}

- [Sh] to make a new app, add app.R, with function 'server' and 'ui' then call
  shiny::shinyApp(ui, server)
- [Sh] server <- function(input, output, session) {}

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
- [CS] reactive programming: kind of a dynamically updated data pipeline
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

### Chapter 2 {Basic UI}

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
- [Sh] `shinythemes::themeSelector()` in the `ui` !!!
- [Sh] `shinythemes::shinytheme(theme_name)` to set a non-default theme
- [Sh] `{fresh}` for building new themes

### Chapter 3 {Basic Reactivity}

- [Sh] `eventReactive(dependsOnThis, computesThis)` = reactive expression; this
  can be used to remove a direct dependency upon something that is required for
  a computation; eg, you can depend upon an actionButton being pressed, but use
  various other input values within the computation (without specifying a
  dependency on the latter)
    - dependsOnThis can be a list of things that the reactive expression
      depends upon
- [CS] Reactive programming: specify graph of dependencies, the computer
  decides when / if any computation is required
    - Commands (Imperative) vs Recipes (Declarative)
    - Laziness
- [Sh] `server` function invoked each time a new session starts (-->
  independence between different user's sessions)
- [Sh] `input` argument to `server`:
    - list-like object
    - read-only (ensures the value matches the browser-viewable values; but
      browser values can be updated with updateNumericInput())
    - only readable in a reactive context
- [Sh] `output` argument to `server`:
    - list-like object
    - produce/update it's elements with a render function
      (`output$value <- renderText("blah")`)
    - write-only
- [Sh] {reactlog} can be used to draw reactive-graphs
- [Sh] 'reactive expression's
    - can use 'input's
    - can be used by render functions (ie to _make_ 'output's)
    - wrap some code in `reactive(...)` to reduce duplication.
- [Sh] execution-order is not determined by code-order but by reactive-graph
- [Sh] terminology
    - producers = reactive inputs and expressions
    - consumers = reactive expressions and outputs
- [CS] to insert unicode (eg, mu) Ctrl-Shift-U 03BC (find the relevant code
  here: https://www.compart.com/en/unicode/U+03BC) or copy the relevant symbol
  from here: https://unicode-table.com/en/03C3/
- [Sh] strive to ensure as little gets recomputed as possible when coding up the
  server function
- [Sh] `reactiveTimer` = reactive expression that also depends on current time.
  Use it within a reactive expression for something you want to compute.
- [Sh] `actionButton` can be used to ensure a computation is ran whenever the
  button is pressed.
- [Sh] observers are used to handle side-effects, where the side-effect depends
  on reactive producers (eg, saving computed values to a file)
    - do not assign observer 'values' to a variable
    - cannot be referred to by other reactive consumers

### Chapter 4 {Case study: ER injuries}

- [R] in a function f(df, var); you can use mutate(df, {{var}} := g({{var}}))
  to assign to, and evaluate the var column of df
- [R] `fct_lump` is being deprecated, it chooses from `fct_lump_min`,
  `fct_lump_n` ... based on the input
- [R] `fct_infreq` changes the factor levels so that the most frequent class
  is the first level
- [R] `A = fct_infreq(fct_lump(f, n = n))` vs `B = fct_lump(fct_infreq(f), n = n)`
    - `fct_lump` replaces all low frequency levels with 'Other'
    - Suppose the number of entries that are combined into 'Other' is less than
      the number of entries in any of the top-n factor levels, then there is no
      difference between A and B
    - Let 'LEV' be one of the top-n levels
    - If, the number of elements that are classed as 'Other' is larger than
      the number of elements that are classed to 'LEV', then the 'Other' factor
      level will come before 'LEV' in the level-reordering performed by
      `fct_infreq` (so Other will come earlier than 'LEV' in a frequency table)

## Chapter 5 {Workflow}

- [RS] type 'shinyapp' then press Shift-Tab: this adds a shiny template to a
  script
- [RS] run app as a background job, it will relaunch on every save
    - note rstudio now has an option for this in the "Run App" drop down)
    - harder to debug a background process
- [Sh] `selectInput` returns a character, even if you provide a vector of
  numeric values to choose from
- [RS] add breakpoints by clicking to the left of a line number
- [R] `a[a$b == "c", ]` keeps rows where `a$b` is `NA`
- [Sh] `updateSliderInput` to update an input value from the server function

## Chapter 6 {Layout, themes, HTML}

(Chapter 6 was added while we were working through the book club; some of the
notes below were originally connected with the Basic UI chapter)

- [Resources]
  - [Awesome Shiny Extensions](https://github.com/nanxstats/awesome-shiny-extensions)
  - [Shiny Application Layout Guide](https://shiny.rstudio.com/articles/layout-guide.html)
  - [Outstanding User Interfaces ...](https://unleash-shiny.rinterface.com)
    - Especially Chapters 1, 5, 6, 7
  - [Bootstrap](https://getbootstrap.com/)
  - [Sass](https://sass-lang.com/)
  - [MDN Intro to HTML](https://developer.mozilla.org/en-US/docs/Learn/HTML/Introduction_to_HTML)
  - [MDN CSS First Steps](https://developer.mozilla.org/en-US/docs/Learn/CSS/First_steps)
  - [MDN Website parsing figure](https://developer.mozilla.org/en-US/docs/Learn/CSS/First_steps/How_CSS_works/rendering.svg)

- [Sh] Page functions:
  - `fluidPage`, `fixedPage`, `fillPage`
- [Sh] Layout functions:
  - `sidebarLayout`
- [Sh] Layout functions:
    - `*Page` [fluidPage, navbarPage]
    - `*Layout` [sidebarLayout]
    - `*Panel` [titlePanel, sidebarPanel, mainPanel, tabsetPanel, tabPanel]
- [Sh] a basic fluidPage() pulls in JS for jquery, and both JS/CSS for shiny,
  bootstrap and bootstrap-accessibility
- [Sh] sidebarLayout requires that sidebarPanel and mainPanel are defined
- [Sh] combining `fluidRow()` with `column()` provides more flexibility than
  `sidebarLayout()`; column widths must add to 12 in a fluidRow.
- [Sh] `tabPanel` / `tabsetPanel` -based are single page apps with illusion of
being multipage apps
- [Sh] use `id` in `tabsetPanel` if you need to know which `tabPanel` is
currently selected
- [Sh] use `navlistPanel` with `tabPanel` to make vertical-selectors
- [RS] open Rstudio devtools using 'inspect element' on an app
- [Sh] `navbarPage` visually similar to tabsetPanel (horizontal selection) but
each tab can have nested elements (using `navbarMenu` and `tabPanel`)
- [CS] bootstrap

    Quickly design and customize responsive mobile-first sites with Bootstrap,
    the world’s most popular front-end open source toolkit, featuring Sass
    variables and mixins, responsive grid system, extensive prebuilt components,
    and powerful JavaScript plugins. (from bootstrap homepage)

- [CS] Sorry, what was that:
  - Sass variables
    - Sass is a CSS preprocessor (makes it less tedious / complicated to write
    CSS)
    - [{sass}](https://github.com/rstudio/sass) R package
    - You can't use variables in CSS, but you can in Sass (example from {sass})
      `$size: 50%; foo { margin: $size * 0.33; }`
    - See [Outstanding User Interfaces ...](https://unleash-shiny.rinterface.com/beautify-sass.html)
  - Mixins
    - Similar to functions
  - Responsive grid
    - ? bootstrap docs are peppered with "responsive" but I'm not sure what they
    mean in context
      - Perhaps see: https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Responsive_Design
  - Prebuilt components
    - eg, you don't have to write your own button class
  - JS plugins

- [Sh] (as of shiny 1.6) still uses bootstrap 3
- [Sh] `bslib::bs_theme()` to customise visuals
  - to use bootstrap 4: `[fluid|navbar|bootstrap]Page(..., theme = bslib::bs_theme("4"))`
  - to use premade style: `fluidPage(..., theme = bslib::bs_theme(bootswatch = "some_theme"))`
- [Sh] `class` argument to customise some layouts
- [Sh] `{bslib}` has functions to make custom bootstrap classes
- [CS] Alternative CSS frameworks:
  - {shiny.semantic} = formantic
  - {shinyMobile} = framework 7
  - {shinymaterial} = Material design
- [Sh] {shinydashboard} for making dashboards
- [Sh] `bslib::bs_theme_preview(theme)` for interactive app for choosing a theme
- [Sh] `thematic::theme_shiny()` in the server function, to pull plotting theme
from the app's theme
- [R] `html::htmlDependency` to add CSS or JS dependencies
- [R] `htmltools::HTML()` to add raw html to a UI
- [Sh] `htmlTemplate("www/index.html")` to use a UI defined by an .html file
- [R] `htmltools::tags` to append specific html elements to UI

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
