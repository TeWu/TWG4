(($) ->
  elems = null
  scroll_handler = null

  $.scrollSnap = (opts) -> $(window).scrollSnap(opts)

  $.fn.scrollSnap = (opts) ->
    defaults = {delay: 250, distance: 32, speed: 200}
    opts = $.extend defaults, opts
    elems = this if this[0] not in [window, document]

    $(window).off 'scroll', scroll_handler if scroll_handler?
    scroll_handler = ->
      $.doTimeout 'scroll_snap', opts.delay, ->
        if not opts.condition_fn? or opts.condition_fn()
          elems.each ->
            pos = $(@).position().top
            if $(window).scrollTop().within(opts.distance, {from: pos})
              $('html, body').stop().animate {scrollTop: pos}, opts.speed
    $(window).on 'scroll', scroll_handler
    this
#
) jQuery

$(document).on 'turbolinks:load', -> $('[data-scroll-snap]').scrollSnap()
