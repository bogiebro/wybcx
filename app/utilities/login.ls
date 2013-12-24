login = angular.module('login', ['ngRoute', 'app.templates'])
login.config(($routeProvider)->
    $routeProvider.when('/login',
        controller:'LoginCtrl'
        templateUrl:'app/utilities/login.jade'))

login.constant('check',
    loggedin: ($q, $timeout, $http, $location)->
        deferred = $q.defer()
        $http.get('/loggedin').success((user)->
            if (user !== '0')
                $timeout(deferred.resolve, 0)
            else
                $timeout((-> deferred.reject!), 0)
                oldloc = $location.url!
                $location.url('/login').search(next: oldloc))
        return deferred.promise)

login.controller('LoginCtrl', ($scope, $http, $route, $location, $log)->
    $scope.login = ->
        $http.post('/login',
                username: $scope.email
                password: $scope.password).
            success((user)->
                if user then $location.url($location.search!.next)
                else $route.reload!).
            error(-> $route.reload!)
        $scope.email = ''
        $scope.password = '')
