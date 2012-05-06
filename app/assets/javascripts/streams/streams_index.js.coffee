$(document).ready ->
  setTagFieldsInForm = ->
    $('input[name=tags]').val(selectedTags.join())
    
  toggleButtonPressed = (element) ->
    $(element).toggleClass('tag_button_pressed')
    $(element).toggleClass('tag_button')
    
  addTag = (tagName) ->
    if (tagName isnt '')
      selectedTags.push(tagName)
      setTagFieldsInForm()
  
  removeTag = (tagName) ->
    if (tagName isnt '')
      selectedTags.splice(selectedTags.indexOf(tagName), 1)
      setTagFieldsInForm()
      
  getGrade = (value) ->
    value = Math.floor(value + 0.5)
    if value is 5 then '' else value
    
  updateStreams = ->
    $.get('streams/index', { tags : selectedTags }, (data, status, xhr) -> 
      height = $('#content').height()
      $('#streams').animate({ opacity : 0 }, ->
        $('#streams').html($('#streams', $(data)).html())
        $('#content').height(height)
        $('#streams').animate({ opacity : 1.0 })
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
