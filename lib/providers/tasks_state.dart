part of 'app_state_provider.dart';

extension TasksState on StudyAppState {
  // ── Task methods ──
  void _initializeTasks() {
    tasks.addAll([
      StudyTask(
        id: 'task_1',
        subjectId: 'sub_1',
        title: 'Reaction Mechanisms',
        description:
            'Understand nucleophilic substitution reactions SN1 & SN2 and practice drawing curved arrow mechanisms.',
        time: DateTime.now().add(const Duration(hours: 1)),
        priority: 'High',
        subTasks: [
          SubTask(
            id: 'st_1_1',
            title: 'Compare SN1 vs SN2 rate equations',
            isCompleted: true,
          ),
          SubTask(
            id: 'st_1_2',
            title: 'Draw transition state diagrams',
            isCompleted: false,
          ),
          SubTask(
            id: 'st_1_3',
            title: 'Solve textbook practice problems 1-10',
            isCompleted: false,
          ),
        ],
      ),
      StudyTask(
        id: 'task_2',
        subjectId: 'sub_2',
        title: 'Taylor Series Expansion',
        description:
            'Review convergence tests and derive Taylor polynomials for standard trigonometric functions.',
        time: DateTime.now().add(const Duration(days: 1)),
        priority: 'Medium',
        subTasks: [
          SubTask(
            id: 'st_2_1',
            title: 'Memorize sin(x) and cos(x) series expansion',
            isCompleted: true,
          ),
          SubTask(
            id: 'st_2_2',
            title: 'Work out the remainder term (Lagrange form)',
            isCompleted: true,
          ),
        ],
      ),
      StudyTask(
        id: 'task_3',
        subjectId: 'sub_3',
        title: 'French Revolution Essay',
        description:
            'Draft the introduction and primary thesis evaluating the social causes of 1789.',
        time: DateTime.now().add(const Duration(days: 2)),
        priority: 'Low',
        subTasks: [
          SubTask(
            id: 'st_3_1',
            title: 'Find 3 reliable primary sources online',
            isCompleted: false,
          ),
        ],
      ),
    ]);
  }

  void addTask(
    String subjectId,
    String title,
    String description,
    DateTime time,
    String priority,
    List<String> subTaskTitles,
  ) {
    final taskId = 'task_${DateTime.now().millisecondsSinceEpoch}';
    final newTask = StudyTask(
      id: taskId,
      subjectId: subjectId,
      title: title,
      description: description,
      time: time,
      priority: priority,
      subTasks: subTaskTitles
          .map(
            (t) => SubTask(
              id: 'st_${DateTime.now().millisecondsSinceEpoch}_${t.hashCode}',
              title: t,
            ),
          )
          .toList(),
    );
    tasks.add(newTask);
    refresh();
  }

  void editTask(
    String id,
    String title,
    String description,
    DateTime time,
    String priority,
  ) {
    final taskIndex = tasks.indexWhere((t) => t.id == id);
    if (taskIndex != -1) {
      tasks[taskIndex].title = title;
      tasks[taskIndex].description = description;
      tasks[taskIndex].time = time;
      tasks[taskIndex].priority = priority;
      refresh();
    }
  }

  void deleteTask(String id) {
    tasks.removeWhere((t) => t.id == id);
    refresh();
  }

  void editSubTask(String taskId, String subTaskId, String title) {
    final taskIndex = tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex != -1) {
      final subIndex = tasks[taskIndex].subTasks.indexWhere(
        (s) => s.id == subTaskId,
      );
      if (subIndex != -1) {
        tasks[taskIndex].subTasks[subIndex].title = title;
        refresh();
      }
    }
  }

  void deleteSubTask(String taskId, String subTaskId) {
    final taskIndex = tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex != -1) {
      tasks[taskIndex].subTasks.removeWhere((s) => s.id == subTaskId);
      refresh();
    }
  }

  void addSubTask(String taskId, String title) {
    final taskIndex = tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex != -1) {
      tasks[taskIndex].subTasks.add(
        SubTask(
          id: 'st_${DateTime.now().millisecondsSinceEpoch}',
          title: title,
        ),
      );
      tasks[taskIndex].isCompleted = false;
      refresh();
    }
  }

  void toggleTaskCompletion(String taskId) {
    final taskIndex = tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex != -1) {
      final task = tasks[taskIndex];
      task.isCompleted = !task.isCompleted;
      for (var sub in task.subTasks) {
        sub.isCompleted = task.isCompleted;
      }
      refresh();
    }
  }

  void toggleSubTaskCompletion(String taskId, String subTaskId) {
    final taskIndex = tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex != -1) {
      final task = tasks[taskIndex];
      final subIndex = task.subTasks.indexWhere((s) => s.id == subTaskId);
      if (subIndex != -1) {
        task.subTasks[subIndex].isCompleted =
            !task.subTasks[subIndex].isCompleted;
        task.isCompleted = task.subTasks.every((s) => s.isCompleted);
        refresh();
      }
    }
  }
}
