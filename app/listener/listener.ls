listener = angular.module("listenApp", [ 'ngRoute',
    'ui.bootstrap', 'luegg.directives', 'chatinfo',
    'app.listener.templates'])

listener.config(($routeProvider)->
    $routeProvider.
      when('/', {controller:'ListenCtrl', templateUrl:'app/listener/listen.jade'}).
      when('/shows', {controller:'ShowCtrl', templateUrl:'app/listener/shows.jade'}).
      when('/blog', {controller:'BlogCtrl', templateUrl:'app/listener/blog.jade'}).
      when('/zine', {controller:'ZineCtrl', templateUrl:'app/listener/zine.jade'}).
      otherwise({redirectTo: '/'}))

listener.controller 'ListenCtrl', ($scope, $modal, chatinfo, $log)->
    $scope.chatinfo = chatinfo
    $scope.glued = true

    $scope.playlist = [src: 'http://wybc.com:8000/x.mp3']

    $scope.$on('$viewContentLoaded', ->
        if !chatinfo.name
            $modal.open(
                backdrop: 'static'
                keyboard: false
                templateUrl: 'askId'
                controller: ($scope, $modalInstance, chatinfo)->
                    $scope.chatinfo = chatinfo
                    $scope.submit = -> $modalInstance.dismiss('cancel')))

listener.controller('MainCtrl', ($scope, $location)->
    $scope.doit = (route)-> $location.path(route))

listener.controller('ShowCtrl', ($scope, $http)->)

listener.controller('ZineCtrl', ($scope, $http)->)

listener.controller('BlogCtrl', ($scope, $http)->)
