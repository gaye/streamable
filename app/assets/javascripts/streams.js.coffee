$(document).ready ->
  ##### streams/index #####
  setTagFieldsInForm = ->
    $('input[name=tags]').val(selectedTags.join())
    
  toggleButtonPressed = (element) ->
    $(element).toggleClass('tag_button_pressed')
    $(element).toggleClass('tag_button')
    
  addTag = (tagName) ->
    selectedTags.push(tagName)
    setTagFieldsInForm()
  
  removeTag = (tagName) ->
    selectedTags.splice(selectedTags.indexOf(tagName), 1)
    setTagFieldsInForm()
      
  getGrade = (value) ->
    value = Math.floor(value + 0.5)
    if value is 5 then '' else value
    
  updateStreams = ->
    $.get('streams/index', { tags : selectedTags }, (data, status, xhr) -> 
      $('#streams').fadeOut('fast', -> 
        $('#streams').html($('#streams', $(data)).html())      
        $('#streams').fadeIn('slow')
      )
    )

  selectedTags = []
  currentGrade = ''
  
  $('#slider').slider({min : 5, max : 12, step : 0.01})
  $('#slider').bind('slide', (event, ui) -> 
    newGrade = getGrade(ui.value)
    if (newGrade isnt currentGrade)
      $('#grade_badge').html(newGrade)
      removeTag(currentGrade)
      if (newGrade isnt '')
        addTag(newGrade)
      currentGrade = newGrade
      updateStreams()
  )
    
  $('.tag_button').live('click', -> 
    toggleButtonPressed(this)
    addTag($(this).html().trim())
    updateStreams()
  )
  
  $('.tag_button_pressed').live('click', -> 
    toggleButtonPressed(this)
    removeTag($(this).html().trim())
    updateStreams()    
  )
  
  ##### streams/new #####
  # TODO(gaye): Move this from parallel arrays to full-fleged objects...
  
  stages = [
      '#video_preview',
      '#title',
      '#description',
      '#tags',
      '#when',
      '#price'
  ]
  
  instructions = [
      'Let\'s start with a video preview!',
      'Great! Now what do you want to call it?',
      'Can you tell us a bit about it?',
      'Help people find your stream'
      'When is a good time for you?',
      'How much do you want to charge students?'
  ]
  
  explanations = [
    'Choose a video that exemplifies the kind of content you\'ll broadcast.',
    'Pick the name that best describes your show.',
    'A nice, paragraph-long description gives the users better info.',
    'Use the slider to pick a grade level and select one or more subject categories.',
    'Pick a time when you can be at your computer and you won\'t have any conflicts.',
    'It\'s up to you!'
  ]
  
  actions = [
    '#continue',
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
  
  ##### streams/show #####
  $('#subscribe').click ->
    $('#new_subscription').submit()
