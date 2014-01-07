app = angular.module('chatinfo', ['btford.socket-io'])
app.factory('socket', (socketFactory)-> socketFactory!)
app.service 'chatinfo', (socket)->
    socket.forward('chat', @)
    @$on('socket:chat', (ev, data)-> @chats.push data)
    socket.forward('show', @)
    @$on('socket:show', (ev, data)-> @ <<< data)
    @name = null
    @chatter = ''
    @chats = []
    @song = ''
    @makeChatter = ->
        socket.emit 'chat' do
          type: 'chat'
          speaker: @name
          content: @chatter
        @chatter = ''
    @announce = ->
        socket.emit 'chat' do
            type: 'announce'
            content: @song
