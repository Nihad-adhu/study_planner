import 'package:flutter/material.dart';
import 'dart:ui';
import '../google_fonts.dart';
import '../models/subject.dart';

class SubjectCard extends StatefulWidget {
  final Subject subject;
  final double mastery;
  final int totalTasks;
  final int completedTasks;
  final VoidCallback onTap;
  final bool isDark;

  const SubjectCard({
    super.key,
    required this.subject,
    required this.mastery,
    required this.totalTasks,
    required this.completedTasks,
    required this.onTap,
    required this.isDark,
  });

  @override
  State<SubjectCard> createState() => _SubjectCardState();
}

class _SubjectCardState extends State<SubjectCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = widget.subject.color;
    final onSurface =
        isDark ? Colors.white : const Color(0xFF0B1C30);

    return GestureDetector(
      onTapDown: (_) => _pressController.forward(),
      onTapUp: (_) {
        _pressController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _pressController.reverse(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      color.withValues(alpha: 0.18),
                      color.withValues(alpha: 0.06),
                    ]
                  : [
                      Colors.white,
                      color.withValues(alpha: 0.06),
                    ],
            ),
            border: Border.all(
              color: isDark
                  ? color.withValues(alpha: 0.25)
                  : color.withValues(alpha: 0.15),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: isDark ? 0.15 : 0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top row: icon + mastery ring
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Subject icon with gradient backdrop
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                color.withValues(alpha: 0.3),
                                color.withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            widget.subject.icon,
                            color: color,
                            size: 20,
                          ),
                        ),

                        // Mastery ring
                        SizedBox(
                          width: 36,
                          height: 36,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CircularProgressIndicator(
                                value: widget.mastery,
                                backgroundColor: isDark
                                    ? Colors.white10
                                    : Colors.grey.shade200,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(color),
                                strokeWidth: 3.0,
                                strokeCap: StrokeCap.round,
                              ),
                              Center(
                                child: Text(
                                  '${(widget.mastery * 100).toInt()}%',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Subject name
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.subject.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: onSurface,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Task count and completion
                    Text(
                      widget.totalTasks == 0
                          ? 'No tasks'
                          : '${widget.completedTasks}/${widget.totalTasks} tasks done',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white60 : Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Target mastery badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Target ${(widget.subject.targetMastery * 100).toInt()}%',
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
