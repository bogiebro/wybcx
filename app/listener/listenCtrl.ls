@ListenCtrl = ($scope, $http, socket, $modal, chatstate)->
    $scope.glued = true
    $scope.muting = 'nomute'
    socket.forward('chat', $scope)
    $scope.$on('socket:chat', (ev, data)-> $scope.chats.push data)

    $scope.chats = chatstate.chats
    $scope.conf = chatstate

    $scope.muteme = -> $scope.muting = $scope.muting == 'mute' ? 'nomute' : 'mute'

    $scope.makeChatter = ->
        socket.emit('chat',
          type: 'chat'
          speaker: $scope.conf.name
          content: $scope.chatter)
        $scope.chatter = ""

    $scope.$on('$viewContentLoaded', ->
        if !chatstate.name
            $modal.open(
                templateUrl: 'askId'
                controller: ($scope, $modalInstance, conf)->
                    $scope.conf = conf
                    $scope.submit = -> $modalInstance.dismiss('cancel')
                resolve:
                    conf: -> return $scope.conf))