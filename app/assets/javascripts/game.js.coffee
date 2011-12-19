window.game =
  host: ""
  state: null
  
  init: ->
    $("form#play").submit ->
      try
        window.game.guess()
      catch e
        log e
      false

    setInterval "window.game.fetchState()", 3000
    window.game.fetchState()

  fetchState: ->
    # log "window.game.fetchState()"
    $.getJSON window.game.host + "/games", (data) ->
      # log "window.game.fetchState() 2", data
      window.game.state = data
      window.game.update()

  update: ->
    # Guesses
    guessTemplate = _.template("<% _.each(guesses, function(guess) { %> <li><span class='name'><%= guess.word %></span></li> <% }); %>")
    $("ul#guesses").html guessTemplate(guesses: window.game.state.guesses)
    
    # Scoreboard
    scoreboardTemplate = _.template("<% _.each(users, function(user) { %> <li><span class='name'><%= user.email %></span> <span class='score'><%= user.score %></span></li> <% }); %>")
    $("ol#players").html scoreboardTemplate(users: window.game.state.users)
    
    # Query
    queryTemplate = _.template(window.game.state.query_phrase.replace('{word}', "<span class='word'><%= word %></span>"))
    query = {word: window.game.state.word}
    $("p#query").html queryTemplate(query)
    
    # Timer
    duration = parseInt(window.game.state.ends_in, 10)
    if duration < 6
      $("#timer").addClass "urgent"
    else
      $("#timer").removeClass "urgent"
    $("#timer").text duration

  guess: ->
    log "window.game.guess();"

    # Build the guess object
    guess = {word: $("#word_input").val()}
    
    # Clear the input form
    $("#word_input").val ""
    
    $.ajax
      type: "POST"
      url: window.game.host + "/games/" + window.game.state.id + "/guesses"
      dataType: "json"
      headers:
        "Content-Type": "application/json"
        'X-CSRF-Token': window.form_authenticity_token
      async: false
      data: JSON.stringify(guess)
      success: (data) ->
        log "window.game.guess() callback:"
        console.log data
        window.game.fetchState()