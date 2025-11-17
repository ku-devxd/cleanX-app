// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';

class RouteTransitions {
  // простой Fade
  static Route<T> fade<T>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 350),
  }) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) =>
          FadeTransition(opacity: anim, child: child),
    );
  }

  // scale + fade (вход масштабом + появление)
  static Route<T> scaleFade<T>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 420),
  }) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) {
        final fade = CurvedAnimation(parent: anim, curve: Curves.easeInOut);
        final scale = Tween<double>(
          begin: 0.92,
          end: 1.0,
        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutBack));
        return FadeTransition(
          opacity: fade,
          child: ScaleTransition(scale: scale, child: child),
        );
      },
    );
  }

  // fade + slight scale out on reverse (used for splash -> main)
  static Route<T> fadeScale<T>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 380),
  }) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) {
        final curved = CurvedAnimation(parent: anim, curve: Curves.easeInOut);
        final scale = Tween<double>(begin: 0.98, end: 1.0).animate(curved);
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(scale: scale, child: child),
        );
      },
    );
  }

  // slide up + fade (для открытия модалки/регистрации)
  static Route<T> slideUpFade<T>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 360),
  }) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) {
        final offset = Tween<Offset>(
          begin: const Offset(0, 0.14),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut));
        return FadeTransition(
          opacity: anim,
          child: SlideTransition(position: offset, child: child),
        );
      },
    );
  }

  // slide down + fade (для выхода)
  static Route<T> slideDownFade<T>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 320),
  }) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) {
        final offset = Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0, 0.18),
        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeIn));
        return FadeTransition(
          opacity: ReverseAnimation(anim),
          child: SlideTransition(position: offset, child: child),
        );
      },
    );
  }

  // slide left/right generic
  static Route<T> slide<T>(
    Widget page, {
    bool fromRight = true,
    Duration duration = const Duration(milliseconds: 340),
  }) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) {
        final begin = fromRight ? const Offset(1.0, 0) : const Offset(-1.0, 0);
        final offset = Tween<Offset>(
          begin: begin,
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut));
        return SlideTransition(position: offset, child: child);
      },
    );
  }
}
