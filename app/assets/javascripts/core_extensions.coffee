Number::within = (distance, opts) ->
  target = opts.from
  target - distance <= this <= target + distance
