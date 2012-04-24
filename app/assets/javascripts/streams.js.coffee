$(document).ready ->
  # # # streams/index # # #
  $('#slider').slider({ step : 1, min: 6, max: 12 })
  
  # # # streams/new # # #
  stages = [
      '#video_preview',
      '#title',
      '#description',
      '#when',
      '#price'
  ]
  
  instructions = [
      "Let's start with a video preview!",
      "Okay now what do you want to call it?",
      "Can you tell us a bit about it?",
      "When is a good time for you?",
      "How much do you want to charge students?"
  ]
  
  explanations = [
    "Choose a video that exemplifies the kind of content you'll broadcast.",
    "Pick the name that best describes your show.",
    "A nice, paragraph-long description gives the users better info.",
    "Pick a time when you can be at your computer and you won't have any conflicts.",
    "It's up to you!"
  ]
  
  actions = [
    '#continue',
    '#continue',
    '#continue',
    '#continue',
    '#submit'
  ]
      
  stage = 0
  $('#continue').click ->
    $('#instruction').fadeOut()
    $('#explanation').fadeOut()
    $(actions[stage]).fadeOut()
    $(stages[stage]).fadeOut ->
      stage += 1
      $('#instruction').text(instructions[stage])
      $('#explanation').text(explanations[stage])
      $(stages[stage]).fadeIn()
      $('#instruction').fadeIn()
      $('#explanation').fadeIn()
      $(actions[stage]).fadeIn()
  
  # Hide everything except for the video preview
  $('.field').hide()
  $('#submit').hide()
  $('#video_preview').show()
  
  # Set the initial instruction and explanation
  $('#instruction').text(instructions[stage])
  $('#explanation').text(explanations[stage])
