import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../google_fonts.dart';
import '../providers/app_state_provider.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  int _timerDuration = 25; // default 25 mins

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StudyAppState>();
    final isDark = state.isDarkMode;
    final primaryColor = const Color(0xFF6366F1);
    final onSurface = isDark ? Colors.white : const Color(0xFF0B1C30);
    final cardBg = isDark ? const Color(0xFF213145) : Colors.white;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0B1C30)
          : const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Settings',
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
            _buildSectionHeader('ACCOUNT'),
            const SizedBox(height: 12),

            // Profile Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: primaryColor.withValues(alpha: 0.15),
                        child: Text(
                          (state.username ?? 'S').substring(0, 1).toUpperCase(),
                          style: GoogleFonts.plusJakartaSans(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.username ?? 'Scholar',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              state.email ?? 'scholar@lumina.edu',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: isDark
                                    ? Colors.white60
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: OutlinedButton.icon(
                      onPressed: () => _showEditProfileDialog(context),
                      icon: Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: primaryColor,
                      ),
                      label: Text(
                        'Edit Profile',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                          fontSize: 14,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: primaryColor.withValues(alpha: 0.5),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Login & Security Card
            Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  ListTile(
                    onTap: () => _showChangePasswordDialog(context),
                    leading: Icon(Icons.lock_outline, color: primaryColor),
                    title: Text(
                      'Change Password',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: onSurface,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: Icon(Icons.link_outlined, color: primaryColor),
                    title: Text(
                      'Google Account Connected',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: onSurface,
                      ),
                    ),
                    trailing: Icon(
                      Icons.check_circle,
                      color: Colors.green.shade600,
                      size: 20,
                    ),
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: Icon(Icons.security_outlined, color: primaryColor),
                    title: Text(
                      'Account Security',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: onSurface,
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Secure',
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.green.shade600,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            _buildSectionHeader('APP SETTINGS'),
            const SizedBox(height: 12),

            // App Settings Card
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Segmented Appearance Selector
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Appearance',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: onSurface,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF0B1C30)
                                : const Color(0xFFF8F9FF),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: ['Light', 'Dark', 'System'].map((mode) {
                              final bool isSel;
                              if (mode == 'Light') {
                                isSel = state.themeMode == ThemeMode.light;
                              } else if (mode == 'Dark') {
                                isSel = state.themeMode == ThemeMode.dark;
                              } else {
                                isSel = state.themeMode == ThemeMode.system;
                              }
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (mode == 'Light') {
                                      state.setThemeMode(ThemeMode.light);
                                    } else if (mode == 'Dark') {
                                      state.setThemeMode(ThemeMode.dark);
                                    } else {
                                      state.setThemeMode(ThemeMode.system);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSel
                                          ? primaryColor
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Text(
                                        mode,
                                        style: GoogleFonts.plusJakartaSans(
                                          color: isSel
                                              ? Colors.white
                                              : (isDark
                                                    ? Colors.white60
                                                    : Colors.black54),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // Push Notifications Switch
                  SwitchListTile(
                    value: _notificationsEnabled,
                    onChanged: (val) {
                      setState(() {
                        _notificationsEnabled = val;
                      });
                    },
                    activeTrackColor: primaryColor,
                    secondary: Icon(
                      Icons.notifications_outlined,
                      color: primaryColor,
                    ),
                    title: Text(
                      'Push Notifications',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: onSurface,
                      ),
                    ),
                  ),
                  const Divider(height: 1),

                  // Focus Timer Duration Selector
                  ListTile(
                    leading: Icon(Icons.timer_outlined, color: primaryColor),
                    title: Text(
                      'Focus Timer Duration',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: onSurface,
                      ),
                    ),
                    trailing: DropdownButton<int>(
                      value: _timerDuration,
                      dropdownColor: cardBg,
                      style: GoogleFonts.plusJakartaSans(
                        color: onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                      underline: const SizedBox(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _timerDuration = val;
                          });
                        }
                      },
                      items: [15, 25, 45, 60].map((d) {
                        return DropdownMenuItem<int>(
                          value: d,
                          child: Text('$d mins'),
                        );
                      }).toList(),
                    ),
                  ),
                  const Divider(height: 1),

                  // Sound & Vibration toggles
                  SwitchListTile(
                    value: _soundEnabled,
                    onChanged: (val) {
                      setState(() {
                        _soundEnabled = val;
                      });
                    },
                    activeTrackColor: primaryColor,
                    secondary: Icon(
                      Icons.volume_up_outlined,
                      color: primaryColor,
                    ),
                    title: Text(
                      'Sound Effects',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: onSurface,
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: _vibrationEnabled,
                    onChanged: (val) {
                      setState(() {
                        _vibrationEnabled = val;
                      });
                    },
                    activeTrackColor: primaryColor,
                    secondary: Icon(
                      Icons.vibration_outlined,
                      color: primaryColor,
                    ),
                    title: Text(
                      'Haptic Vibration',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            _buildSectionHeader('SUPPORT & LEGAL'),
            const SizedBox(height: 12),

            // Support & Legal Card
            Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  ListTile(
                    onTap: () => _showInfoDialog(
                      context,
                      'Help Center',
                      'Our knowledge base is available 24/7 at support@lumina.edu.',
                    ),
                    leading: Icon(
                      Icons.help_center_outlined,
                      color: primaryColor,
                    ),
                    title: Text(
                      'Help Center',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: onSurface,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    onTap: () => _showInfoDialog(
                      context,
                      'Privacy Policy',
                      'We treat your privacy with extreme responsibility. We keep data secure locally.',
                    ),
                    leading: Icon(
                      Icons.privacy_tip_outlined,
                      color: primaryColor,
                    ),
                    title: Text(
                      'Privacy Policy',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: onSurface,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    onTap: () => _showInfoDialog(
                      context,
                      'Terms & Conditions',
                      'By using Lumina, you agree to local processing and academic integrity rules.',
                    ),
                    leading: Icon(
                      Icons.description_outlined,
                      color: primaryColor,
                    ),
                    title: Text(
                      'Terms & Conditions',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: onSurface,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    onTap: () => _showInfoDialog(
                      context,
                      'Contact Support',
                      'Submit a support ticket directly to our engineers at contact@lumina.edu.',
                    ),
                    leading: Icon(Icons.mail_outline, color: primaryColor),
                    title: Text(
                      'Contact Support',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: onSurface,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            _buildSectionHeader('ACCOUNT ACTIONS'),
            const SizedBox(height: 12),

            // Account Actions Card
            Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      state.logout();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                    leading: const Icon(Icons.logout, color: Colors.redAccent),
                    title: Text(
                      'Log Out',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    onTap: () => _showDeleteConfirmDialog(context),
                    leading: const Icon(
                      Icons.delete_forever_outlined,
                      color: Colors.red,
                    ),
                    title: Text(
                      'Delete Account',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade500,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final state = context.read<StudyAppState>();
    final nameController = TextEditingController(text: state.username);
    final emailController = TextEditingController(text: state.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF213145),
        title: Text(
          'Edit Profile',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: GoogleFonts.inter(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              style: GoogleFonts.inter(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              state.editProfile(
                nameController.text.trim(),
                emailController.text.trim(),
              );
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Color(0xFF6366F1)),
            ),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final passController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF213145),
        title: Text(
          'Change Password',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: passController,
          obscureText: true,
          style: GoogleFonts.inter(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter new password',
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password updated successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text(
              'Update',
              style: TextStyle(color: Color(0xFF6366F1)),
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF213145),
        title: Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(message, style: GoogleFonts.inter(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Color(0xFF6366F1))),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF213145),
        title: Text(
          'Delete Account',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to permanently delete your account? This action is irreversible.',
          style: GoogleFonts.inter(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              final state = context.read<StudyAppState>();
              state.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
