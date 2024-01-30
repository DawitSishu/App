import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_app/Models/task_model.dart';
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
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  final data = TaskData();
  final TaskBox = Hive.box('Task_box');

  void showForm(BuildContext ctx, int? itemKey) async {
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
                          data.title = value;
                        }),
                    const SizedBox(height: 5),
                    InputBox(
                        inputLabel: "Description",
                        placeHolder: "Insert the description",
                        update: (value) {
                          data.title = value;
                        }),
                    const SizedBox(height: 5),
                    DatePicker(
                      inputLabel: "Deadline",
                      placeHolder: 'Select a Deadline',
                      update: (value) {
                        data.deadline = value;
                      },
                    ),
                    const SizedBox(height: 5),
                    CustomButton(
                      label: "Create",
                      onPressed: () async {
                        await TaskBox.add(data);
                        print(data);
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
          children: const [Scaffold(), Scaffold(), Scaffold()],
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
