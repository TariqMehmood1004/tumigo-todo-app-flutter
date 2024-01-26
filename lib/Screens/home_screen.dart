// ignore_for_file: library_private_types_in_public_api, prefer_final_fields
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todoapp/Helpers/database_helper.dart';
import 'package:todoapp/Models/todo_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      home: TodoScreen(),
    );
  }
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _descriptionEditingController = TextEditingController();
  DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Todo> _todos = [];

  DateTime dateTime = DateTime.now();

  @override
  void dispose() {
    _textEditingController.dispose();
    _descriptionEditingController.dispose();
    super.dispose();
  }

  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  _loadTodos() async {
    var todos = await _databaseHelper.getTodos();
    setState(() {
      _todos = todos;
    });
  }

  _addTodo() async {
    String title = _textEditingController.text;
    String description = _descriptionEditingController.text;
    if (title.isNotEmpty) {
      Todo newTodo = Todo(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        description: description,
        dateTime: dateTime.toString(),
        isCompleted: false,
      );
      await _databaseHelper.insertTodo(newTodo);
      _textEditingController.clear();
      _descriptionEditingController.clear();
      _loadTodos();
    }
  }

  _deleteTodo(int id) async {
    await _databaseHelper.deleteTodo(id);
    _loadTodos();
  }

  bool onRefreshToAppearTextFields = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        tooltip: 'Add Todo',
        elevation: 5,
        splashColor: Colors.blue[300],
        mini: false,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: const Text('Todo App'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          onRefreshToAppearTextFields = !onRefreshToAppearTextFields;
          _loadTodos();
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Column(
              children: [
                onRefreshToAppearTextFields
                    ? Container()
                    : Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        width: MediaQuery.sizeOf(context).width,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 20),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 0),
                          child: Column(
                            children: [
                              TextField(
                                controller: _textEditingController,
                                autofocus: false,
                                textInputAction: TextInputAction.done,
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0C0327),
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Your New Task',
                                  hintStyle: const TextStyle(
                                    fontSize: 30,
                                    color: Color(0xDADBD1D1),
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    height: 1.5,
                                    decoration: TextDecoration.none,
                                    decorationColor: Colors.transparent,
                                    decorationStyle: TextDecorationStyle.solid,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 22, vertical: 6),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),

                              // Create a text for datetime now
                              const SizedBox(height: 10),
                              Container(
                                width: MediaQuery.sizeOf(context).width,
                                height: 30,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  dateTime.toString(),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFADADAD),
                                    decoration: TextDecoration.none,
                                    decorationColor: Colors.transparent,
                                  ),
                                ),
                              ),

                              TextField(
                                controller: _descriptionEditingController,
                                autofocus: false,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  hintText: 'Description',
                                  hintStyle: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF9E9999),
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    decoration: TextDecoration.none,
                                    decorationColor: Colors.transparent,
                                    decorationStyle: TextDecorationStyle.solid,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 22,
                                    vertical:
                                        6, // Adjust the vertical padding to 12 pixels
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                maxLines: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  width: MediaQuery.sizeOf(context).width,
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 20.0),
                          child: Text(
                            textAlign: TextAlign.left,
                            'All Tasks (${_todos.length}, Completed: ${_todos.where((todo) => todo.isCompleted).length})',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              decoration: TextDecoration.none,
                              decorationColor: Colors.transparent,
                              decorationStyle: TextDecorationStyle.solid,
                              height: 1.5,
                              decorationThickness: 0,
                            ),
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        reverse: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 4.0),
                        itemCount: _todos.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 4.0),
                            decoration: BoxDecoration(
                              color: _todos[index].isCompleted
                                  ? Colors.amberAccent[100]
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              onLongPress: () {
                                setState(() {
                                  _todos[index].isCompleted =
                                      !_todos[index].isCompleted;
                                  log(_todos[index].isCompleted.toString());
                                });
                              },
                              subtitle: Text(
                                _todos[index]
                                    .getShortContent(
                                      shortWordsLength: 10,
                                      columnName: _todos[index].description,
                                    )
                                    .toString(),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                  decorationColor: Colors.transparent,
                                  decorationStyle: TextDecorationStyle.solid,
                                  decorationThickness: 0,
                                  fontStyle: FontStyle.normal,
                                  fontFamily: 'Roboto',
                                  inherit: false,
                                ),
                              ),
                              title: Text(
                                _todos[index]
                                    .getShortContent(
                                      shortWordsLength: 6,
                                      columnName: _todos[index].title,
                                    )
                                    .toString(),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF0C0327),
                                  decoration: TextDecoration.none,
                                  decorationColor: Colors.transparent,
                                  decorationStyle: TextDecorationStyle.solid,
                                  decorationThickness: 0,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  size: 20,
                                ),
                                onPressed: () => _deleteTodo(_todos[index].id),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
