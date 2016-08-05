(($) ->
  $.fn.scrollSnap = (opts) ->
    defaults = {delay: 250, distance: 32, speed: 200}
    opts = $.extend defaults, opts
    elems = this

    $(window).scroll ->
      $.doTimeout 'scroll_snap', opts.delay, ->
        elems.each ->
          pos = $(@).position().top
          if $(window).scrollTop().within(opts.distance, {from: pos})
            $('html, body').stop().animate {scrollTop: pos}, opts.speed
    this
#
) jQuery

$(document).on 'turbolinks:load', ->
  $('body').find('[data-scroll-snap]').scrollSnap()
