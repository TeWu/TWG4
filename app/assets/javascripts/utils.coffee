$(document).on 'click', '[go-back]', (e) ->
  e.preventDefault()
  window.history.back()
