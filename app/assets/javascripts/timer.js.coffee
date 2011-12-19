window.timer =
  intervalObject: null
  start: (duration) ->
    $("#timer").text duration
    unless window.timer.intervalObject?
      log "set window.timer.intervalObject"
      window.timer.intervalObject = setInterval("window.timer.tick()", 1000)

  tick: ->
    t = parseInt($("#timer").text(), 10) - 1
    t = 0  if t < 0
    $("#timer").text t