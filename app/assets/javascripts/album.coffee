TWG4.album ||= {}

TWG4.album.current_album_id = -> $('nav[data-current-album-id]').data('current-album-id')

TWG4.album.adjust_album_content_width = ->
  content = $('#album-content')
  if content.size() == 1
    thumbnail_width = $('.thumbnail-container').outerHeight(true)
    album_content_outline_with = content.outerWidth(true) - content.width()
    allocated_width = $('body').width() - album_content_outline_with
    content.width(allocated_width - (allocated_width % thumbnail_width))

$(document).on 'turbolinks:load', TWG4.album.adjust_album_content_width
$(window).on 'resize', -> $.doTimeout 'adjust_album_content_width', 10, TWG4.album.adjust_album_content_width


(->
  TWG4.album.modes = {}
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
  modes.add_photo = $.extend new Mode(),
    elemsSelector: '.add-photo-btn'
    on_set: ->
      @setup_album_view()
      @__proto__.on_set.call(@)
    on_unset: ->
      $(document).one 'turbolinks:load', -> @elems().hide()
      Turbolinks.visit "#{location.origin}/albums/#{@target_album.id}?page=last"
    on_page_load: ->
      @setup_album_view()
      @__proto__.on_page_load.call(@)
    setup_album_view: ->
      @disable_add_buttons_for_already_added_photos()
      $('#album-title').after(@album_subtitle_elem())
    album_subtitle_elem: -> '<h2 id="adding-photos">Adding photos to album: <span class="album-name">' + @target_album.name + '</span></h2>'
    disable_add_buttons_for_already_added_photos: ->
      t = @
      $('.add-photo-btn').each ->
        photo_id = parseInt($(@).closest('[data-photo-id]').data('photo-id'))
        t.disable_add_button($(@)) if photo_id in t.target_album.photo_ids
    disable_add_button: (btn) ->
      btn.attr('disabled', 'disabled')
      btn.html("Photo already in target album")


  TWG4.album.current_mode = modes.normal

  TWG4.album.set_mode = (name, params = {}) ->
    current_mode = TWG4.album.current_mode
    new_mode = modes[name]
    $.extend new_mode, params
    current_mode.on_unset()
    if modes.normal in [current_mode, new_mode]
      TWG4.album.current_mode = new_mode
      new_mode.on_set()
    else
      current_mode.elems().promise().done ->
        TWG4.album.current_mode = new_mode
        new_mode.on_set()
#
)()

$(document).on 'turbolinks:load', -> TWG4.album.current_mode.on_page_load()
$(document).on 'click', '#normal-mode-link, #remove-photos-mode-link, #destroy-photos-mode-link', (e) ->
  e.preventDefault()
  mode_name = switch e.target.closest('a').id
    when 'normal-mode-link' then 'normal'
    when 'remove-photos-mode-link' then 'remove_photo'
    when 'destroy-photos-mode-link' then 'destroy_photo'
  TWG4.album.set_mode(mode_name)

$(document).on 'click', '#dropdown-delete-album-btn', (e) ->
  e.preventDefault()
  $('#delete-album-btn').toggle(200)

$(document).on 'click', '#add-photo-select-albums-btn', (e) ->
  btn = $(e.target).closest('#add-photo-select-albums-btn')
  src_album_id = $('#add_existing_photo_from_album').val()
  target_album =
    id: $('#add_existing_photo_to_album').val()
    name: $('#add_existing_photo_to_album option:selected').text()
  TWG4.json_ajax('GET', "#{location.origin}/albums/#{target_album.id}/photo_ids")
  .done (resp) ->
    $(document).one 'turbolinks:load', -> TWG4.album.set_mode('add_photo', {target_album: $.extend target_album, {photo_ids: resp.ids}})
    Turbolinks.visit "#{location.origin}/albums/#{src_album_id}"
  .fail ->
    $('form.add_existing_photo').closest('.modal').modal('hide')
    TWG4.notifications.alert("Server couldn't be reached")
    btn.prop('disabled', false)

$(document).on 'click', '.add-photo-btn', (e) ->
  btn = $(e.target).closest('.add-photo-btn')
  photo_id = btn.closest('[data-photo-id]').data('photo-id')
  target_album = TWG4.album.current_mode.target_album
  btn_original_content = btn.html()
  btn.prop('disabled', true)
  btn.html("Adding photo &hellip;")
  TWG4.json_ajax(
    'POST', "#{location.origin}/albums/#{target_album.id}/add_photo",
    {photo_id: photo_id}
  )
  .done ->
    target_album.photo_ids.push(photo_id)
    btn.html("Photo added successfully")
    TWG4.notifications.notify("Photo added successfully")
  .fail ->
    btn.html(btn_original_content)
    btn.prop('disabled', false)
    TWG4.notifications.alert("Failed adding photo")

$(document).on 'click', '.remove-photo-btn', (e) ->
  e.preventDefault()
  btn = $(e.target).closest('.remove-photo-btn')
  photo_id = btn.closest('[data-photo-id]').data('photo-id')
  TWG4.json_ajax('DELETE', "#{location.origin}/albums/#{TWG4.album.current_album_id()}/remove_photo/#{photo_id}")
  .done ->
    $(document).one 'turbolinks:load', -> TWG4.notifications.notify("Photo removed from album successfully")
    Turbolinks.clearCache()
    Turbolinks.visit location.href
  .fail -> TWG4.notifications.alert("Failed removing photo from album")

$(document).on 'click', '.destroy-photo-btn', (e) ->
  e.preventDefault()
  btn = $(e.target).closest('.destroy-photo-btn')
  photo_id = btn.closest('[data-photo-id]').data('photo-id')
  TWG4.json_ajax('DELETE', "#{location.origin}/albums/#{TWG4.album.current_album_id()}/photos/#{photo_id}")
  .done ->
    $(document).one 'turbolinks:load', -> TWG4.notifications.notify("Photo deleted successfully")
    Turbolinks.clearCache()
    Turbolinks.visit location.href
  .fail -> TWG4.notifications.alert("Failed deleting photo")
