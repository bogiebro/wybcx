app = angular.module('chatinfo', ['btford.socket-io'])
app.factory('socket', (socketFactory)-> socketFactory!)

app.factory 'chatinfo', (socket, $http, $rootScope)->
    result = 
        chatter: ''
        chats: []
        song: ''
        registered: false
        join: (name)->
            result.registered = true
            socket.emit 'join' name
        djJoin: -> $http.post('/onair')
        announce: -> $http.post '/djdo' do
            type: 'announce'
            content: result.song
        makeChatter: ->
            socket.emit 'chat' result.chatter
            result.chatter = ''

    $rootScope.$on('socket:chat', (ev, data)-> result.chats.push data)
    $rootScope.$on('socket:show', (ev, data)-> result.show = data)
    socket.forward('chat', $rootScope)
    socket.forward('show', $rootScope)
    return result
