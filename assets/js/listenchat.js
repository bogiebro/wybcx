//= require scrollglue
function ListenCtrl ($scope, $http, socket) {
	$scope.glued = true;
	$scope.muting = 'nomute';
	$scope.muteme = function() {
		$scope.muting = $scope.muting == 'mute' ? 'nomute' : 'mute';
	};
	$scope.chats = [];
	socket.forward('chat', $scope);
	$scope.$on('socket:chat', function (ev, data) {
		$scope.chats.push(data);	
	});
}
