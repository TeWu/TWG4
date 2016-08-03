$(document).on 'turbolinks:load', ->
  $(".resources-list tbody tr").click(->
    window.location = @getAttribute("data-resource-url")
  ).find("a").css('pointer-events', 'none')
