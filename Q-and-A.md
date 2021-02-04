# Questions and Answers #

## What html tags / classes result from different shiny UI objects

eg, sliderInput(inputId="abc", label = "ABC", min=0L, max=100L, value=10L)
generates the following html:

<div class="form-group shiny-input-container">
  <label class="control-label" id="abc-label" for="abc">ABC</label>
  <input class="js-range-slider" id="abc" data-skin="shiny" data-min="0"
    data-max="100" data-from="10" data-step="1" data-grid="true"
    data-grid-num="10" data-grid-snap="false" data-prettify-separator=","
    data-prettify-enabled="true" data-keyboard="true" data-data-type="number"/>
</div>

So, using selenium you'd select the slider by id="abc", the same as the inputId
in the call to sliderInput
