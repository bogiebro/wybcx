@ListenCtrl = ($scope, $http, socket, $modal, $rootScope)->
    $scope.glued = true
    $scope.muting = 'nomute'
    $scope.chats = []
    socket.forward('chat', $scope)
    $scope.$on('socket:chat', (ev, data)-> $scope.chats.push data)

    $scope.prefs =
        name: null

    $scope.muteme = -> $scope.muting = $scope.muting == 'mute' ? 'nomute' : 'mute'

    $scope.makeChatter = ->
        socket.emit('chat',
          type: 'chat'
          speaker: $scope.prefs.name
          content: $scope.chatter)
        $scope.chatter = ""

    $scope.$on('$viewContentLoaded', ->
        $modal.open(
            templateUrl: 'askId'
            controller: ($scope, $modalInstance, prefs)->
                $scope.prefs = prefs
                $scope.submit = -> $modalInstance.dismiss('cancel')
            resolve:
                prefs: -> return $scope.prefs))