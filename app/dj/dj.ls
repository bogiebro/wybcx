dj = angular.module("djApp", ['ui.bootstrap', 'ngRoute', 'ui.bootstrap.tpls',
        'angularFileUpload', 'luegg.directives', 'app.dj.templates', 'chatinfo',
        'login']).config(($routeProvider, $locationProvider, check)->
    $routeProvider.
        when('/dash', {controller:'DashCtrl', templateUrl:'app/dj/dash.jade', resolve: check}).
        when('/newshow', {controller:'NewShowCtrl', templateUrl:'app/dj/newshow.jade', resolve: check}).
        when('/onair', {controller:'OnAirCtrl', templateUrl:'app/dj/onair.jade', resolve: check}).
        when('/blog', {controller:'BlogCtrl', templateUrl:'app/dj/blog.jade', resolve: check}).
        when('/', {redirectTo: '/dash'}))

dj.controller('BlogCtrl', ($scope, $http)->)

# DashCtrl
dj.controller 'DashCtrl', ($scope, $upload, $location, $http, loggedin)->
    $scope.showinfo =
        name: ''
        time: ''
        description: ''
        hasimage: false

    if loggedin.show
        $http.get('/showdesc/' + loggedin.show).success((d)-> $scope.showinfo <<< d)
    else $location.url('/newshow')

    $scope.timetext = $scope.showinfo.time || 'No set time yet'
    $scope.maybegray = if $scope.showinfo.time then '' else 'grayish'

    $scope.showimg = loggedin.show + '.jpg?a=' + new Date!.getTime!

    $scope.onAir = -> $location.url('onair')

    $scope.edit = ->
        $http.post('/showdesc', desc: $scope.showinfo.description)
        $scope.editing = false

    $scope.promo = progress: 0
    $scope.rec = progress: 0
    $scope.pic = progress: 0

    $scope.promotext = ->
        return $scope.promo.progress + "%" if 100 > $scope.promo.progress > 0
        return "drop a promo"

    $scope.rectext = ->
        return $scope.rec.progress + "%" if 100 > $scope.rec.progress > 0
        return "drop a show"

    uploadThing = ($files, type, obj, callback)->
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
                callback! if callback
            , null, (evt)->
                    obj.progress = parseInt(100.0 * evt.loaded / evt.total))

    $scope.onImgSelect = ($files)->
        uploadThing($files, 'image', $scope.pic, ->
            $scope.showinfo.hasimage = true
            $scope.showimg = loggedin.show + '.jpg?a=' + new Date!.getTime!)

    $scope.onPromoSelect = ($files)-> uploadThing($files, 'promo', $scope.promo)

    $scope.onRecSelect = ($files)-> uploadThing($files, 'rec', $scope.rec)

# OnAirCtrl
dj.controller 'OnAirCtrl', ($scope, $http, loggedin, chatinfo)->
    if !loggedin.show then $location.url('/newshow') else
        $scope.chatinfo = chatinfo
        chatinfo.join(loggedin.username)
        chatinfo.djJoin!
        $scope.glued = true
        $scope.chatinfo = chatinfo

# NewShowCtrl
dj.controller 'NewShowCtrl', ($scope, $upload, $location, loggedin)->
    $scope.dashboard = -> $location.url('dash')

    $scope.result =
        progress: 0
        finished: false

    $scope.showReq = (show)->
        $upload.upload(
            url: '/showreq'
            method: 'POST'
            data: show
            file: $scope.sample
            fileFormDataName: 'myFile'
        ).then((response)->
            $scope.result.finished = true
        , null, (evt)->
             $scope.result.progress = parseInt(100.0 * evt.loaded / evt.total))

    $scope.onFileSelect = ($files)-> $scope.sample = $files[0]
