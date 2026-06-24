import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../google_fonts.dart';
import '../providers/app_state_provider.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StudyAppState>();
    final isDark = state.isDarkMode;
    final onSurface = isDark ? Colors.white : const Color(0xFF0B1C30);
    final primaryColor = const Color(0xFF6366F1);
    final accentColor = const Color(0xFF8B5CF6);

    // Calculate completion rates
    final totalTasks = state.tasks.length;
    final completedTasks = state.tasks.where((t) => t.isCompleted).length;
    final completionRate = totalTasks == 0
        ? 0.0
        : (completedTasks / totalTasks);

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0B1C30)
          : const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Progress & Analytics',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            color: onSurface,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Row
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF213145) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Study Time',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${state.totalStudyMinutes.toInt()}m',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF213145) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Completion Rate',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${(completionRate * 100).toInt()}%',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: accentColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Subject Mastery Compare List
            Text(
              'Mastery by Subject',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF213145) : Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.subjects.length,
                itemBuilder: (context, index) {
                  final sub = state.subjects[index];
                  final mastery = state.getSubjectMastery(sub.id);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              sub.name,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: onSurface,
                              ),
                            ),
                            Text(
                              '${(mastery * 100).toInt()}%',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: sub.color,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: mastery,
                            minHeight: 8,
                            backgroundColor: isDark
                                ? Colors.white10
                                : Colors.grey.shade100,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              sub.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 28),

            // Achievements / Milestones Section
            Text(
              'Achieved Milestones',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: onSurface,
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              itemCount: state.milestones.length,
              itemBuilder: (context, index) {
                final milestone = state.milestones[index];

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF213145) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: milestone.isAchieved
                          ? accentColor.withValues(alpha: 0.3)
                          : Colors.transparent,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        milestone.isAchieved
                            ? Icons.emoji_events
                            : Icons.lock_outline,
                        color: milestone.isAchieved
                            ? accentColor
                            : Colors.grey.shade400,
                        size: 24,
                      ),
                      const Spacer(),
                      Text(
                        milestone.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: milestone.isAchieved
                              ? onSurface
                              : Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        milestone.isAchieved
                            ? 'Achieved!'
                            : '${milestone.targetMinutes.toInt()}m target',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: milestone.isAchieved
                              ? Colors.green.shade600
                              : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
