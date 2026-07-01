part of 'app_state_provider.dart';

extension ProgressState on StudyAppState {
  // ── Progress & Milestone methods ──
  void _initializeMilestones() {
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

  void addStudyMinutes(double minutes) {
    totalStudyMinutes += minutes;
    _checkMilestones();
    refresh();
  }

  void clearRecentMilestone() {
    recentAchievedMilestone = null;
    refresh();
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
