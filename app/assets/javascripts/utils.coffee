$(document).on 'click', '[data-turbolinks-visit]', (e) ->
  e.preventDefault()
  url = $(e.target).data('turbolinks-visit')
  Turbolinks.visit(url)
