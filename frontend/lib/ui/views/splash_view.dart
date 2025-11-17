// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/app/route_transitions.dart';
import 'package:frontend/core/services/auth_service.dart';
import '../widgets/animated_light_background.dart';
import 'login_view.dart';
import 'role_dashboard.dart';
import '../widgets/drop_icon.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();

    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeInOut);

    _scale = Tween<double>(
      begin: 0.88,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOutBack));

    Timer(const Duration(milliseconds: 2600), _checkAuth);
  }

  Future<void> _checkAuth() async {
    await AuthService.instance.init();
    if (!mounted) return;

    final user = AuthService.instance.currentUser;

    Navigator.pushReplacement(
      context,
      RouteTransitions.fade(
        user != null ? const RoleDashboard() : const LoginView(),
      ),
    );
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF4F7CFF);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          /// 🔥 Премиальный фон (не тёплый)
          const AnimatedLightBackground(isWarm: false),

          /// 💡 Мягкое свечение
          if (!kIsWeb)
            FadeTransition(
              opacity: _fade,
              child: Center(
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: blue.withOpacity(0.28),
                        blurRadius: 55,
                        spreadRadius: 22,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          /// 🔥 Капля + текст
          Center(
            child: FadeTransition(
              opacity: _fade,
              child: ScaleTransition(
                scale: _scale,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const DropIcon(size: 94, color: Colors.white),
                    const SizedBox(height: 18),

                    Text(
                      "DryClean",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: Colors.white.withOpacity(0.95),
                      ),
                    ),
                    const SizedBox(height: 22),

                    SizedBox(
                      width: 26,
                      height: 26,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: blue.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
