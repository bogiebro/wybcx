//= require shows zine listen blog scrollglue
angular.module("myApp", ['ui.bootstrap', 'ui.keypress', 'luegg.directives']).
config(function($routeProvider) {
    $routeProvider.
      when('/', {controller:ListenCtrl, templateUrl:'partials/listen'}).
      when('/shows', {controller:ShowCtrl, templateUrl:'partials/shows'}).
      when('/blog', {controller:BlogCtrl, templateUrl:'partials/blog'}).
      when('/zine', {controller:ZineCtrl, templateUrl:'partials/zine'}).
      otherwise({redirectTo: '/'});
});