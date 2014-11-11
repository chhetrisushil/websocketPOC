###
The main controller for the app. The controller:
- retrieves and persists the model via the todoStorage service
- exposes the model to the template and provides event handlers
###
angular.module 'todomvc'
  .controller 'TodoCtrl', ($scope, $routeParams, $filter, store) ->
    'use strict'

    todos = $scope.todos = store.todos

    $scope.newTodo = ''
    $scope.editedTodo = null

    $scope.$watch 'todos', ->
      $scope.remainingCount = $filter('filter')(todos, completed: false).length
      $scope.completedCount = todos.length - $scope.remainingCount
      $scope.allChecked = !$scope.remainingCount
      return
    , true

    #Monitor the current route for changes and adjust the filter accordingly
    $scope.$on '$routeChangeSuccess', ->
      status = $scope.status = $routeParams.status or ''

      $scope.statusFilter =  if status is 'active' then completed: false else if status is 'completed' then completed: true else null
      return

    $scope.addTodo = ->
      newTodo =
        title: do $scope.newTodo.trim
        completed: false

      if not newTodo.title
        return

      $scope.saving = true
      store.insert newTodo
        .then ->
          $scope.newTodo = ''
          return
        .finally ->
          $scope.saving = false
          return
      return

    $scope.editTodo = (todo) ->
      $scope.editedTodo = todo
      #Clone the original todo to restore it on demand.
      $scope.originalTodo = angular.extend {}, todo
      return

    $scope.saveEdits = (todo, event) ->
      #Blur events are automatically triggered after the form submit event.
      #This does some unfortunate logic handling to prevent saving twice.
      if event is blur and $scope.saveEvent is 'submit'
        $scope.saveEvent = null
        return

      $scope.saveEvent = event

      if $scope.reverted
        #todo edits were reverted-- don't save
        $scope.reverted = null
        return

      todo.title = do todo.title.trim

      if todo.title is $scope.originalTodo.title
        return

      store[if todo.title then 'put' else 'delete'] todo
        .then (->), ->
          todo.title = $scope.originalTodo.title
          return
        .finally ->
          $scope.editedTodo = null
          return
      return

    $scope.revertEdits = (todo) ->
      todos[todos.indexOf todo] = $scope.originalTodo
      $scope.editedTodo = null
      $scope.originalTodo = null
      $scope.reverted = true
      return

    $scope.removeTodo = (todo) ->
      store.delete todo
      return

    $scope.saveTodo = (todo) ->
      store.put todo
      return

    $scope.toggleCompleted = (todo, completed) ->
      if angular.isDefined completed
        todo.completed = completed

      store.put todo, todos.indexOf todo
        .then (->), ->
          todo.completed = !todo.completed
          return
      return

    $score.clearCompletedTodos = ->
      do store.clearCompleted
      return

    $scope.markAll = (completed) ->
      todos.forEach (todo) ->
        if todo.completed isnt completed
          $scope.toggleCompleted todo, completed
        return
      return
    return
