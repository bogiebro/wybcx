DashCtrl = ($scope, $http, $timeout, $upload, $modal) -> 
	$scope.progress = false
	$scope.stuff = 'sdfsdf'

	$scope.sendsub = -> $modal.open {templateUrl: 'showSent'}

	$scope.openPromo = -> $modal.open(
		templateUrl: 'promo'
		controller: DashCtrl)

	$scope.onFileSelect = ($files)->
		for $file in $files
	      $upload.upload(
	        url: '/upload'
	        file: $file
	        progress: (evt)->
	          $scope.progress = parseInt(100.0 * evt.loaded / evt.total)
	      ).success((data, status, headers, config)->
	        console.log(JSON.stringify(data)))