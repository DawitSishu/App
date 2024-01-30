import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_app/Utils/Widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TasksPage extends StatefulWidget {
  TasksPage(
      {required this.taskList, required this.onDelete, required this.onEdit});

  final List<Map<String, dynamic>> taskList;
  final onDelete;
  final onEdit;

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final TaskBox = Hive.box('Task_box');

  void showForm(
    BuildContext ctx,
    itemKey,
  ) async {
    Map<String, dynamic> data = {};
    if (itemKey != null) {
      var rawItem = TaskBox.get(itemKey);
      data = {
        "key": itemKey,
        "title": rawItem['title'],
        "description": rawItem['description'],
        "deadline": rawItem['deadline'],
        "isCompleted": rawItem['isCompleted'],
      };
    }

    final Dateformat = DateFormat('yyyy-MM-dd');
    data['deadline'] =
        data['deadline'] != null ? Dateformat.format(data['deadline']) : null;
    showModalBottomSheet(
        context: ctx,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(ctx).viewInsets.bottom,
                  top: 15,
                  left: 15,
                  right: 15),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InputBox(
                        inputLabel: "Title",
                        placeHolder: "Insert the title",
                        initialValue: data["title"],
                        update: (value) {
                          data["title"] = value;
                        }),
                    const SizedBox(height: 5),
                    InputBox(
                        inputLabel: "Description",
                        placeHolder: "Insert the description",
                        initialValue: data["description"],
                        update: (value) {
                          data["description"] = value;
                        }),
                    const SizedBox(height: 5),
                    DatePicker(
                      inputLabel: "Deadline",
                      placeHolder: 'Select a Deadline',
                      initialValue: data["deadline"],
                      update: (value) {
                        data["deadline"] = value;
                      },
                    ),
                    const SizedBox(height: 5),
                    CustomButton(
                      label: itemKey != null ? "Update" : "Create",
                      onPressed: () async {
                        itemKey != null
                            ? await TaskBox.put(data['key'], data)
                            : await TaskBox.add(data);
                        print(data);
                        // refreshTasks();
                        Navigator.of(context).pop();
                      },
                    ),
                  ]),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.taskList.length,
      itemBuilder: (BuildContext context, int index) {
        return TaskWidget(
          taskData: widget.taskList[index],
          onEdit: () {
            showForm(context, widget.taskList[index]['key']);
            widget.onEdit();
          },
          onDelete: () {
            widget.onDelete(widget.taskList[index]);
          },
        );
      },
    );
  }
}
