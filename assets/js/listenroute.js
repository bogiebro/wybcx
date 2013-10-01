//= require listenshows listenzine listenchat listenblog scrollglue
angular.module("myApp", ['ui.bootstrap', 'ui.keypress', 'luegg.directives']).
config(function($routeProvider) {
    $routeProvider.
      when('/', {controller:ListenCtrl, templateUrl:'listener/partials/listen'}).
      when('/shows', {controller:ShowCtrl, templateUrl:'listener/partials/shows'}).
      when('/blog', {controller:BlogCtrl, templateUrl:'listener/partials/blog'}).
      when('/zine', {controller:ZineCtrl, templateUrl:'listener/partials/zine'}).
      otherwise({redirectTo: '/'});
});