$(document).ready ->
  $('#slider').slider({ step : 1, min: 6, max: 12 })
  $('#slider').bind("slide", (event, ui) -> $("#grade_badge").html(ui.value))
  $('.tag_button').live('click', -> toggleButtonPressed(this))
  $('.tag_button_pressed').live('click', -> toggleButtonPressed(this))
    
  toggleButtonPressed = (element) ->
    $(element).toggleClass('tag_button_pressed')
    $(element).toggleClass('tag_button')