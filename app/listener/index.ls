app = angular.module("listenApp", [
    'ui.bootstrap', 'luegg.directives', 'btford.socket-io',
    'app.listener.templates'])

app.config(($routeProvider)->
    $routeProvider.
      when('/', {controller:ListenCtrl, templateUrl:'app/listener/listen.jade'}).
      when('/shows', {controller:ShowCtrl, templateUrl:'app/listener/shows.jade'}).
      when('/blog', {controller:BlogCtrl, templateUrl:'app/listener/blog.jade'}).
      when('/zine', {controller:ZineCtrl, templateUrl:'app/listener/zine.jade'}).
      otherwise({redirectTo: '/'}))

app.service("chatstate", ->
    name: null
    chats: [])

@MainCtrl = ($scope, $location)->
    $scope.doit = (route)-> $location.path(route)