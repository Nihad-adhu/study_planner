import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

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

part 'auth_state.dart';
part 'theme_state.dart';
part 'subjects_state.dart';
part 'tasks_state.dart';
part 'progress_state.dart';

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
      return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
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

  void _initializeData() {
    _initializeSubjects();
    _initializeTasks();
    _initializeMilestones();
  }

  void refresh() {
    notifyListeners();
  }
}

