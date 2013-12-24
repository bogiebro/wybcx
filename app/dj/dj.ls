dj = angular.module("djApp", ['ui.bootstrap', 'ngRoute', 'ui.bootstrap.tpls',
        'angularFileUpload', 'luegg.directives', 'app.dj.templates', 'btford.socket-io',
        'login']).config(($routeProvider, $locationProvider, check)->
    $routeProvider.
        when('/dash', {controller:'DashCtrl', templateUrl:'app/dj/dash.jade', resolve: check}).
        when('/onair', {controller:'OnAirCtrl', templateUrl:'app/dj/onair.jade', resolve: check}).
        when('/blog', {controller:'BlogCtrl', templateUrl:'app/dj/blog.jade', resolve: check}).
        when('/', {redirectTo: '/dash'}))

dj.controller('DashCtrl', ($scope, $http, $upload, $modal, $location)->
    $scope.progress = false

    $scope.sendsub = -> $modal.open {templateUrl: 'showSent'}

    $scope.onAir = -> $location.url('onair')

    $scope.openPromo = ->
        $modal.open(
            templateUrl: 'promo'
            controller: DashCtrl)

    $scope.onFileSelect = ($files)->
        for $file in $files
          $upload.upload(
            url: '/upload'
            file: $file
            progress: (evt)->
              $scope.progress = parseInt(100.0 * evt.loaded / evt.total)
          ).success((data, status, headers, config)->
            $scope.finished = true
            console.log(JSON.stringify(data))))

dj.controller('BlogCtrl', ($scope, $http)->)

dj.controller('OnAirCtrl', ($scope, $http, socket, loggedin)->
    $scope.makeChatter = ->
        socket.emit('chat',
          type: 'chat'
          speaker: loggedin.email
          content: $scope.chatter)
        $scope.chatter = ""

    $scope.glued = true
    $scope.chats = []
    socket.forward('chat', $scope)
    $scope.$on('socket:chat', (ev, data)-> $scope.chats.push data))