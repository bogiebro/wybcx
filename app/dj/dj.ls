dj = angular.module("djApp", ['ui.bootstrap', 'ngRoute', 'ui.bootstrap.tpls',
        'angularFileUpload', 'luegg.directives', 'app.dj.templates', 'btford.socket-io',
        'login']).config(($routeProvider, $locationProvider, check)->
    $routeProvider.
        when('/dash', {controller:'DashCtrl', templateUrl:'app/dj/dash.jade', resolve: check}).
        when('/onair', {controller:'OnAirCtrl', templateUrl:'app/dj/onair.jade', resolve: check}).
        when('/blog', {controller:'BlogCtrl', templateUrl:'app/dj/blog.jade', resolve: check}).
        when('/', {redirectTo: '/dash'}))

dj.factory('socket', (socketFactory)-> return socketFactory!)

dj.controller('BlogCtrl', ($scope, $http)->)

dj.controller('DashCtrl', ($scope, $upload, $location, $http, loggedin)->
    $scope.showinfo =
        name: ''
        time: ''
        description: ''

    $scope.onAir = -> $location.url('onair')

    $http.get('/showdesc/' + loggedin.show).success((d)-> $scope.showinfo = d)

    $scope.edit = ->
        $http.post('/showdesc', desc: $scope.showinfo.description)
        $scope.editing = false

    $scope.promo = 
        progress: 0
        fname: null

    $scope.rec = 
        progress: 0
        fname: null

    $scope.pic = 
        progress: 0
        fname: null

    $scope.promotext = ->
        return $scope.promo.progress + "%" if 100 > $scope.promo.progress > 0
        return "drop a promo"

    $scope.rectext = ->
        return $scope.rec.progress + "%" if 100 > $scope.rec.progress > 0
        return "drop a show"

    uploadThing = ($files, type, obj)->
        if (obj.progress == 0)
            obj.fname = null
            $upload.upload(
                url : '/upload'
                method: 'POST'
                headers: {'myHeaderKey': 'myHeaderVal'}
                data : { uploadtype : type }
                file: $files[0]
                fileFormDataName: 'myFile'
            ).then((response)->
                obj.progress = 0
                obj.fname = response.data.result
            , null, (evt)->
                    obj.progress = parseInt(100.0 * evt.loaded / evt.total))

    $scope.onImgSelect = ($files)-> uploadThing($files, 'image', $scope.pic)

    $scope.onPromoSelect = ($files)-> uploadThing($files, 'promo', $scope.promo)

    $scope.onRecSelect = ($files)-> uploadThing($files, 'rec', $scope.rec))

dj.controller('OnAirCtrl', ($scope, $http, socket, loggedin)->
    $scope.info =
        chatter: ''
        song: ''

    $scope.makeChatter = ->
        socket.emit('chat',
          type: 'chat'
          speaker: loggedin.username
          content: $scope.info.chatter)
        $scope.info.chatter = ""

    $scope.announce = ->
        socket.emit('chat',
            type: 'announce'
            content: $scope.info.song)
        $scope.info.song = ""

    $scope.glued = true
    $scope.chats = []
    socket.forward('chat', $scope)
    $scope.$on('socket:chat', (ev, data)-> $scope.chats.push data))