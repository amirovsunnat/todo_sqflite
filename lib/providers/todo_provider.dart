import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app_sqflite/common/enums/category_enum.dart';
import 'package:todo_app_sqflite/data/models/todo_model.dart';
import 'package:todo_app_sqflite/data/repositories/todo_repo.dart';

class TodoProvider extends ChangeNotifier {
  final TodoRepo todoRepo;

  bool isLoading = false;
  List<TodoModel> todos = [];
  List<TodoModel> filterdTodos = [];

  DateTime selectedDate = DateTime.now();

  // setter for selected date
  void setselectedDate(DateTime date) {
    selectedDate = date;
    log("set date called.....");
    notifyListeners();
  }

  TodoProvider(this.todoRepo);

  Future<void> filterTodosByDate() async {
    todos.forEach(
      (element) => log(element.date.toString()),
    );
    filterdTodos = todos.where((element) {
      log(element.toString());
      log(isSameDay(element.date, selectedDate).toString());
      return isSameDay(element.date, selectedDate);
    }).toList();
    log("filtering : $todos");
    notifyListeners();
  }

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
    filterdTodos.addAll(todos);
    filterTodosByDate();
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
