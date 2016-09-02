TWG4.photo ||= {}

TWG4.photo.scroll_to_image = ->
  $(document).scrollTop($('#photo').offset().top)

TWG4.photo.description_editor =
  ctrl_buttons:
    elems: -> $('#photo-desc-editor-controls').find('span')
    are_enabled: -> not @elems().hasClass('disabled')
    show: (fn) -> @elems().each -> $(@).removeClass('disabled').show 400, fn
    hide: (fn) -> @elems().each -> $(@).addClass('disabled').hide 400, fn
  spinner:
    delayed_show: (fn) -> $.doTimeout 'photo-desc-spinner', 400, -> $('#photo-desc-spinner').show 400, fn
    hide: (fn) ->
      $.doTimeout 'photo-desc-spinner'
      $('#photo-desc-spinner').hide 400, fn
  desc:
    init: -> $.extend @,
      div: $('div#photo-description')
      textarea: $('#photo-description-textarea')
    enableEdit: -> @textarea.prop('disabled', false)
    disableEdit: -> @textarea.prop('disabled', true)
    startEdit: ->
      @init().enableEdit()
      @div.hide()
      @textarea.val(@div.text().trim())
      .show().focus().trigger('input') # Trigger 'input' event on textarea to cause it to auto-grow to its content
    revert: ->
      @textarea.hide()
      @div.show()
    save: (callbacks) ->
      @disableEdit()
      t = @
      new_desc = @textarea.val().trim()
      TWG4.json_ajax(
        'PATCH', window.location.href,
        {photo: {description: new_desc}},
        callbacks
      )
      .done ->
        t.textarea.hide()
        t.div.text(new_desc).show()
      .fail ->
        t.enableEdit()
  start: ->
    t = @
    @desc.startEdit()
    $('#photo-desc-controls').hide 400, -> t.ctrl_buttons.show()
    $.scrollSnap {condition_fn: -> not t.desc.textarea.is(':focus')}
  cancel: ->
    if @ctrl_buttons.are_enabled()
      @ctrl_buttons.hide -> $('#photo-desc-controls').show 400
      @desc.revert()
  save: ->
    if @ctrl_buttons.are_enabled()
      t = @
      @ctrl_buttons.hide()
      @desc.save(
        onSuccess: -> t.spinner.hide -> t.ctrl_buttons.elems().promise().done -> $('#photo-desc-controls').show 400
        onFailure: -> t.spinner.hide -> t.ctrl_buttons.show()
      )
      @spinner.delayed_show()


$(document).on 'click', '#edit-desc-btn', -> TWG4.photo.description_editor.start()
$(document).on 'click', '#save-desc-btn', -> TWG4.photo.description_editor.save()
$(document).on 'click', '#cancel-desc-edit-btn', -> TWG4.photo.description_editor.cancel()

$(document).on 'click', '#comment-indicator', -> $(window).scrollTo '#photo-info-and-ctrl', 200

$(document).on 'click', '#prev-photo-btn, #next-photo-btn', (e) ->
  e.preventDefault()
  form = $(e.target).closest('form')[0]
  Turbolinks.visit form.action
