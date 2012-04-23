$(document).ready ->
  $('#slider').slider({ step : 1, min: 6, max: 12 })
  $('.tag_button').live('click', -> $(this).attr('class', 'tag_button_pressed'))
  $('.tag_button_pressed').live('click', -> $(this).attr('class', 'tag_button'))