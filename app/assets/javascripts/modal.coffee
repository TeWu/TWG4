$(document).on 'turbolinks:before-cache', ->
  $('.modal').modal('hide')
  $('.modal-backdrop').remove()
