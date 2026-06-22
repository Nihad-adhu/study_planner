class Milestone {
  final String id;
  final String title;
  final String description;
  final double targetMinutes;
  bool isAchieved;
  DateTime? achievedAt;

  Milestone({
    required this.id,
    required this.title,
    required this.description,
    required this.targetMinutes,
    this.isAchieved = false,
    this.achievedAt,
  });
}
