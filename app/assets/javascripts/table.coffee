$(document).on 'click', '.resources-list tbody tr', ->
  Turbolinks.visit(@getAttribute('data-resource-url'))

$(document).on 'click', '.resources-list tbody tr a', (e) ->
  e.preventDefault()
