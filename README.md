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
- Create a plot / style colourscheme from a photo (eg, using [imgpalr](https://cran.r-project.org/web/packages/imgpalr/index.html)
- dupree app

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
- [Sh] `bslib::bs_theme_preview(theme)` for interactive app for choosing a
  theme
- [Sh] `thematic::theme_shiny()` in the server function, to pull plotting theme
from the app's theme
- [R] `htmltools::htmlDependenc[y|ies]` to add CSS or JS dependencies
- [R] `htmltools::HTML()` to add raw html to a UI
- [Sh] `htmltools::htmlTemplate("www/index.html")` to use a UI defined by an
  .html file
- [R] `htmltools::tags` to append specific html elements to UI

## Chapter 7 {Graphics}

TODO

## Chapter 8 {User Feedback}

- Resources
  - {shinyFeedback}
  - {waiter} - progress bars etc in shiny
  - {progress} - progress bars in tidyverse
  - {shinyvalidate}
  - {shinycssloaders} - put a spinner on any output that has been
  - [https://www.nngroup.com/articles/ok-cancel-or-cancel-ok/] notes on buttons

- [Sh] `shinyFeedback`
  - `useShinyFeedback()` in the ui
  - `feedback()`, `feedbackWarning()`, `feedbackDanger()` or `feedbackSuccess()`
  in the server
  - on error/warning: error message is displayed but the output is still updated

- [Sh] `shiny::req`:
  - Prevents invalid input being used within app code
  - Useful to pause shiny from running before any user-input has been provided
  - signals a condition that stops all downstream reactive consumers
  - `cancelOutput = TRUE` to leave all outputs displaying their last good value

- [Sh] `shiny::validate`
  - to show error messages next to the output panel
  - makes sense when multiple inputs need validating

- [Sh] `shiny::showNotification`:
  - puts a note in the bottom-right of the page
  - transient (disappears after fixed time; duration=5 (secs) is default),
  - on-completion (disappears when the compute ends; set duration=NULL and
  removeNotification() on.exit),
  - progressive (several updates to a single message; call with id= the ID of
  the initial call to showNotification)

- [Sh] `shiny::withProgress`
  - Use `incProgress(increment_size)` to push progress-bar from 0 to 1

- [Sh] `{waiter}`
  - 'Waitress' is a progress bar
  - `waiter::use_waitress` in the ui
  - `waitress <- waiter::Waitress$new(max = 100)` / `waitress$inc(1)` / `waitress$close()`
    in the server (wrap waitress$close in on.exit)
  - `theme` argument allows progress bar to hit whole page, or cover an input /
  output widget (`Waitress$new(selector="#selector_id", theme="overlay")`)
  - 'Waiter' is a spinner just to indicate that something is happening
  - Note: Waiter uses 'id' and Waitress uses 'selector' to determine which
  element a progress-indicator should overlay

- Use an action-button and `eventReactive` to control the start of a
long-running reactive

- [Sh] `shiny::modalDialog`
  - dialog box to confirm an action should be performed
  - In the server: `showModal(some_modal_expression)`
  - When `showModal` has been called, any UI elements that
  `some_modal_expresion` has added to the UI are now accessible via 'input' /
  'output' (this is dynamic UI)

## Chapter 14 {The reactive graph}

- [Sh]
  - No prior knowledge of the relationships between reactives
  - Starting state for consumers is 'invalidated'
  - alg:
    - Shiny picks an invalidated output and executes it
    - Any (invalidated) reactive-expressions reqd by the output start to compute their value
    - An arrow is drawn between the expression and the output
    - Any inputs that are required are read immediately (and arrow is drawn from input to consumer)
    - When all producers that feed into the output are computed, the output is computed
  - on changing an input:
    - the input is set to invalidated state
    - any consumers that depend on that input are set to invalidated state
    - each invalidated consumer erases all of the arrows coming into and out of it
  - the reactive graph stays accurate by erasing all stale arrows

- dynamism
  - reactive graph can change while app runs
  - the reactive graph at any particular time depends on the route that was followed through the
    source code

- [Sh] `{reactlog}`
  - provides view into shiny's reactive graph
  - To use:
    - `reactlog::reactlog_enable()`
    - then start app
    - then `Ctrl + F3` to launch the reactlog application
  - plot outputs have an implicit dependency on plot dimensions (that you don't need to code)
  - use 'label' on any `reactive` or `observe` components that you want to highlight in the
    reactlog graph

## Chapter 15 (Reactive Building Blocks)

- Important properties of reactives:
  - lazy
  - cached

- Building blocks:
  - Reactive values
  - Reactive expressions
  - Observers (outputs are special types of observer)

- New tools:
  - Isolation
  - Timed invalidation

- `reactiveConsole(TRUE)`
  - enables reactivity in the console

- Reactive values:
  - Two types
  - Both have reference semantics
  - `input` values are a read-only form of reactive value
  - `reactiveVal` 
    - holds a single value
    - `x <- reactiveVal(10); x(); x(15)` -- initialise, get, set
  - `reactiveValues`
    - holds a list of values
    - `rs <- reactiveValues(x = 10); rs$x; rs$x <- 15` -- initialise, get set

- Some functions only work inside of other functions (on.exit)
  - `on.exit()` runs code after a function has completed

- What does `shiny::req()` do again?
  - It sends a signal condition that pauses all downstream reactives and outputs
  - YOu can use it to check logic: `req(! input$error)`

- Reactive expressions
  - error handling
    - errors are cached just as for values
    - errors propagate through reactive graph as for regular values
    - when error reaches an output or observer:
      - outputs: display the error in the app
      - observers: crash the session => therefore use try / tryCatch
  - why does `on.exit()` work inside them
    - `reactive(x())` as a shortcut for `function(){x()}` but with laziness
    and caching for free
    - hence, why on.exit() can be used in reactive-expressions (though it can't
    be used in a general R expression)

- Observers and Outputs
  - Terminal nodes in the rx graph
  - Eager and forgetful (unlike rx expressions: lazy and cached)
  - Eagerness is transmitted to any producer used by the node
  - Intended use: for side effects (any value is ignored)
  - Both use `observe()` under the hood
  - Outputs as special-types of Observers:
    - defined when assigned to output `outptu$res <- ...`
    - also know when they aren't visible (so lazy if not visible)
  - Only ever use observers / outputs at top-level of server function

- `observe()`
  - sets up block of code that runs when anything it uses is updated
  - low-level tool: try not to use it (recommend using observeEvent())
  - observe doesn't 'do' something but 'create's something

Note the difference:
```
x <- reactiveVal(1)        ||| a <- reactiveVale(1)
y <- observe({             ||| b <- observe(
  x()                      |||   observe(print(a()))
  observe(print(x()))      ||| )
})                         |||
```

Maybe a better example:
```
f <- reactiveVal(1)
g <- reactiveVal(2)
h <- observe({
  f()
  observe(print(g()))
})
# each time you change f, a new observer of g is added to the graph
```

- `isolate()`
  - this powers `observeEvent` and `eventReactive`
  - allows you to access a value, without taking a dependency on it
  - `observeEvent(x, y) === observe({x; isolate(y)})`
  - `eventReactive(x, y) === reactive({x; isolate(y)})`
  - Additional args in observeEvent / eventReactive:
    - ignoreNULL: by default observeEvent(x, y) / eventReactive(x, y) ignores
    event where x is NULL
    - ignoreInit = TRUE: do not run immediately at creation
    - once = TRUE: run y only once in observeEvent(x, y)

- `invalidateLater`
  - invalidation of the rx graph when nothing has changed
  - underlies the `reactiveTimer()`
  - to invalidate a reactive-consumer: `invalidateLater(ms)`
  - polling: data that changes outside of R
    - Make sure you check that the file has updated, or you'll do lots of wasted
    computation
    - eg, use `reactivePoll(ms, session, checkFunc, valueFunc)` (whenever
    checkFunc changes, run valueFunc and update the rx graph)
    - or, use `reactiveFileReader(ms, session, filepath, valueFunc)`
    - Q: how to build a reactivePoll for a database
  - invalidateLater(ms) times from when it is invoked (there's no implicit on.exit)
  - can use `on.exit(invalidateLater(ms))` to invalidate after reactive has
  finished
  - cannot guarantee that invalidation will happen precisely when requested as R
  might be doing other things

```
# Ex 15.5.4-1
server <- function(input, output, session) {
  x <- reactive({
    invalidateLater(500)
    rnorm(10)
  })
}

# The reactive never gets executed because it is lazy and there is no output or observer
# in the reactive graph that takes `x` as an input
# Since `x` never gets put into a validated state, it never gets to invalidate itself

# We can implicitly force its execution:
ui <- fluidPage(
  actionButton("capture", "capture")
)
server <- function(input, output, session) {

  x <- reactive({
    on.exit(message("Leaving x", r))
    message("Entering x")
    invalidateLater(500)
    r <- rnorm(1)
    r
  })

  observeEvent(input$capture, {
    x()
  })
}
shinyApp(ui, server)
```

Things to emphasise:

- Base R things that need to understand
  - Reference semantics
  - Function calls that must be inside a function
  - Error handling in R
- Shiny examples from earlier in the book
  - req()
  - reactiveTimer()
    - can we recreate this using invalidateLater
- Differences between observeEvent and eventReactive
  - how to illustrate eagerness vs laziness?
  - could compute something in an eventReactive that isn't used by an output

## Chapter 21 (Testing)

- Learning outcomes:
  - Purpose of testing
    - Ensure new features don't break existing code
    - Ensure bugs only arise once
  - Different levels of test
  - Balance: speed, fragility, coverage

Discussions:
  - Don't test the framework!
  - Don't test too early! Or do!

- Using testthat

- App structure:
  - Requires package structure
  - `./tests/testthat.R`
  - `./tests/testthat/test-<file>.R`
  - `./tests/testthat/_snaps/<file>.md`

- Four levels of testing for shiny apps:
  - non-reactive functions
  - input-value-driven updates to reactives & outputs
  - browser-driven tests
  - visual output of the app

- So what does that separate:
  - reactive from stateless behaviour
  - UI-dependent and independent behaviour
  - values from visuals

- Recommended workflow:
  - create test files with `usethis::use_test()`
  - Write code & tests
  - Run `devtools::test_file()` while getting something to work
  - Capture new bugs in tests
  - Run `devtools::test_coverage_file()` to show you've covered all your function
  - Run `devtools::test()` to test the whole package

- New testthat things:
  - `expect_named(x, c("a", "b", "c"), ignore.order = TRUE, ignore.case = FALSE)`
  - `expect_setequal(x, y)`
  - `expect_mapequal(x, y)`
  - `expect_snapshot()`
    - Example: output for a UI function
    - Expected value is stored in a file
    - Update the expected value using `testthat::snapshot_accept()`

- New RStudio things:
  - Add keyboard shortcuts:
    - This did not work
  - Shortcuts I hoped to add:
    - [Ctrl + T] : `devtools::test_file()`
    - [Ctrl + Shift + R] : `devtools::test_coverage()`
    - [Ctrl + R] : `devtools::test_coverage_file()`

- ? Good example to demonstrate all this:
  - Re-engineer the Case study from Chapter 4
  - add modules & pure functions

- Things beyond this chapter:
  - Tinytest recommendations for testing
  - Reactor for testing the links between reactives
  - Testing in CI

TODO: Testing reactivity

## Chapter 23 (Performance)

- Tools:
  - `shinyloadtest` for benchmarking
  - `profvis` for profiling where code is hanging

- Resources:
  - "Shiny in production: principles, best practices, and tools." Joe Cheng talk
  - [https://rstudio.github.io/promises](Async programming in single-core R)

- Benchmarking
  - <!-- TODO: Did not read -->

- Profiling
  - `profvis`:
    - interactive visualisation of profiling data from `utils::Rprof()`
    - wrap your code: `profvis::profvis(some_func())`
    - eg, `profvis::profvis(runApp())`
  - flame-graph:
    - rectangles with widths ~ time taken; height=call-stack at that point

<!-- TODO: continue with "Improve performance" -->
