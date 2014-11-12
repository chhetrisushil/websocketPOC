###
# Services that persists and retrieves todos from localStorage or a backend API
# if avialable.
#
# They both follow the same API, returning promises  for all the changes to the
# model.
###

angular.module 'todomvc'
  .factory 'todoStorage', ($http, $injector) ->
    'use strict'
    # Detect if an API backend is present. If so, return the API module, else
    # hand off the localStorage adapter
    $http.get '/api'
      .then ->
        $injector.get 'api'
      , ->
        $injector.get 'localStorage'
  .factory 'api', ($http) ->
    'use strict'
    store =
      todos: []

      clearCompleted: ->
        originalTodos = store.todos.slice 0

        completeTodos = []
        incompleteTodos = []

        store.todos.forEach (todo) ->
          if todo.completed
            completeTodos.push todo
          else
            incompleteTodos.push todo
          return

        angular.copy incompleteTodos, store.todos

        $http.delete '/api/todos'
          .then ->
            store.todos
          , ->
            angular.copy originalTodos, store.todos
            originalTodos

      delete: (todo) ->
        originalTodos = store.todos.slice 0
        store.todos.splice store.todos.indexOf(todo), 1

        $http.delete '/api/todos/' + todo.id
          .then ->
            store.todos
          , ->
            angular.copy originalTodos, store.todos
            originalTodos

      get: ->
        $http.get '/api/todos'
          .then (resp) ->
            angular.copy resp.data, store.todos
            store.todos

      insert: (todo) ->
        originalTodos = store.todos.slice 0

        $http.post '/api/todos', todo
          .then (resp) ->
            todo.id = resp.data.id
            store.todos.push todo
            store.todos
          , ->
            angular.copy originalTodos, store.todos
            store.todos

      put: (todo) ->
        originalTodos = store.todos.slice 0

        $http.put '/api/todos' + todo.id, todo
          .then ->
            store.todos
          , ->
            angular.copy originalTodos, store.todos
            originalTodos
    store
  .factory 'localStorage', ($q) ->
    'use strict'

    STORAGE_ID = 'todos-angularjs'

    store =
      todos: []

      _getFromLocalStorage: ->
        JSON.parse localStorage.getItem STORAGE_ID or '[]'

      _saveToLocalStorage: (todos) ->
        localStorage.setItem STORAGE_ID, JSON.stringify todos
        return

      clearCompleted: ->
        deferred = do $q.defer

        completeTodos = []
        incompleteTodos = []

        store.todos.forEach (todo) ->
          if todo.completed
            completeTodos.push todo
          else
            incompleteTodos.push todo
          return

        angular.copy incompleteTodos, store.todos

        store._saveToLocalStorage store.todos

        deferred.resolve store.todos

        do deferred.promise

      delete: (todo) ->
        deferred = do $q.defer

        store.todos.splice store.todos.indexOf(todo), 1
        store._saveToLocalStorage store.todos

        deferred.resolve store.todos

        deferred.promise

      get: ->
        deferred = do $q.defer

        angular.copy do store._getFromLocalStorage, store.todos

        deferred.resolve store.todos

        defered.promise

      insert: (todo) ->
        deferred = do $q.defer

        store.todos.push todo

        store._saveToLocalStorage store.todos

        deferred.resolve store.todos

        deferred.promise

      put: (todo, index) ->
        deferred = do $q.defer

        store.todos[index] = todo

        store._saveToLocalStorage store.todos

        deferred.resolve store.todos

        deferred.promise

    store
