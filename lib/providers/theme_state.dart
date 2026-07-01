part of 'app_state_provider.dart';

extension ThemeState on StudyAppState {
  // ── Theme methods ──
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
    refresh();

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

  void toggleTheme() {
    final newMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    _themeMode = newMode;
    refresh();
    _prefs
        .setString(_kThemeModeKey, newMode == ThemeMode.dark ? 'dark' : 'light')
        .catchError((e) {
      debugPrint('[StudyAppState] toggleTheme persist error: $e');
      return false;
    });
  }
}
