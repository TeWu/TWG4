TWG4.json_ajax = (method, url, json_data, callbacks = {}, opts = {}) ->
  defaults = {dataType: 'json', contentType: 'application/json; charset=utf-8'}
  opts = $.extend defaults, opts

  if method.toUpperCase() not in ['GET', 'POST']
    opts.headers = $.extend opts.headers, {'X-HTTP-Method-Override': method}
    method = 'POST'
  $.extend opts, {method: method}
  $.extend opts, {data: JSON.stringify(json_data)} if json_data?

  xhr = $.ajax(url, opts)
  xhr.done(callbacks.onSuccess) if callbacks.onSuccess?
  xhr.fail(callbacks.onFailure) if callbacks.onFailure?
  xhr.always(callbacks.onComplete) if callbacks.onComplete?
  xhr
