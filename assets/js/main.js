function MainCtrl ($scope, $location) {
	$scope.doit = function(route) {
		$location.path(route);
	}
}