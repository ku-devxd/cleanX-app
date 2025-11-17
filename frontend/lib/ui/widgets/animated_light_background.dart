// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AnimatedLightBackground extends StatefulWidget {
  final bool isWarm; // 🔥 чтобы менять стиль (оранжевый или холодный синий)
  final Duration duration;

  const AnimatedLightBackground({
    super.key,
    this.isWarm = false,
    this.duration = const Duration(seconds: 14),
  });

  @override
  State<AnimatedLightBackground> createState() =>
      _AnimatedLightBackgroundState();
}

class _AnimatedLightBackgroundState extends State<AnimatedLightBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color mainColor = widget.isWarm
        ? Colors.orangeAccent
        : const Color(0xFF4F7CFF);

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final t = _ctrl.value;

        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.2 + t * 0.1),
              radius: kIsWeb ? 1.1 : 1.5,
              colors: [
                mainColor.withOpacity(
                  isDark ? 0.14 + t * 0.06 : 0.08 + t * 0.04,
                ),
                isDark ? Colors.black : Colors.white,
              ],
            ),
          ),
        );
      },
    );
  }
}
