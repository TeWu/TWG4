TWG4.json_ajax = (method, url, json_data, callbacks) ->
  defaults = {dataType: 'json', contentType: 'application/json; charset=utf-8'}
  opts = $.extend defaults, opts
  callbacks ||= {}

  if method.toUpperCase() not in ['GET', 'POST']
    opts.headers = $.extend opts.headers, {'X-HTTP-Method-Override': method}
    method = 'POST'

  xhr = $.ajax(url, $.extend opts, {method: method, data: JSON.stringify(json_data)})
  xhr.done(callbacks.onSuccess) if callbacks.onSuccess?
  xhr.fail(callbacks.onFailure) if callbacks.onFailure?
  xhr.always(callbacks.onComplete) if callbacks.onComplete?
  xhr
