import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController taskController = TextEditingController();

  List<String> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('tasks', jsonEncode(tasks));
  }

  Future<void> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? data = prefs.getString('tasks');

    if (data != null) {
      setState(() {
        tasks = List<String>.from(jsonDecode(data));
      });
    }
  }

  void addTask() {
    if (taskController.text.trim().isEmpty) return;

    setState(() {
      tasks.add(taskController.text.trim());
    });

    saveTasks();
    taskController.clear();
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });

    saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(centerTitle: true, title: const Text("My To-Do List")),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(blurRadius: 5, color: Colors.black12),
                ],
              ),

              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: taskController,
                      decoration: const InputDecoration(
                        hintText: "Enter a task",
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  ElevatedButton(onPressed: addTask, child: const Text("Add")),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: tasks.isEmpty
                  ? const Center(
                      child: Text(
                        "No Tasks Added",
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: tasks.length,

                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),

                          child: ListTile(
                            leading: CircleAvatar(child: Text("${index + 1}")),

                            title: Text(tasks[index]),

                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                deleteTask(index);
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
