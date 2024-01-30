class TaskData {
  TaskData({
    this.title = '',
    this.description = '',
    DateTime? deadline,
    this.isCompleted = false,
  }) : deadline = deadline ?? DateTime.now();

  String title;
  String description;
  DateTime deadline;
  bool isCompleted;
}
