window.TWG4.notifications ||= {}

window.TWG4.notifications.adjust_stickiness = ->
  if $(window).scrollTop() > $('body > header').height()
    $('#notifications').addClass('sticky')
  else
    $('#notifications.sticky').removeClass('sticky')

$(document).on 'turbolinks:load', window.TWG4.notifications.adjust_stickiness
$(window).on 'scroll', window.TWG4.notifications.adjust_stickiness

$(document).on 'click', -> $('#notifications').fadeOut(300)
$(document).on 'turbolinks:load', ->
  $('#notifications').addClass('shade') if $('#photo-image-container').size() == 1
