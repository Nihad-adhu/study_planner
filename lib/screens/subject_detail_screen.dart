import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../google_fonts.dart';
import 'package:intl/intl.dart';
import '../providers/app_state_provider.dart';
import 'task_detail_screen.dart';
import '../utils/edit_dialogs.dart';

class SubjectDetailScreen extends StatelessWidget {
  final String subjectId;

  const SubjectDetailScreen({super.key, required this.subjectId});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StudyAppState>();
    final isDark = state.isDarkMode;

    // Find subject
    final subject = state.subjects.firstWhere((s) => s.id == subjectId);
    final mastery = state.getSubjectMastery(subjectId);

    // Filter tasks
    final subTasks = state.tasks
        .where((t) => t.subjectId == subjectId)
        .toList();
    final completedCount = subTasks.where((t) => t.isCompleted).length;

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
          subject.name,
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
              if (val == 'edit') showEditSubjectSheet(context, subject);
              if (val == 'delete') {
                state.deleteSubject(subject.id);
                Navigator.pop(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit Subject')),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete Subject'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subject Tonal Banner Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: subject.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: subject.color.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: subject.color,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(subject.icon, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Subject Mastery',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: subject.color,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              '${(mastery * 100).toInt()}%',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF0B1C30),
                              ),
                            ),
                            Text(
                              ' / ${(subject.targetMastery * 100).toInt()}% Target',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: isDark
                                    ? Colors.white60
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: mastery,
                            minHeight: 6,
                            backgroundColor: isDark
                                ? Colors.white10
                                : Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              subject.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Tasks List Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Study Tasks',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0B1C30),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$completedCount of ${subTasks.length} tasks completed',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: isDark ? Colors.white60 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () => _showAddTaskSheet(context, state),
                  icon: Icon(Icons.add, color: subject.color, size: 18),
                  label: Text(
                    'Add Task',
                    style: GoogleFonts.plusJakartaSans(
                      color: subject.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tasks List
            if (subTasks.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF213145) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        color: Colors.grey.shade400,
                        size: 36,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No tasks created for this subject yet.',
                        style: GoogleFonts.inter(
                          color: isDark ? Colors.white60 : Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: subTasks.length,
                itemBuilder: (context, index) {
                  final task = subTasks[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF213145) : Colors.white,
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
                            builder: (_) => TaskDetailScreen(taskId: task.id),
                          ),
                        );
                      },
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      leading: Checkbox(
                        value: task.isCompleted,
                        activeColor: subject.color,
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
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0B1C30),
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 12,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DateFormat('MMM d, h:mm a').format(task.time),
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
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
                              color: isDark ? Colors.white54 : Colors.black45,
                              size: 20,
                            ),
                            padding: EdgeInsets.zero,
                            onSelected: (val) {
                              if (val == 'edit')
                                showEditTaskSheet(context, task);
                              if (val == 'delete') state.deleteTask(task.id);
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

  void _showAddTaskSheet(BuildContext context, StudyAppState state) {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final subtasksController = TextEditingController();
    String selectedPriority = 'Medium';
    DateTime selectedDate = DateTime.now().add(const Duration(hours: 2));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: state.isDarkMode
          ? const Color(0xFF213145)
          : Colors.white,
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add New Task',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: state.isDarkMode
                          ? Colors.white
                          : const Color(0xFF0B1C30),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    style: GoogleFonts.inter(
                      color: state.isDarkMode ? Colors.white : Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Task Title (e.g. Reaction Mechanisms)',
                      hintStyle: GoogleFonts.inter(color: Colors.grey),
                      filled: true,
                      fillColor: state.isDarkMode
                          ? const Color(0xFF0B1C30)
                          : const Color(0xFFF8F9FF),
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
                      color: state.isDarkMode ? Colors.white : Colors.black87,
                    ),
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Description (optional)',
                      hintStyle: GoogleFonts.inter(color: Colors.grey),
                      filled: true,
                      fillColor: state.isDarkMode
                          ? const Color(0xFF0B1C30)
                          : const Color(0xFFF8F9FF),
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
                      color: state.isDarkMode ? Colors.white : Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText:
                          'Sub-tasks (comma separated, e.g. Draw SN1, Practice SN2)',
                      hintStyle: GoogleFonts.inter(color: Colors.grey),
                      filled: true,
                      fillColor: state.isDarkMode
                          ? const Color(0xFF0B1C30)
                          : const Color(0xFFF8F9FF),
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
                          color: state.isDarkMode
                              ? Colors.white
                              : const Color(0xFF0B1C30),
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
                                    : (state.isDarkMode
                                          ? const Color(0xFF0B1C30)
                                          : const Color(0xFFF8F9FF)),
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
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        if (nameController.text.trim().isNotEmpty) {
                          // Parse comma subtasks
                          final subtaskInput = subtasksController.text;
                          final List<String> subList = subtaskInput
                              .split(',')
                              .map((s) => s.trim())
                              .where((s) => s.isNotEmpty)
                              .toList();

                          state.addTask(
                            subjectId,
                            nameController.text.trim(),
                            descController.text.trim(),
                            selectedDate,
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
            );
          },
        );
      },
    );
  }
}
