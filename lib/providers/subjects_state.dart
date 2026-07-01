part of 'app_state_provider.dart';

extension SubjectsState on StudyAppState {
  // ── Subject methods ──
  void _initializeSubjects() {
    subjects.addAll([
      Subject(
        id: 'sub_1',
        name: 'Organic Chemistry',
        color: const Color(0xFF6366F1),
        icon: Icons.science_outlined,
      ),
      Subject(
        id: 'sub_2',
        name: 'Advanced Calculus',
        color: const Color(0xFF8B5CF6),
        icon: Icons.calculate_outlined,
      ),
      Subject(
        id: 'sub_3',
        name: 'Modern World History',
        color: const Color(0xFFEC4899),
        icon: Icons.history_edu_outlined,
      ),
      Subject(
        id: 'sub_4',
        name: 'Creative Writing',
        color: const Color(0xFF14B8A6),
        icon: Icons.edit_note_outlined,
      ),
    ]);
  }

  void addSubject(String name, Color color, IconData icon) {
    final newSub = Subject(
      id: 'sub_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      color: color,
      icon: icon,
    );
    subjects.add(newSub);
    refresh();
  }

  void editSubject(String id, String name, Color color, IconData icon) {
    final subIndex = subjects.indexWhere((s) => s.id == id);
    if (subIndex != -1) {
      subjects[subIndex].name = name;
      subjects[subIndex].color = color;
      subjects[subIndex].icon = icon;
      refresh();
    }
  }

  void deleteSubject(String id) {
    subjects.removeWhere((s) => s.id == id);
    tasks.removeWhere((t) => t.subjectId == id);
    refresh();
  }

  double getSubjectMastery(String subjectId) {
    final subTasksList = tasks.where((t) => t.subjectId == subjectId).toList();
    if (subTasksList.isEmpty) return 0.0;

    double totalWeight = 0.0;
    double completedWeight = 0.0;

    for (var task in subTasksList) {
      if (task.subTasks.isEmpty) {
        totalWeight += 1.0;
        if (task.isCompleted) {
          completedWeight += 1.0;
        }
      } else {
        for (var sub in task.subTasks) {
          totalWeight += 1.0;
          if (sub.isCompleted) {
            completedWeight += 1.0;
          }
        }
      }
    }
    return totalWeight == 0 ? 0.0 : (completedWeight / totalWeight);
  }
}
