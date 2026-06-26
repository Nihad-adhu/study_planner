import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../google_fonts.dart';
import 'package:intl/intl.dart';
import '../providers/app_state_provider.dart';
import 'task_detail_screen.dart';
import 'settings_screen.dart';
import '../utils/edit_dialogs.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonthDate = DateTime.now();
  bool _isMonthView = false;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<StudyAppState>(context);
    final isDark = state.isDarkMode;
    final onSurface = isDark ? Colors.white : const Color(0xFF0B1C30);
    final primaryColor = const Color(0xFF6366F1);
    final cardBg = isDark ? const Color(0xFF213145) : Colors.white;

    // Get tasks for selected date
    final targetTasks = state.tasks.where((t) {
      return t.time.year == _selectedDate.year &&
          t.time.month == _selectedDate.month &&
          t.time.day == _selectedDate.day;
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B1C30) : const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: onSurface),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).maybePop();
            }
          },
        ),
        title: Row(
          children: [
            if (_isMonthView) ...[
              CircleAvatar(
                radius: 16,
                backgroundColor: primaryColor.withValues(alpha: 0.15),
                child: Text(
                  (state.username ?? 'L').substring(0, 1).toUpperCase(),
                  style: GoogleFonts.plusJakartaSans(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Schedule',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: onSurface,
                ),
              ),
            ] else ...[
              Text(
                'Calendar & Schedule',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: onSurface,
                ),
              ),
            ],
          ],
        ),
        actions: [
          // Toggle View Icon
          IconButton(
            icon: Icon(
              _isMonthView ? Icons.view_week_outlined : Icons.calendar_month,
              color: onSurface,
            ),
            onPressed: () {
              setState(() {
                _isMonthView = !_isMonthView;
                if (_isMonthView) {
                  _currentMonthDate = _selectedDate;
                }
              });
            },
          ),
          if (_isMonthView)
            IconButton(
              icon: Icon(Icons.settings_outlined, color: onSurface),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: _isMonthView
          ? FloatingActionButton(
              onPressed: () => _showAddTaskSheet(context),
              backgroundColor: const Color(0xFF6366F1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            )
          : null,
      body: _isMonthView
          ? _buildMonthViewBody(state, isDark, onSurface, primaryColor, cardBg, targetTasks)
          : _buildWeekViewBody(state, isDark, onSurface, primaryColor, targetTasks),
    );
  }

  // ────────────────────────────────────────────
  // WEEKLY SLIDER VIEW
  // ────────────────────────────────────────────
  Widget _buildWeekViewBody(
    StudyAppState state,
    bool isDark,
    Color onSurface,
    Color primaryColor,
    List<StudyTask> targetTasks,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Month Name
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          child: Text(
            DateFormat('MMMM yyyy').format(_selectedDate),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: onSurface,
            ),
          ),
        ),

        // Horizontal Date Selector (7 Days)
        SizedBox(
          height: 96,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 14, // 2 weeks view
            itemBuilder: (context, index) {
              final date = DateTime.now().add(Duration(days: index - 3));
              final isSelected = DateUtils.isSameDay(date, _selectedDate);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = date;
                  });
                },
                child: Container(
                  width: 60,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? primaryColor
                        : (isDark ? const Color(0xFF213145) : Colors.white),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: primaryColor.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('E').format(date).toUpperCase(),
                        style: GoogleFonts.roboto(
                          color: isSelected
                              ? Colors.white70
                              : Colors.grey.shade500,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        date.day.toString(),
                        style: GoogleFonts.plusJakartaSans(
                          color: isSelected ? Colors.white : onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        // Tasks List
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tasks Scheduled',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                if (targetTasks.isEmpty)
                  Expanded(
                    child: Center(
                      child: Text(
                        'No tasks scheduled for this day.',
                        style: GoogleFonts.inter(
                          color: isDark
                              ? Colors.white60
                              : Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: targetTasks.length,
                      itemBuilder: (context, index) {
                        final task = targetTasks[index];
                        final sub = state.subjects.firstWhere(
                          (s) => s.id == task.subjectId,
                        );

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF213145)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark
                                  ? Colors.transparent
                                  : Colors.grey.shade100,
                            ),
                          ),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      TaskDetailScreen(taskId: task.id),
                                ),
                              );
                            },
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            leading: Checkbox(
                              value: task.isCompleted,
                              activeColor: sub.color,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              onChanged: (val) {
                                state.toggleTaskCompletion(task.id);
                              },
                            ),
                            title: Text(
                              task.title,
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: onSurface,
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: sub.color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  sub.name,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: isDark
                                        ? Colors.white60
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getPriorityColor(
                                      task.priority,
                                    ).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    task.priority,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: _getPriorityColor(task.priority),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: isDark
                                        ? Colors.white54
                                        : Colors.black45,
                                    size: 20,
                                  ),
                                  padding: EdgeInsets.zero,
                                  onSelected: (val) {
                                    if (val == 'edit') {
                                      showEditTaskSheet(context, task);
                                    }
                                    if (val == 'delete') {
                                      state.deleteTask(task.id);
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'edit',
                                      child: Text('Edit'),
                                    ),
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ────────────────────────────────────────────
  // MONTHLY GRID & TIMELINE SCHEDULE VIEW
  // ────────────────────────────────────────────
  Widget _buildMonthViewBody(
    StudyAppState state,
    bool isDark,
    Color onSurface,
    Color primaryColor,
    Color cardBg,
    List<StudyTask> targetTasks,
  ) {
    // Calculate dates for month grid
    final year = _currentMonthDate.year;
    final month = _currentMonthDate.month;
    final firstDayOfMonth = DateTime(year, month, 1);
    
    // Day of week of the first day (Monday = 1, Sunday = 7)
    final firstWeekday = firstDayOfMonth.weekday;
    final paddingDays = firstWeekday - 1; // days to pad from prev month
    
    final gridStartDate = firstDayOfMonth.subtract(Duration(days: paddingDays));
    
    // We render 6 weeks (42 days) to ensure all months fit nicely in grid
    final gridDates = List<DateTime>.generate(42, (index) {
      return gridStartDate.add(Duration(days: index));
    });

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      children: [
        // Month Select Bar: e.g. "October 2023 v" and "< >"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _currentMonthDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                  builder: (context, child) {
                    return Theme(
                      data: isDark ? ThemeData.dark() : ThemeData.light(),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  setState(() {
                    _currentMonthDate = picked;
                    _selectedDate = picked;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF213145) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text(
                      DateFormat('MMMM yyyy').format(_currentMonthDate),
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        color: onSurface,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(Icons.keyboard_arrow_down, color: onSurface, size: 18),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left, color: onSurface),
                  onPressed: () {
                    setState(() {
                      _currentMonthDate = DateTime(
                        _currentMonthDate.year,
                        _currentMonthDate.month - 1,
                        1,
                      );
                      _selectedDate = DateTime(
                        _currentMonthDate.year,
                        _currentMonthDate.month,
                        _selectedDate.day > 28 ? 28 : _selectedDate.day,
                      );
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right, color: onSurface),
                  onPressed: () {
                    setState(() {
                      _currentMonthDate = DateTime(
                        _currentMonthDate.year,
                        _currentMonthDate.month + 1,
                        1,
                      );
                      _selectedDate = DateTime(
                        _currentMonthDate.year,
                        _currentMonthDate.month,
                        _selectedDate.day > 28 ? 28 : _selectedDate.day,
                      );
                    });
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Calendar Card View
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Weekday headers: M T W T F S S
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((day) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: isDark ? Colors.white38 : Colors.grey.shade500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),

              // Calendar Grid (42 cells)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 42,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 4,
                ),
                itemBuilder: (context, index) {
                  final date = gridDates[index];
                  final isSelected = DateUtils.isSameDay(date, _selectedDate);
                  final isCurrentMonth = date.month == _currentMonthDate.month;
                  
                  // Check if day has tasks and resolve priority highlight
                  final dayTasks = state.tasks.where((t) {
                    return t.time.year == date.year &&
                        t.time.month == date.month &&
                        t.time.day == date.day;
                  }).toList();

                  final hasHigh = dayTasks.any((t) => t.priority == 'High');
                  final hasMedium = dayTasks.any((t) => t.priority == 'Medium');
                  final hasLow = dayTasks.any((t) => t.priority == 'Low');

                  Widget cellChild;
                  BoxDecoration? decoration;
                  Color textColor = onSurface;

                  if (!isCurrentMonth) {
                    textColor = isDark ? Colors.white24 : Colors.grey.shade300;
                  }

                  if (isSelected) {
                    decoration = const BoxDecoration(
                      color: Color(0xFF6366F1),
                      shape: BoxShape.circle,
                    );
                    textColor = Colors.white;
                    
                    cellChild = Center(
                      child: Text(
                        date.day.toString(),
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          fontSize: 14,
                        ),
                      ),
                    );
                  } else if (hasHigh) {
                    // Light reddish background for High priority tasks
                    decoration = BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.red.shade100, width: 0.5),
                    );
                    textColor = const Color(0xFFEF4444);
                    cellChild = Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          date.day.toString(),
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEF4444),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    );
                  } else if (hasMedium) {
                    // Ring Outline for Medium priority tasks
                    decoration = BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.6),
                        width: 1.5,
                      ),
                    );
                    cellChild = Center(
                      child: Text(
                        date.day.toString(),
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          fontSize: 14,
                        ),
                      ),
                    );
                  } else if (hasLow) {
                    // Dot below date for Low priority tasks
                    cellChild = Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          date.day.toString(),
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: Color(0xFF6366F1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    );
                  } else {
                    cellChild = Center(
                      child: Text(
                        date.day.toString(),
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = date;
                        if (date.month != _currentMonthDate.month) {
                          _currentMonthDate = DateTime(date.year, date.month, 1);
                        }
                      });
                    },
                    child: Container(
                      decoration: decoration,
                      alignment: Alignment.center,
                      child: cellChild,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Today's Focus Title
        Text(
          'TODAY\'S FOCUS',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            fontSize: 11,
            color: isDark ? Colors.white38 : Colors.grey.shade500,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('EEEE, MMM d').format(_selectedDate),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: onSurface,
              ),
            ),
            Text(
              '${targetTasks.length} Sessions',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: const Color(0xFF6366F1),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Vertical Timeline schedule view
        if (targetTasks.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40),
            width: double.infinity,
            child: Center(
              child: Text(
                'No tasks scheduled for this day.',
                style: GoogleFonts.inter(
                  color: isDark ? Colors.white60 : Colors.grey.shade500,
                  fontSize: 14,
                ),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: targetTasks.length,
            itemBuilder: (context, index) {
              final task = targetTasks[index];
              final sub = state.subjects.firstWhere(
                (s) => s.id == task.subjectId,
              );
              final isFirst = index == 0;
              final isLast = index == targetTasks.length - 1;

              // priority-based styled tag
              String tagText = 'Study';
              Color tagBg = const Color(0xFFE5EEFF);
              Color tagFg = const Color(0xFF3B82F6);
              if (task.priority == 'High') {
                tagText = 'Deep Study';
                tagBg = const Color(0xFFEEF2FF);
                tagFg = const Color(0xFF6366F1);
              } else if (task.priority == 'Medium') {
                tagText = 'Review';
                tagBg = const Color(0xFFFDF2F8);
                tagFg = const Color(0xFFEC4899);
              }

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left timeline line & icon column
                    SizedBox(
                      width: 50,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Connecting vertical line
                          Positioned(
                            top: isFirst ? 25 : 0,
                            bottom: isLast ? 25 : 0,
                            child: Container(
                              width: 2,
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.1)
                                  : Colors.grey.shade200,
                            ),
                          ),
                          // Circular icon
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: sub.color.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              sub.icon,
                              color: sub.color,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Right task detail card
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TaskDetailScreen(taskId: task.id),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            border: Border.all(
                              color: isDark
                                  ? Colors.transparent
                                  : Colors.grey.shade100,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat('jm').format(task.time),
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF6366F1),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: tagBg,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      tagText,
                                      style: GoogleFonts.plusJakartaSans(
                                        color: tagFg,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                task.title,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: onSurface,
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              if (task.description.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  task.description,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: isDark
                                        ? Colors.white60
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  Color _getPriorityColor(String priority) {
    if (priority == 'High') return Colors.red;
    if (priority == 'Medium') return Colors.orange;
    return Colors.blue;
  }

  void _showAddTaskSheet(BuildContext context) {
    final state = context.read<StudyAppState>();
    final isDark = state.isDarkMode;
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final subtasksController = TextEditingController();
    
    String? selectedSubjectId = state.subjects.isNotEmpty ? state.subjects.first.id : null;
    String selectedPriority = 'Medium';
    DateTime selectedDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      DateTime.now().hour,
      DateTime.now().minute,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF213145) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create New Task',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0B1C30),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: selectedSubjectId,
                      dropdownColor: isDark ? const Color(0xFF213145) : Colors.white,
                      style: GoogleFonts.inter(
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Select Subject',
                        labelStyle: GoogleFonts.inter(color: Colors.grey),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF0B1C30) : const Color(0xFFF8F9FF),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: state.subjects.map((sub) {
                        return DropdownMenuItem<String>(
                          value: sub.id,
                          child: Text(sub.name),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setModalState(() {
                          selectedSubjectId = val;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: nameController,
                      style: GoogleFonts.inter(
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Task Title',
                        hintStyle: GoogleFonts.inter(color: Colors.grey),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF0B1C30) : const Color(0xFFF8F9FF),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descController,
                      style: GoogleFonts.inter(
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'Description (optional)',
                        hintStyle: GoogleFonts.inter(color: Colors.grey),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF0B1C30) : const Color(0xFFF8F9FF),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: subtasksController,
                      style: GoogleFonts.inter(
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Sub-tasks (comma separated, optional)',
                        hintStyle: GoogleFonts.inter(color: Colors.grey),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF0B1C30) : const Color(0xFFF8F9FF),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Priority',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF0B1C30),
                          ),
                        ),
                        Row(
                          children: ['Low', 'Medium', 'High'].map((p) {
                            final isSel = selectedPriority == p;
                            return GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  selectedPriority = p;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isSel
                                      ? const Color(0xFF6366F1)
                                      : (isDark ? const Color(0xFF0B1C30) : const Color(0xFFF8F9FF)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  p,
                                  style: GoogleFonts.inter(
                                    color: isSel ? Colors.white : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Time',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF0B1C30),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () async {
                            final TimeOfDay? tod = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(selectedDateTime),
                            );
                            if (tod != null) {
                              setModalState(() {
                                selectedDateTime = DateTime(
                                  selectedDateTime.year,
                                  selectedDateTime.month,
                                  selectedDateTime.day,
                                  tod.hour,
                                  tod.minute,
                                );
                              });
                            }
                          },
                          icon: const Icon(Icons.access_time, color: Color(0xFF6366F1)),
                          label: Text(
                            DateFormat('jm').format(selectedDateTime),
                            style: GoogleFonts.inter(
                              color: const Color(0xFF6366F1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          if (nameController.text.trim().isNotEmpty && selectedSubjectId != null) {
                            final subtaskInput = subtasksController.text;
                            final List<String> subList = subtaskInput
                                .split(',')
                                .map((s) => s.trim())
                                .where((s) => s.isNotEmpty)
                                .toList();

                            state.addTask(
                              selectedSubjectId!,
                              nameController.text.trim(),
                              descController.text.trim(),
                              selectedDateTime,
                              selectedPriority,
                              subList,
                            );
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Create Task',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
