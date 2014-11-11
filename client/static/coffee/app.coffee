angular.module 'todomvc', ['ngRoute']
  .config ($routeProvider)  ->
    'use strict'
    routeConfig =
      controller: 'TodoCtrl'
      templateUrl: 'todomvc-index.html'
      resolve:
        store: (todoStorage) ->
          todoStroage.then (module) ->
            do module.get
            module
    $routeProvider
      .when '/', routeConfig
      .when '/:status', routeConfig
      .otherwise 
        redirectTo: '/'
    return;
