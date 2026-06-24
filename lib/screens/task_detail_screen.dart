import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../google_fonts.dart';
import 'package:intl/intl.dart';
import '../providers/app_state_provider.dart';
import 'focus_timer_screen.dart';
import '../utils/edit_dialogs.dart';

class TaskDetailScreen extends StatelessWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StudyAppState>();
    final isDark = state.isDarkMode;

    // Find task
    final taskIndex = state.tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex == -1) {
      return Scaffold(
        body: Center(
          child: Text(
            'Task not found',
            style: GoogleFonts.inter(color: Colors.red),
          ),
        ),
      );
    }

    final task = state.tasks[taskIndex];
    final subject = state.subjects.firstWhere((s) => s.id == task.subjectId);
    final progress = task.progress;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0B1C30)
          : const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : const Color(0xFF0B1C30),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Task Details',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF0B1C30),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: isDark ? Colors.white : const Color(0xFF0B1C30),
            ),
            onSelected: (val) {
              if (val == 'edit') showEditTaskSheet(context, task);
              if (val == 'delete') {
                state.deleteTask(task.id);
                Navigator.pop(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit Task')),
              const PopupMenuItem(value: 'delete', child: Text('Delete Task')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subject Tag & Priority Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: subject.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(subject.icon, color: subject.color, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        subject.name,
                        style: GoogleFonts.plusJakartaSans(
                          color: subject.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(
                      task.priority,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${task.priority} Priority',
                    style: GoogleFonts.plusJakartaSans(
                      color: _getPriorityColor(task.priority),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Task Title
            Text(
              task.title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0B1C30),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),

            // Due Date
            Row(
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  size: 16,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(width: 6),
                Text(
                  'Due: ${DateFormat('EEEE, MMMM d, h:mm a').format(task.time)}',
                  style: GoogleFonts.inter(
                    color: isDark ? Colors.white60 : Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Description Box
            if (task.description.isNotEmpty) ...[
              Text(
                'Description',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: isDark ? Colors.white : const Color(0xFF0B1C30),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF213145) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? Colors.transparent : Colors.grey.shade100,
                  ),
                ),
                child: Text(
                  task.description,
                  style: GoogleFonts.inter(
                    color: isDark ? Colors.white70 : const Color(0xFF464554),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 28),
            ],

            // Progress Bar / Checklist title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Checklist & Sub-tasks',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? Colors.white : const Color(0xFF0B1C30),
                  ),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: subject.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: isDark ? Colors.white10 : Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(subject.color),
              ),
            ),
            const SizedBox(height: 20),

            // Sub-tasks List
            if (task.subTasks.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'No sub-tasks. You can achieve this in one go!',
                    style: GoogleFonts.inter(color: Colors.grey),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: task.subTasks.length,
                itemBuilder: (context, index) {
                  final sub = task.subTasks[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF213145) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: CheckboxListTile(
                      value: sub.isCompleted,
                      activeColor: subject.color,
                      title: Text(
                        sub.title,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0B1C30),
                          decoration: sub.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      secondary: PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert,
                          color: isDark ? Colors.white54 : Colors.black45,
                          size: 20,
                        ),
                        padding: EdgeInsets.zero,
                        onSelected: (val) {
                          if (val == 'edit')
                            showEditSubTaskDialog(context, task, sub);
                          if (val == 'delete')
                            state.deleteSubTask(task.id, sub.id);
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      checkboxShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (val) {
                        state.toggleSubTaskCompletion(task.id, sub.id);
                      },
                    ),
                  );
                },
              ),
            const SizedBox(height: 40),

            // Focus Mode Action Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FocusTimerScreen(taskId: task.id),
                    ),
                  );
                },
                icon: const Icon(Icons.timer_outlined, color: Colors.white),
                label: Text(
                  'Start Deep Focus Session',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: subject.color,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    if (priority == 'High') return Colors.red;
    if (priority == 'Medium') return Colors.orange;
    return Colors.blue;
  }
}
