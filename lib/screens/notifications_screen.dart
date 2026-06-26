import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../google_fonts.dart';
import '../providers/app_state_provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StudyAppState>();
    final isDark = state.isDarkMode;
    final onSurface = isDark ? Colors.white : const Color(0xFF0B1C30);
    final cardBg = isDark ? const Color(0xFF213145) : Colors.white;

    final List<Map<String, dynamic>> mockNotifications = [
      {
        'title': 'Study Session Reminder',
        'body': 'Your physics study task is scheduled in 15 minutes.',
        'time': '10m ago',
        'icon': Icons.alarm,
        'color': const Color(0xFF6366F1),
      },
      {
        'title': 'Goal Achieved!',
        'body':
            'Congratulations! You completed all your scheduled tasks for yesterday.',
        'time': '2h ago',
        'icon': Icons.emoji_events,
        'color': const Color(0xFFFFB03A),
      },
      {
        'title': 'New Subject Added',
        'body': 'Chemistry subject has been created successfully.',
        'time': '1d ago',
        'icon': Icons.auto_stories,
        'color': const Color(0xFF10B981),
      },
    ];

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0B1C30)
          : const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Notifications',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            color: onSurface,
          ),
        ),
      ),
      body: mockNotifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 64,
                    color: isDark ? Colors.white38 : Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No new notifications',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20.0),
              itemCount: mockNotifications.length,
              itemBuilder: (context, index) {
                final item = mockNotifications[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: (item['color'] as Color).withValues(
                          alpha: 0.15,
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          color: item['color'] as Color,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    item['title'] as String,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: onSurface,
                                    ),
                                  ),
                                ),
                                Text(
                                  item['time'] as String,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: isDark
                                        ? Colors.white38
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item['body'] as String,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: isDark ? Colors.white70 : Colors.black87,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
