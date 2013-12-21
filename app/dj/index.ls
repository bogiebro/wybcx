app = angular.module("djApp", ['ui.bootstrap',
        'angularFileUpload', 'luegg.directives', 'app.dj.templates'])

app.config(($routeProvider)->
    $routeProvider.
      when('/', {controller:DashCtrl, templateUrl:'app/dj/dash.jade'}).
      when('/onair', {controller:OnAirCtrl, templateUrl:'app/dj/onair.jade'}).
      when('/blog', {controller:BlogCtrl, templateUrl:'app/dj/blog.jade'}).
      otherwise({redirectTo: '/'}))