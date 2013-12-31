listener = angular.module("listenApp", [ 'ngRoute',
    'ui.bootstrap', 'luegg.directives', 'btford.socket-io',
    'app.listener.templates', 'audioPlayer'])

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
    socket.forward('chat', $scope)
    $scope.$on('socket:chat', (ev, data)-> $scope.chats.push data)

    $scope.chats = chatstate.chats
    $scope.conf = chatstate

    $scope.playlist = [src: 'http://wybc.com:8000/x.mp3', type: 'audio/mp3']

    $scope.makeChatter = ->
        socket.emit('chat',
          type: 'chat'
          speaker: $scope.conf.name
          content: $scope.chatter)
        $scope.chatter = ""

    $scope.$on('$viewContentLoaded', ->
        if !chatstate.name
            $modal.open(
                backdrop: 'static'
                keyboard: false
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
