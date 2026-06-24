import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 1. Added official provider package import
import '../google_fonts.dart';
import '../providers/app_state_provider.dart'; // Contains your updated StudyAppState
import '../screens/login_screen.dart';
import '../screens/focus_timer_screen.dart';
import '../screens/settings_screen.dart';

class CustomDrawer extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onNavigate;

  const CustomDrawer({
    super.key,
    required this.activeIndex,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    // 2. FIXED: Use the official provider extension context.watch<T>()
    final state = context.watch<StudyAppState>();
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final drawerBg = theme.scaffoldBackgroundColor;
    final onDrawerSurface = colors.onSurface;

    return Drawer(
      backgroundColor: drawerBg,
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Drawer Header Profile Card
          Container(
            padding: const EdgeInsets.only(
              top: 60,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: BoxDecoration(
              color: theme.cardColor,
              border: Border(
                bottom: BorderSide(
                  color: colors.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                // Offline Avatar with Initials
                CircleAvatar(
                  radius: 26,
                  backgroundColor: colors.primary.withValues(alpha: 0.2),
                  child: Text(
                    (state.username ?? 'S').substring(0, 1).toUpperCase(),
                    style: GoogleFonts.plusJakartaSans(
                      color: colors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.username ?? 'Scholar',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          color: onDrawerSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        state.email ?? 'scholar@lumina.edu',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: onDrawerSurface.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Drawer Menu List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              children: [
                _buildSectionTitle(context, 'WORKSPACE'),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.dashboard_outlined,
                  title: 'Home',
                  isActive: activeIndex == 0,
                  onTap: () {
                    Navigator.pop(context);
                    onNavigate(0);
                  },
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.calendar_month_outlined,
                  title: 'Planner',
                  isActive: activeIndex == 1,
                  onTap: () {
                    Navigator.pop(context);
                    onNavigate(1);
                  },
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.science_outlined,
                  title: 'Subjects',
                  isActive: false,
                  onTap: () {
                    Navigator.pop(context);
                    onNavigate(0);
                  },
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.task_alt_outlined,
                  title: 'Tasks',
                  isActive: false,
                  onTap: () {
                    Navigator.pop(context);
                    onNavigate(0);
                  },
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.timer_outlined,
                  title: 'Focus Timer',
                  isActive: false,
                  onTap: () {
                    Navigator.pop(context);
                    if (state.tasks.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FocusTimerNavWrapper(
                            taskId: state.tasks.first.id,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Add a task first to start a focus timer!',
                          ),
                        ),
                      );
                    }
                  },
                ),

                _buildSectionTitle(context, 'PERFORMANCE'),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.bar_chart_outlined,
                  title: 'Analytics',
                  isActive: activeIndex == 2,
                  onTap: () {
                    Navigator.pop(context);
                    onNavigate(2);
                  },
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.notifications_none_outlined,
                  title: 'Notifications',
                  isActive: false,
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No new notifications.')),
                    );
                  },
                ),

                _buildSectionTitle(context, 'PREFERENCES'),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.emoji_events_outlined,
                  title: 'Rewards',
                  isActive: activeIndex == 3,
                  onTap: () {
                    Navigator.pop(context);
                    onNavigate(3);
                  },
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  isActive: false,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.help_outline,
                  title: 'Help Center',
                  isActive: false,
                  onTap: () {
                    Navigator.pop(context);
                    _showMockDialog(
                      context,
                      'Help Center',
                      'Please contact support@lumina.edu for help and queries.',
                    );
                  },
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.lock_outline,
                  title: 'Privacy Policy',
                  isActive: false,
                  onTap: () {
                    Navigator.pop(context);
                    _showMockDialog(
                      context,
                      'Privacy Policy',
                      'Your study data is saved locally on your device and is never shared.',
                    );
                  },
                ),
              ],
            ),
          ),

          // Logout Action
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: colors.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: _buildDrawerItem(
              context: context,
              icon: Icons.logout,
              title: 'Logout',
              isActive: false,
              color: Colors.redAccent,
              onTap: () {
                state.logout();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 16, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required bool isActive,
    required VoidCallback onTap,
    Color? color,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final activeBg = colors.primary.withValues(alpha: 0.12);
    final activeText = colors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isActive ? activeBg : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(
          icon,
          color:
              color ??
              (isActive ? activeText : colors.onSurface.withValues(alpha: 0.7)),
          size: 20,
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            color:
                color ??
                (isActive
                    ? activeText
                    : colors.onSurface.withValues(alpha: 0.8)),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  void _showMockDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
        ),
        content: Text(message, style: GoogleFonts.inter()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// FocusTimer wrapper class
class FocusTimerNavWrapper extends StatelessWidget {
  final String taskId;
  const FocusTimerNavWrapper({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return FocusTimerScreen(taskId: taskId);
  }
}
