import 'sub_task.dart';

class StudyTask {
  final String id;
  final String subjectId;
  String title;
  String description;
  DateTime time;
  String priority; // 'High', 'Medium', 'Low'
  bool isCompleted;
  List<SubTask> subTasks;

  StudyTask({
    required this.id,
    required this.subjectId,
    required this.title,
    this.description = '',
    required this.time,
    required this.priority,
    this.isCompleted = false,
    List<SubTask>? subTasks,
  }) : subTasks = subTasks ?? [];

  double get progress {
    if (subTasks.isEmpty) return isCompleted ? 1.0 : 0.0;
    int completed = subTasks.where((st) => st.isCompleted).length;
    return completed / subTasks.length;
  }
}
