listener = angular.module("listenApp", [ 'ngRoute',
    'ui.bootstrap', 'luegg.directives', 'btford.socket-io',
    'app.listener.templates'])

listener.config(($routeProvider)->
    $routeProvider.
      when('/', {controller:'ListenCtrl', templateUrl:'app/listener/listen.jade'}).
      when('/shows', {controller:'ShowCtrl', templateUrl:'app/listener/shows.jade'}).
      when('/blog', {controller:'BlogCtrl', templateUrl:'app/listener/blog.jade'}).
      when('/zine', {controller:'ZineCtrl', templateUrl:'app/listener/zine.jade'}).
      otherwise({redirectTo: '/'}))

listener.service("chatstate", ->
    name: null
    chats: [])

listener.controller('ListenCtrl', ($scope, $http, socket, $modal, chatstate)->
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
                    conf: -> return $scope.conf)))

listener.controller('MainCtrl', ($scope, $location)->
    $scope.doit = (route)-> $location.path(route))

listener.controller('ShowCtrl', ($scope, $http)->)

listener.controller('ZineCtrl', ($scope, $http)->)

listener.controller('BlogCtrl', ($scope, $http)->)
