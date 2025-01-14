import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:todo_app_sqflite/common/enums/category_enum.dart';
import 'package:todo_app_sqflite/data/models/todo_model.dart';
import 'package:todo_app_sqflite/data/repositories/todo_repo.dart';

class TodoProvider extends ChangeNotifier {
  final TodoRepo todoRepo;

  bool isLoading = false;
  List<TodoModel> todos = [];

  TodoProvider(this.todoRepo);

  // get todos
  Future<void> getTodos() async {
    isLoading = true;
    notifyListeners();
    final todosData = await todoRepo.fetchTodos();
    todos = todosData
        .map(
          (todo) => TodoModel.fromJson(todo),
        )
        .toList();
    isLoading = false;
    notifyListeners();
  }

  // add new todo
  Future<void> addTodo({
    required String title,
    required String dateTime,
    required CategoryEnum category,
  }) async {
    log("Add new task called");
    isLoading = true;
    notifyListeners();
    await todoRepo.addNewTodo(
      title: title,
      dateTime: dateTime,
      category: category,
    );
    isLoading = false;
    await getTodos();
    notifyListeners();
  }
}
