exports.connect = (s) ->
  s.emit('chat',
    {
      type: 'chat',
      speaker: 'Mojo',
      content: 'go fuck yourself'
    })
