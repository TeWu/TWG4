window.TWG4.album ||= {}

window.TWG4.album.adjust_album_content_width = ->
  content = $('#album-content')
  if content.size() == 1
    thumbnail_width = $('.thumbnail-container').outerHeight(true)
    album_content_outline_with = content.outerWidth(true) - content.width()
    allocated_width = $('body').width() - album_content_outline_with
    content.width(allocated_width - (allocated_width % thumbnail_width))

$(document).on 'turbolinks:load', TWG4.album.adjust_album_content_width
$(window).on 'resize', -> $.doTimeout 'adjust_album_content_width', 10, TWG4.album.adjust_album_content_width


(->
  window.TWG4.album.modes = {}
  modes = TWG4.album.modes

  class Mode
    elemsSelector: ''
    elems: -> $(@elemsSelector)
    on_set: -> @elems().show 400
    on_unset: -> @elems().hide 400
    on_page_load: -> @elems().show()

  modes.normal = $.extend new Mode(),
    elemsSelector: '#normal-mode-link'
    on_set: Mode::on_unset
    on_unset: Mode::on_set
    on_page_load: -> @elems().hide()
  modes.remove_photo = $.extend new Mode(), {elemsSelector: '.remove-photo-btn'}
  modes.destroy_photo = $.extend new Mode(), {elemsSelector: '.destroy-photo-btn'}


  window.TWG4.album.current_mode = modes.normal

  window.TWG4.album.set_mode = (mode_name) ->
    current_mode = TWG4.album.current_mode
    new_mode = modes[mode_name]
    current_mode.on_unset()
    if modes.normal in [current_mode, new_mode]
      window.TWG4.album.current_mode = new_mode
      new_mode.on_set()
    else
      current_mode.elems().promise().done ->
        window.TWG4.album.current_mode = new_mode
        new_mode.on_set()
#
)()

$(document).on 'turbolinks:load', -> TWG4.album.current_mode.on_page_load()
$(document).on 'click', '#normal-mode-link, #remove-photos-mode-link, #destroy-photos-mode-link', (e) ->
  e.preventDefault()
  mode_name = switch e.target.id
    when 'normal-mode-link' then 'normal'
    when 'remove-photos-mode-link' then 'remove_photo'
    when 'destroy-photos-mode-link' then 'destroy_photo'
  TWG4.album.set_mode(mode_name)
