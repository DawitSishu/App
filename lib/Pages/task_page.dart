import 'package:flutter/material.dart';
import 'package:task_app/Utils/Widgets.dart';

class TasksPage extends StatefulWidget {
  TasksPage({required this.taskList});

  List<Map<String, dynamic>> taskList;

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.taskList.length,
      itemBuilder: (BuildContext context, int index) {
        return TaskWidget(taskData: widget.taskList[index]);
      },
    );
  }
}
