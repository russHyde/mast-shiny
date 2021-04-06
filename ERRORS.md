# Errors

- [RS] - problem with running runApp within rstudio (looks like rcpp is trying
  to use the system libstdc++, rather than the conda-environment's version and
  the system libstdc++ can't be updated for some reason). This was solved by
  using renv to define the R environment, and conda to define the base-R
  installation:

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
