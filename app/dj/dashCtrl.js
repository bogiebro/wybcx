function DashCtrl ($scope, $http, $timeout, $upload, $modal) {
	$scope.progress = false;
	$scope.stuff = 'sdfsdf';

	$scope.sendsub = function() {
		$modal.open({templateUrl: 'showSent'})
	}

	$scope.openPromo = function() {
		$modal.open({templateUrl: 'promo',
					 controller: DashCtrl})
	}

	$scope.onFileSelect = function($files) {
	    //$files: an array of files selected, each file has name, size, and type.
	    for (var i = 0; i < $files.length; i++) {
	      var $file = $files[i];
	      $upload.upload({
	        url: '/upload',
	        // headers: {'headerKey': 'headerValue'}, withCredential: true,
	        file: $file,
	        progress: function(evt) {
	          console.log("got here");
	          $scope.progress = parseInt(100.0 * evt.loaded / evt.total);
	        }
	      }).success(function(data, status, headers, config) {
	        // file is uploaded successfully
	        // $scope.progress = false;
	        console.log(JSON.stringify(data));
	      })
	      //.error(...).then(...); 
	    }
	  }
}