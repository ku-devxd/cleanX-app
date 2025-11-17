// ignore_for_file: unused_local_variable, deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/core/services/auth_service.dart';
import 'package:frontend/app/route_transitions.dart';
import '../widgets/auth_input.dart';
import '../widgets/primary_button.dart';
import '../widgets/animated_light_background.dart';
import 'register_view.dart';
import 'role_dashboard.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          /// 🔥 Премиальный фон (свет / тьма)
          AnimatedLightBackground(isWarm: false),

          /// 🧊 Контент
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420),
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                color: isDark
                    ? Colors.black.withOpacity(0.55)
                    : Colors.white.withOpacity(0.65),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.08)
                      : Colors.black.withOpacity(0.08),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Вход',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),

                  AuthInput(hint: 'Email', controller: emailCtrl),
                  const SizedBox(height: 12),

                  AuthInput(
                    hint: 'Пароль',
                    controller: passCtrl,
                    obscure: true,
                  ),
                  const SizedBox(height: 20),

                  PrimaryButton(
                    label: loading ? 'Входим...' : 'Войти',
                    onTap: loading
                        ? null
                        : () async {
                            setState(() => loading = true);

                            try {
                              final user = await AuthService.instance.login(
                                emailCtrl.text.trim(),
                                passCtrl.text.trim(),
                              );

                              if (!mounted) return;

                              Navigator.pushReplacement(
                                context,
                                RouteTransitions.fade(const RoleDashboard()),
                              );
                            } catch (e) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            } finally {
                              if (mounted) {
                                setState(() => loading = false);
                              }
                            }
                          },
                  ),

                  const SizedBox(height: 14),

                  PrimaryButton(
                    label: 'Регистрация',
                    outline: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        RouteTransitions.scaleFade(const RegisterView()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
