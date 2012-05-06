$(document).ready ->
  $('#account')
      .mouseenter ->
        $('#account').css('background-color', '#FBE149')
      .mouseleave ->
        $('#account').css('background-color', '#113D52')
  
  $('#sign_out')
      .mouseenter ->
        $('#sign_out').css('background-color', '#FBE149')
      .mouseleave ->
        $('#sign_out').css('background-color', '#113D52')
