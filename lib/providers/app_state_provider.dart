import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// REMOVED: flutter_riverpod import

import '../models/sub_task.dart';
import '../models/study_task.dart';
import '../models/subject.dart';
import '../models/milestone.dart';
import '../services/auth_service.dart';

export '../models/sub_task.dart';
export '../models/study_task.dart';
export '../models/subject.dart';
export '../models/milestone.dart';
export '../services/auth_service.dart';

// ──────────────────────────────────────────────────────────────
// StudyAppState  —  the single source of truth (Pure Provider)
// ──────────────────────────────────────────────────────────────

const String _kThemeModeKey = 'theme_mode';

class StudyAppState extends ChangeNotifier {
  // ── Streak & study time ──
  int streakDays = 5;
  double totalStudyMinutes = 75;

  // ── Theme ──
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  // ── Milestone overlay ──
  Milestone? recentAchievedMilestone;

  // ── Collections ──
  final List<Subject> subjects = [];
  final List<StudyTask> tasks = [];
  final List<Milestone> milestones = [];

  final SharedPreferences _prefs;

  StudyAppState(this._prefs) {
    _initializeData();
    _loadThemeMode();
    authService.addListener(notifyListeners);
    debugPrint(
      '[StudyAppState] Constructed. themeMode=$_themeMode isDarkMode=$isDarkMode',
    );
  }

  void _loadThemeMode() {
    try {
      final stored = _prefs.getString(_kThemeModeKey);
      switch (stored) {
        case 'light':
          _themeMode = ThemeMode.light;
        case 'dark':
          _themeMode = ThemeMode.dark;
        default:
          _themeMode = ThemeMode.system;
      }
    } catch (e) {
      _themeMode = ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();

    try {
      final String value;
      switch (mode) {
        case ThemeMode.light:
          value = 'light';
        case ThemeMode.dark:
          value = 'dark';
        case ThemeMode.system:
          value = 'system';
      }
      await _prefs.setString(_kThemeModeKey, value);
    } catch (e) {
      debugPrint('[StudyAppState] Error saving theme: $e');
    }
  }

  void _initializeData() {
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

    milestones.addAll([
      Milestone(
        id: 'ms_1',
        title: 'First Steps',
        description: 'Study for a total of 15 minutes',
        targetMinutes: 15,
        isAchieved: true,
        achievedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Milestone(
        id: 'ms_2',
        title: 'Deep Focus Master',
        description: 'Study for a total of 60 minutes (1 hour)',
        targetMinutes: 60,
        isAchieved: true,
        achievedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Milestone(
        id: 'ms_3',
        title: 'Century Milestone',
        description: 'Reach 100 total study minutes',
        targetMinutes: 100,
      ),
      Milestone(
        id: 'ms_4',
        title: 'Iron Scholar',
        description: 'Reach 200 total study minutes',
        targetMinutes: 200,
      ),
    ]);
  }

  // ────────────────────────────────────────────
  // Auth Delegation
  // ────────────────────────────────────────────
  String? get username => authService.username;
  String? get email => authService.email;
  bool get isLoggedIn => authService.isLoggedIn;

  Future<void> signInWithGoogle() async {
    await authService.signInWithGoogle();
    notifyListeners();
  }

  Future<void> login(String emailVal, String passwordVal) async {
    await authService.login(emailVal, passwordVal);
    notifyListeners();
  }

  Future<void> register(String usernameVal, String emailVal, String passwordVal) async {
    await authService.register(usernameVal, emailVal, passwordVal);
    notifyListeners();
  }

  Future<void> logout() async {
    await authService.logout();
    notifyListeners();
  }

  Future<void> editProfile(String newUsername, String newEmail) async {
    await authService.editProfile(newUsername, newEmail);
    notifyListeners();
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    await authService.changePassword(currentPassword, newPassword);
    notifyListeners();
  }

  Future<void> deleteAccount(String password) async {
    await authService.deleteAccount(password);
    notifyListeners();
  }

  // ────────────────────────────────────────────
  // Theme toggle
  // ────────────────────────────────────────────
  void toggleTheme() {
    final newMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    _themeMode = newMode;
    notifyListeners();
    _prefs.setString(_kThemeModeKey, newMode == ThemeMode.dark ? 'dark' : 'light').catchError((
      e,
    ) {
      debugPrint('[StudyAppState] toggleTheme persist error: $e');
      return false;
    });
  }

  // ────────────────────────────────────────────
  // Subject methods
  // ────────────────────────────────────────────
  void addSubject(String name, Color color, IconData icon) {
    final newSub = Subject(
      id: 'sub_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      color: color,
      icon: icon,
    );
    subjects.add(newSub);
    notifyListeners();
  }

  void editSubject(String id, String name, Color color, IconData icon) {
    final subIndex = subjects.indexWhere((s) => s.id == id);
    if (subIndex != -1) {
      subjects[subIndex].name = name;
      subjects[subIndex].color = color;
      subjects[subIndex].icon = icon;
      notifyListeners();
    }
  }

  void deleteSubject(String id) {
    subjects.removeWhere((s) => s.id == id);
    tasks.removeWhere((t) => t.subjectId == id);
    notifyListeners();
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

  // ────────────────────────────────────────────
  // Task methods
  // ────────────────────────────────────────────
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
    notifyListeners();
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
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void editSubTask(String taskId, String subTaskId, String title) {
    final taskIndex = tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex != -1) {
      final subIndex = tasks[taskIndex].subTasks.indexWhere(
        (s) => s.id == subTaskId,
      );
      if (subIndex != -1) {
        tasks[taskIndex].subTasks[subIndex].title = title;
        notifyListeners();
      }
    }
  }

  void deleteSubTask(String taskId, String subTaskId) {
    final taskIndex = tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex != -1) {
      tasks[taskIndex].subTasks.removeWhere((s) => s.id == subTaskId);
      notifyListeners();
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
      notifyListeners();
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
      notifyListeners();
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
        notifyListeners();
      }
    }
  }

  // ────────────────────────────────────────────
  // Study minutes & milestones
  // ────────────────────────────────────────────
  void addStudyMinutes(double minutes) {
    totalStudyMinutes += minutes;
    _checkMilestones();
    notifyListeners();
  }

  void clearRecentMilestone() {
    recentAchievedMilestone = null;
    notifyListeners();
  }

  void _checkMilestones() {
    for (var milestone in milestones) {
      if (!milestone.isAchieved &&
          totalStudyMinutes >= milestone.targetMinutes) {
        milestone.isAchieved = true;
        milestone.achievedAt = DateTime.now();
        recentAchievedMilestone = milestone;
      }
    }
  }
}

// REMOVED: Custom AppStateProvider InheritedNotifier wrapper.
