import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/Components/create_task_form.dart';
import 'package:todo_app/Components/todo_item.dart';
import 'package:todo_app/models/task.dart';

class TaskService {
  // Save tasks list to local storage
  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final taskJsonList =
        tasks.map((task) => json.encode(task.toJson())).toList();
    await prefs.setStringList('tasks', taskJsonList);
  }

  // Load tasks list from local storage
  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskJsonList = prefs.getStringList('tasks') ?? [];

    // Convert the JSON string back into Task objects
    return taskJsonList
        .map((taskJson) => Task.fromJson(json.decode(taskJson)))
        .toList();
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Task> tasks = [];
  final TaskService _taskService = TaskService();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // Load tasks when the app starts
  Future<void> _loadTasks() async {
    final loadedTasks = await _taskService.loadTasks();
    setState(() {
      tasks = loadedTasks;
    });
  }

  // Save tasks when they change
  Future<void> _saveTasks() async {
    await _taskService.saveTasks(tasks);
  }

  void addTask(String name) {
    setState(() {
      tasks.add(Task(name: name, completed: false));
    });
    _saveTasks();
    Navigator.pop(context);
  }

  void removeTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
    _saveTasks();
  }

  void markAsDone(int index) {
    setState(() {
      tasks[index].completed = !tasks[index].completed;
    });
    _saveTasks();
  }

  void createTask() {
    showDialog(
      context: context,
      builder: (context) {
        return CreateTaskForm(onSubmit: addTask);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final uncompletedTasks = tasks.where((task) => !task.completed).toList();
    final completedTasks = tasks.where((task) => task.completed).toList();

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Todo List",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.indigo,
      ),
      backgroundColor: Colors.indigo[200],
      floatingActionButton: FloatingActionButton(
        onPressed: createTask,
        child: Icon(Icons.add, color: Colors.indigo),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 24),

            Text(
              "New Tasks",
              style: TextStyle(
                color: Colors.indigo[400],
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            uncompletedTasks.isEmpty
                ? Center(
                  child: Text(
                    "No todos yet..",
                    style: TextStyle(color: Colors.grey[300], fontSize: 16),
                  ),
                )
                : SizedBox.shrink(),

            ...tasks
                .where((task) => !task.completed)
                .map(
                  (task) => Todo(
                    task: task,
                    handleDelete: removeTask,
                    handleDone: markAsDone,
                    index: tasks.indexOf(task),
                  ),
                ),

            const SizedBox(height: 24),
            Text(
              "Completed Tasks",
              style: TextStyle(
                color: Colors.indigo[400],
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            completedTasks.isEmpty
                ? Text(
                  "No completed tasks yet..",
                  style: TextStyle(color: Colors.grey[300], fontSize: 16),
                )
                : SizedBox.shrink(),

            ...tasks
                .where((task) => task.completed)
                .map(
                  (task) => Todo(
                    task: task,
                    handleDelete: removeTask,
                    handleDone: markAsDone,
                    index: tasks.indexOf(task),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
