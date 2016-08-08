$(document).on 'input', 'textarea[data-autogrow]', (e) ->
  textarea = e.target
  textarea.style.height = ""
  textarea.style.height = Math.min(textarea.scrollHeight, 500) + "px"
