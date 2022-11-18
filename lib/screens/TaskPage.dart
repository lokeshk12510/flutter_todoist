import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:todoist/helpers/db.dart';
import 'package:todoist/models/task.dart';
import 'package:todoist/models/todo.dart';

class TaskPage extends StatefulWidget {
  final Task? task;

  const TaskPage({super.key, required this.task});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  String _taskTitle = "";
  String _taskDescription = '';
  int taskId = 0;
  bool isEditable = false;

  final dbHelper = DbHelper();

  @override
  void initState() {
    if (widget.task != null) {
      _taskTitle = widget.task!.title!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade500,
        actions: [
          IconButton(
            color: Colors.white,
            tooltip: 'Delete Task',
            icon: const Icon(Icons.delete),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                onSubmitted: (value) async {
                  if (value != '' && widget.task == null) {
                    Task newTask = Task(title: value);
                    taskId = await dbHelper.insetTask(newTask);
                    setState(() {
                      taskId = taskId;
                      isEditable = true;
                    });
                  }
                },
                controller: TextEditingController(text: _taskTitle),
                decoration: const InputDecoration(
                  hintText: "Enter Task title",
                  hintStyle: TextStyle(color: Colors.black26),
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Visibility(
                visible: isEditable,
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Enter Task Description",
                    hintStyle: TextStyle(color: Colors.black26),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black45,
                  ),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Visibility(
                visible: isEditable,
                child: FutureBuilder(
                    initialData: const [],
                    future: dbHelper.getTodo(widget.task?.id ?? 0),
                    builder: ((context, snapshot) {
                      if (snapshot.hasData) {
                        print('todoListzz : ${snapshot.data}');
                        return Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: snapshot.data?.length,
                            itemBuilder: ((context, index) {
                              print('todo : ${snapshot.data}');

                              return CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: const Text('sfasdf'),
                                activeColor: Colors.green.shade500,
                                value: snapshot.data?[index].isDone == 1
                                    ? true
                                    : false,
                                onChanged: (value) async {
                                  Todo newTodo = Todo(
                                    isDone: value == true ? 1 : 0,
                                  );
                                  await dbHelper.insetTodo(newTodo);
                                  setState(() {});
                                },
                              );
                            }),
                          ),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    })),
              ),
              Visibility(
                visible: isEditable,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        onSubmitted: (value) async {
                          if (value != '' && widget.task != null) {
                            DbHelper dbHelper = DbHelper();
                            Todo newTodo = Todo(
                              title: value,
                            );
                            await dbHelper.insetTodo(newTodo);
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: "Enter Todo Item",
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: isEditable,
        child: FloatingActionButton(
            backgroundColor: Colors.green.shade500,
            onPressed: () {},
            child: const Icon(Icons.check)),
      ),
    );
  }
}
