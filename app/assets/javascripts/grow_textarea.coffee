$(document).on 'turbolinks:load', -> $('textarea[data-autogrow]').trigger('input') # Trigger 'input' event on textarea to cause it to auto-grow to its content
$(document).on 'input', 'textarea[data-autogrow]', (e) -> # Not using jQuery to make this function more performant
  textarea = e.target
  textarea.style.height = ""
  textarea.style.height = Math.min(textarea.scrollHeight + 2, 500) + "px" # '+ 2' instead of using jQuery to get height with border
