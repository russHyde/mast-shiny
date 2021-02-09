# Deploying Shiny

"Mastering Shiny" doesn't claim to cover deployment

But, I'd like to work out how to deploy to
- localhost
- shinyapps.io
- digital ocean
- heroku
- aws

This document contains my notes on deploying shiny apps.

`@_tanho` recommended these resources for learning how to deploy shiny apps (on
AWS or DigitalOcean)

- [https://www.charlesbordet.com/en/guide-shiny-aws/]
- [https://deanattali.com/2015/05/09/setup-rstudio-shiny-server-digital-ocean/]

## Local deployment

When developing a Shiny app, you can deploy it on your local computer using
`shiny::runApp("my-app/path")`. If R is running in the same working directory
as the `app.R` file for that app, you can use `shiny::runApp()`.

When you start an app this way, R will tell you that it is

    `Listening on http://127.0.0.1:<some-port>`,

where `<some-port>` is a four-digit number (eg, 127.0.0.1:6600).

Here, 127.0.0.1 is the localhost on your computer, and in the example 6600 is a
port-number on your computer. And, you can then open "http://127.0.0.1:6600" in
your browser to view your app.

### Options

Unless you've monkeyed with your options, each time you run
`shiny::runApp(...)` a different port-number will be used.

But, it's pretty helpful to be able to run your app using the same port each
time. To specify that shiny should use the specific port "1234" run the
following:

`options(shiny.port = 1234)`

and your app will be viewable at `http://127.0.0.1:1234` each time you use
`shiny::runApp()`

You may also have to tell shiny which browser your app should be viewed on. For
example, I usually set

`options(browser = "chromium-browser")`

so that my apps can be viewed in Chrome.

So that you don't have to type these options in each time you launch your app,
you can add them to a file `.Rprofile` in your home- or working-directory:

```
# My ./.Rprofile looks like this
options(shiny.port = 6600)
options(browser = "chromium-browser")
```

(However) if your app may be worked on by another developer, these options
should probably be set in the home directory of your computer (so your choice
of browser doesn't affect your colleagues choice of browser)

### Rstudio

You can quickly launch an app from Rstudio, by using "[Ctrl][Shift][Enter]" or
clicking the run-app button.

### Command line

To launch your app from the command line you can use:

```
Rscript \
  -e "args <- commandArgs(trailingOnly = TRUE); shiny::runApp(args)" \
  path/to/my/app.R
```

.. and then view it in your browser.


## Deployment to the web

### shinyapps.io

This is probably the simplest way to get an app published on the web.
First, sign up for an account at shinyapps.io.
On logging into the site, you will be able to see some instructions for how to
configure your local R to deploy apps.
Install `rsconnect` (`install.packages("rsconnect")`) if required.
Then copy in the code that looks like the following into R (make sure you can
see the secret key):

```
rsconnect::setAccountInfo(
  name="user-name",
  token="ranDomselectionOfCharacters",
  secret="even-more-secretCollectionOfcharacters"
)
```

If that isn't visible on the first post-login page, you can find the token &
secret by following `Dashboard->Account->Tokens` in shinyapps.io.

Now, if you've written a shiny app, and it's working locally, you should be
able to deploy that app up to shinyapps.io using the following code:

```
library(rsconnect)
deployApp(appDir = "path/to/your/app")
```

Now if you look in the Applications tab in your shinyapps.io account, there'll
be loads of info on your newly deployed app; and if you follow your nose you'll
find a URL for it; this will probably look like
`https://<my-user-prefix>.shinyapps.io/<my-app-name>`

There are a lot of arguments for `deployApp`, well worth investigating.

[TO BE CONTINUED]
