function ListenCtrl ($scope, $http) {
	$scope.glued = true;
	$scope.muting = 'nomute';
	$scope.muteme = function() {
		$scope.muting = $scope.muting == 'mute' ? 'nomute' : 'mute';
	}
}