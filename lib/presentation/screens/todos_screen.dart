import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app_sqflite/common/enums/category_enum.dart';
import 'package:todo_app_sqflite/data/models/todo_model.dart';
import 'package:todo_app_sqflite/presentation/widgets/todo_container.dart';
import 'package:todo_app_sqflite/providers/todo_provider.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({super.key});

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  final titleController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 16,
        ),
        child: Column(
          children: [
            TableCalendar(
              onDaySelected: (selectedDay, focusedDay) {},
              daysOfWeekHeight: 25,
              firstDay: DateTime.utc(2025, 01, 01),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),
              calendarFormat: CalendarFormat.week,
              calendarStyle: CalendarStyle(defaultTextStyle: TextStyle()),
            ),
            Expanded(
              child: Consumer<TodoProvider>(
                builder: (context, todoProvider, child) {
                  if (todoProvider.isLoading) {
                    return Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                  if (todoProvider.todos.isEmpty) {
                    return Center(
                      child: Text("No todos found for selected data"),
                    );
                  }
                  return ListView.builder(
                    itemCount: todoProvider.todos.length ?? 0,
                    itemBuilder: (context, index) {
                      final todosData = todoProvider.todos.reversed.toList();
                      final TodoModel todo = todosData[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TodoContainer(
                          todo: todo,
                          todoProvider: todoProvider,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCupertinoDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Add todo"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                    )
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Cancel",
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<TodoProvider>().addTodo(
                            title: titleController.text.trim(),
                            dateTime: DateTime.now().toIso8601String(),
                            category: CategoryEnum.Exercise,
                          );

                      titleController.clear();
                      Navigator.pop(context);
                    },
                    child: Text("Add"),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
