import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../google_fonts.dart';
import '../providers/app_state_provider.dart';

class FocusTimerScreen extends StatefulWidget {
  final String taskId;

  const FocusTimerScreen({super.key, required this.taskId});

  @override
  State<FocusTimerScreen> createState() => _FocusTimerScreenState();
}

class _FocusTimerScreenState extends State<FocusTimerScreen> {
  Timer? _timer;
  int _secondsLeft = 25 * 60; // 25 minutes default Pomodoro
  bool _isRunning = false;
  final int _totalDurationSeconds = 25 * 60;

  void _startTimer() {
    if (_isRunning) return;
    setState(() {
      _isRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        _completeSession();
      }
    });
  }

  void _pauseTimer() {
    if (!_isRunning) return;
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _pauseTimer();
    setState(() {
      _secondsLeft = _totalDurationSeconds;
    });
  }

  void _completeSession() {
    _pauseTimer();
    final state = context.read<StudyAppState>();

    // Add 25 minutes to total study time
    double minutesStudied = _totalDurationSeconds / 60;
    state.addStudyMinutes(minutesStudied);

    // Reset timer
    setState(() {
      _secondsLeft = _totalDurationSeconds;
    });

    // Check if a milestone was achieved
    if (state.recentAchievedMilestone != null) {
      _showMilestoneCelebration(state.recentAchievedMilestone!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Amazing job! You studied for ${minutesStudied.toInt()} minutes.',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: const Color(0xFF6366F1),
        ),
      );
    }
  }

  void _showMilestoneCelebration(Milestone milestone) {
    final state = context.read<StudyAppState>();
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Milestone',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          backgroundColor: Colors.black.withValues(alpha: 0.85),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Badge
                  ScaleTransition(
                    scale: anim1,
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: const BoxDecoration(
                        color: Color(0xFF8B5CF6),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF8B5CF6),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.emoji_events,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'MILESTONE ACHIEVED!',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF8B5CF6),
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    milestone.title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    milestone.description,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: 200,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        state.clearRecentMilestone();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Awesome!',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StudyAppState>();
    final isDark = state.isDarkMode;

    final taskIndex = state.tasks.indexWhere((t) => t.id == widget.taskId);
    if (taskIndex == -1) {
      return Scaffold(body: Center(child: Text('Task not found')));
    }
    final task = state.tasks[taskIndex];
    final subject = state.subjects.firstWhere((s) => s.id == task.subjectId);

    int mins = _secondsLeft ~/ 60;
    int secs = _secondsLeft % 60;
    String timeStr =
        '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    double percent = _secondsLeft / _totalDurationSeconds;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0B1C30)
          : const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: isDark ? Colors.white : const Color(0xFF0B1C30),
          ),
          onPressed: () {
            _pauseTimer();
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Deep Study Focus',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF0B1C30),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                subject.name.toUpperCase(),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: subject.color,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                task.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0B1C30),
                ),
              ),
              const SizedBox(height: 60),

              // Circular Countdown Timer
              SizedBox(
                width: 240,
                height: 240,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: percent,
                      strokeWidth: 10,
                      backgroundColor: isDark
                          ? Colors.white10
                          : Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(subject.color),
                    ),
                    Center(
                      child: Text(
                        timeStr,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0B1C30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),

              // Timer Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _resetTimer,
                    icon: Icon(
                      Icons.replay,
                      size: 28,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  const SizedBox(width: 32),
                  GestureDetector(
                    onTap: _isRunning ? _pauseTimer : _startTimer,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: subject.color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: subject.color.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        _isRunning ? Icons.pause : Icons.play_arrow,
                        size: 36,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 32),
                  IconButton(
                    onPressed: _completeSession,
                    icon: Icon(Icons.done, size: 28, color: subject.color),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Text(
                _isRunning
                    ? 'Stay focused. Put away distractions.'
                    : 'Ready to start focus session?',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: isDark ? Colors.white60 : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
