import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_app/Pages/task_page.dart';
import 'package:task_app/Utils/Widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final List<Tab> myTabs = <Tab>[
    const Tab(
      child: Text(
        'Today',
        maxLines: 1,
        softWrap: false,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    ),
    const Tab(
      child: Text(
        'Tommorow',
        maxLines: 1,
        softWrap: false,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    ),
    const Tab(
      child: Text(
        'Upcoming',
        maxLines: 1,
        softWrap: false,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 3);
    refreshTasks();
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  final TaskBox = Hive.box('Task_box');

  List<Map<String, dynamic>> tasks = [];
  List<Map<String, dynamic>> tasksToday = [];
  List<Map<String, dynamic>> tasksTomorrow = [];
  List<Map<String, dynamic>> tasksUpcoming = [];

  void refreshTasks() {
    tasks = [];
    tasksToday = [];
    tasksTomorrow = [];
    tasksUpcoming = [];
    final now = DateTime.now();

    final taskslist = TaskBox.keys.map((key) {
      final item = TaskBox.get(key);
      final deadline = item['deadline'];
      if (deadline != null && deadline is DateTime) {
        if (isSameDay(deadline, now)) {
          tasksToday.add({
            "key": key,
            "title": item['title'],
            "description": item['description'],
            "deadline": item['deadline'],
            "isCompleted": item['isCompleted'],
          });
        } else if (isSameDay(deadline, now.add(Duration(days: 1)))) {
          tasksTomorrow.add({
            "key": key,
            "title": item['title'],
            "description": item['description'],
            "deadline": item['deadline'],
            "isCompleted": item['isCompleted'],
          });
        } else if (deadline.isAfter(now.add(Duration(days: 1)))) {
          tasksUpcoming.add({
            "key": key,
            "title": item['title'],
            "description": item['description'],
            "deadline": item['deadline'],
            "isCompleted": item['isCompleted'],
          });
        }
      }
      return {
        "key": key,
        "title": item['title'],
        "description": item['description'],
        "deadline": item['deadline'],
        "isCompleted": item['isCompleted'],
      };
    }).toList();

    setState(() {
      tasks = taskslist.reversed.toList();
    });
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void showForm(BuildContext ctx, int? itemKey) async {
    Map<String, dynamic> data = {};
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
                        update: (value) {
                          data["title"] = value;
                        }),
                    const SizedBox(height: 5),
                    InputBox(
                        inputLabel: "Description",
                        placeHolder: "Insert the description",
                        update: (value) {
                          data["description"] = value;
                        }),
                    const SizedBox(height: 5),
                    DatePicker(
                      inputLabel: "Deadline",
                      placeHolder: 'Select a Deadline',
                      update: (value) {
                        data["deadline"] = value;
                      },
                    ),
                    const SizedBox(height: 5),
                    CustomButton(
                      label: "Create",
                      onPressed: () async {
                        await TaskBox.add(data);
                        print(data);
                        refreshTasks();
                        Navigator.of(context).pop();
                      },
                    ),
                  ]),
            ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 116, 59, 107),
          title: const Text(
            'Task Manager',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => showForm(context, null),
              iconSize: 30,
            ),
          ],
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            TasksPage(taskList: tasksToday),
            TasksPage(taskList: tasksTomorrow),
            TasksPage(taskList: tasksUpcoming),
          ],
        ),
        bottomNavigationBar: DecoratedBox(
          decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(
                    width: 1.2, color: Color.fromARGB(255, 116, 59, 107))),
          ),
          child: TabBar(
            labelPadding: EdgeInsets.zero,
            controller: tabController,
            splashBorderRadius: BorderRadius.circular(40),
            labelColor: const Color.fromARGB(255, 116, 59, 107),
            unselectedLabelColor: Colors.grey,
            unselectedLabelStyle: const TextStyle(),
            tabs: myTabs,
          ),
        ),
      );
}
