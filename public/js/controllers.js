'use strict';

/* Controllers */

function IndexCtrl($scope, $http) {
  $http.get('/blog/posts').
    success(function(data, status, headers, config) {
      console.log('sucess');
      $scope.posts = data.posts;
    }).error(function(){
      
    });
}

function MyPostCtrl($scope, $http) {
  $http.get('/blog/myposts').
    success(function(data, status, headers, config) {
      $scope.posts = data.posts;
    }).error(function(){
      
    });
}

function AddPostCtrl($scope, $http, $location) {
  $scope.form = {};
  $scope.form.text='';
  $scope.submitPost = function () {
    $http.post('/blog/post', $scope.form).
      success(function(data) {
        $location.path('/');
      });
  };
}

function ReadPostCtrl($scope, $http, $routeParams, $sce) {
  $http.get('/blog/post/' + $routeParams.id).
    success(function(data) {
      $scope.post = data.post;
      $scope.post.html=$sce.trustAsHtml(data.post.html);
    });
}
function EditPostCtrl($scope, $http, $location, $routeParams) {
  $scope.form = {};
  $http.get('/api/post/' + $routeParams.id).
    success(function(data) {
      $scope.form = data.post;
    });
  $scope.editPost = function () {
    $http.put('/api/post/' + $routeParams.id, $scope.form).
      success(function(data) {
        $location.url('/readPost/' + $routeParams.id);
      });
  };
}
function loginCtrl($scope, $http, $routeParams,$location){
  $scope.user={};
  $scope.userLogin = function () {
    console.log(1111);
    $http.post('/user/login/', $scope.user).
      success(function(data) {
        $location.url('/');
      });
  };  
}

function DeletePostCtrl($scope, $http, $location, $routeParams) {
  $http.get('/api/post/' + $routeParams.id).
    success(function(data) {
      $scope.post = data.post;
    });
  $scope.deletePost = function () {
    $http.delete('/api/post/' + $routeParams.id).
      success(function(data) {
        $location.url('/');
      });
  };

  $scope.home = function () {
    $location.url('/');
  };
}
