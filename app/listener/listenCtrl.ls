@ListenCtrl = ($scope, $http, socket)->
	$scope.glued = true
	$scope.muting = 'nomute'
	$scope.chats = []
	socket.forward('chat', $scope)
	$scope.$on('socket:chat', (ev, data)-> $scope.chats.push data)

	$scope.muteme = -> $scope.muting = $scope.muting == 'mute' ? 'nomute' : 'mute'