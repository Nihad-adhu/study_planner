import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../google_fonts.dart';

class AnimatedUserName extends StatefulWidget {
  final String userName;
  final bool isDark;

  const AnimatedUserName({
    super.key,
    required this.userName,
    required this.isDark,
  });

  @override
  State<AnimatedUserName> createState() => _AnimatedUserNameState();
}

class _AnimatedUserNameState extends State<AnimatedUserName> with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _waveController;
  late Animation<double> _welcomeFade;
  late Animation<Offset> _welcomeSlide;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _welcomeFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _welcomeSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOutCubic),
      ),
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String formattedName = widget.userName.toUpperCase();
    final chars = formattedName.split('');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Make it left-aligned like normal text
        children: [
          // "WELCOME" Line
          FadeTransition(
            opacity: _welcomeFade,
            child: SlideTransition(
              position: _welcomeSlide,
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFEC4899)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  'WELCOME',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20, // Adjusted size
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ),
          if (chars.isNotEmpty && widget.userName.isNotEmpty) const SizedBox(height: 4),
          // Animated Name Line (if any)
          if (chars.isNotEmpty && widget.userName.isNotEmpty)
            Wrap(
              spacing: 1.0,
              children: List.generate(chars.length, (index) {
                final start = (index * 0.05).clamp(0.0, 1.0);
                final end = (start + 0.3).clamp(0.0, 1.0);
                
                final letterEntrance = CurvedAnimation(
                  parent: _entranceController,
                  curve: Interval(start, end, curve: Curves.easeOutCubic),
                );
                
                final fade = Tween<double>(begin: 0.0, end: 1.0).animate(letterEntrance);
                final slide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(letterEntrance);

                return FadeTransition(
                  opacity: fade,
                  child: SlideTransition(
                    position: slide,
                    child: AnimatedBuilder(
                      animation: _waveController,
                      builder: (context, child) {
                        final waveOffset = math.sin((_waveController.value * 2 * math.pi) - (index * 0.4)) * 2.0; // Reduced wave height
                        return Transform.translate(
                          offset: Offset(0, waveOffset),
                          child: child,
                        );
                      },
                      child: Text(
                        chars[index] == ' ' ? '\u00A0' : chars[index],
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20, // Adjusted size
                          fontWeight: FontWeight.w900,
                          color: widget.isDark ? Colors.white : const Color(0xFF0B1C30),
                          letterSpacing: 1,
                          shadows: [
                            Shadow(
                              color: widget.isDark ? Colors.black54 : Colors.grey.withValues(alpha: 0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }
}
