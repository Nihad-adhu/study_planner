import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../google_fonts.dart';
import '../providers/app_state_provider.dart';


class RewardsScreen extends StatelessWidget {
  final VoidCallback? onContinue;

  const RewardsScreen({super.key, this.onContinue});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StudyAppState>();
    final isDark = state.isDarkMode;
    final primaryColor = const Color(0xFF6366F1);
    final onSurface = isDark ? Colors.white : const Color(0xFF0B1C30);
    final cardBg = isDark ? const Color(0xFF213145) : Colors.white;

    // Format study hours
    final studyHours = state.totalStudyMinutes / 60.0;
    final studyHoursStr = studyHours >= 1.0 ? studyHours.toStringAsFixed(1) : state.totalStudyMinutes.toStringAsFixed(0);
    final studyHoursUnit = studyHours >= 1.0 ? 'Hrs' : 'Mins';

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B1C30) : const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Icon(Icons.emoji_events_outlined, color: onSurface, size: 24),
            const SizedBox(width: 8),
            Text(
              'Milestone Achieved',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: onSurface,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
                border: Border.all(
                  color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [


                  // Trophy Image Card with Sparkles
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Sparkle stars
                      Positioned(
                        top: 10,
                        left: 20,
                        child: Icon(Icons.star, color: Colors.purple.withValues(alpha: 0.6), size: 24),
                      ),
                      Positioned(
                        bottom: 30,
                        right: 15,
                        child: Icon(Icons.star_border, color: Colors.purple.withValues(alpha: 0.6), size: 20),
                      ),
                      Positioned(
                        top: 40,
                        right: 30,
                        child: Icon(Icons.auto_awesome, color: Colors.indigo.withValues(alpha: 0.4), size: 16),
                      ),
                      // Core Image Container
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
                              blurRadius: 25,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: Image.asset(
                            'assets/images/crystal_trophy.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.deepPurple.shade900,
                                child: const Center(
                                  child: Icon(
                                    Icons.emoji_events,
                                    color: Colors.amber,
                                    size: 80,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Title "Level Up!"
                  Text(
                    'Level Up!',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0B1C30),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: isDark ? Colors.white70 : Colors.black87,
                          height: 1.5,
                        ),
                        children: [
                          const TextSpan(text: "You've completed "),
                          TextSpan(
                            text: "${state.totalStudyMinutes.toInt()} mins",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6366F1),
                            ),
                          ),
                          const TextSpan(
                            text: " of deep work this month. Your cognitive endurance is peaking.",
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Two Metrics Cards Side-by-Side
                  Row(
                    children: [
                      // Streak Card
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.02)
                                : const Color(0xFFF3F4F6).withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.05)
                                  : Colors.grey.shade200,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.local_fire_department,
                                    color: Colors.purple,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'STREAK',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      color: Colors.purple,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${state.streakDays} Days',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20,
                                  color: onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Maintained consistency since May 14th',
                                style: GoogleFonts.inter(
                                  fontSize: 9,
                                  color: isDark ? Colors.white54 : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Focus Card
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.02)
                                : const Color(0xFFF3F4F6).withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.05)
                                  : Colors.grey.shade200,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.track_changes,
                                    color: Colors.indigo,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'FOCUS',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      color: Colors.indigo,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '$studyHoursStr $studyHoursUnit',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20,
                                  color: onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Top 5% of Lumina users this week',
                                style: GoogleFonts.inter(
                                  fontSize: 9,
                                  color: isDark ? Colors.white54 : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Share Achievement Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Achievement shared with friends! 🎉'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.share, color: Colors.white, size: 18),
                      label: Text(
                        'Share Achievement',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Continue to Dashboard Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: TextButton.icon(
                      onPressed: onContinue,
                      icon: Icon(
                        Icons.arrow_forward,
                        color: isDark ? const Color(0xFF90B4FC) : const Color(0xFF3B82F6),
                        size: 18,
                      ),
                      label: Text(
                        'Continue to Dashboard',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: isDark ? const Color(0xFF90B4FC) : const Color(0xFF3B82F6),
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: isDark
                            ? const Color(0xFF2C3E55).withValues(alpha: 0.6)
                            : const Color(0xFFE5EEFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
