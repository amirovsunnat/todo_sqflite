import 'package:todo_app_sqflite/common/enums/category_enum.dart';
import 'package:todo_app_sqflite/common/utils/typdefs.dart';
import 'package:todo_app_sqflite/data/local_datasource/local_data_source.dart';

class TodoRepo {
  final LocalDataSource localDataSource;

  TodoRepo({
    required this.localDataSource,
  });

  // get todos
  Future<List<DataMap>> fetchTodos() async {
    return await localDataSource.getTodos();
  }

  // add new todo
  Future<bool> addNewTodo({
    required String title,
    required String dateTime,
    required CategoryEnum category,
  }) async {
    return await localDataSource.addTodo(
      title: title,
      dateTime: dateTime,
      category: category,
    );
  }

  
}
