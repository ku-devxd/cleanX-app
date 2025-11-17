// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/core/services/auth_service.dart';
import 'package:frontend/app/route_transitions.dart';
import '../widgets/auth_input.dart';
import '../widgets/primary_button.dart';
import '../widgets/role_selector.dart';
import '../widgets/animated_light_background.dart';
import 'role_dashboard.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final pass2Ctrl = TextEditingController();

  String role = "client";
  bool loading = false;

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    pass2Ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          AnimatedLightBackground(isWarm: false),

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
                    'Регистрация',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),

                  AuthInput(hint: 'Имя', controller: nameCtrl),
                  const SizedBox(height: 12),

                  AuthInput(hint: 'Email', controller: emailCtrl),
                  const SizedBox(height: 12),

                  AuthInput(
                    hint: 'Пароль',
                    obscure: true,
                    controller: passCtrl,
                  ),
                  const SizedBox(height: 12),

                  AuthInput(
                    hint: 'Повторите пароль',
                    obscure: true,
                    controller: pass2Ctrl,
                  ),
                  const SizedBox(height: 16),

                  RoleSelector(
                    value: role,
                    onChanged: (v) => setState(() => role = v ?? 'client'),
                  ),

                  const SizedBox(height: 20),

                  PrimaryButton(
                    label: loading ? 'Создание...' : 'Создать аккаунт',
                    onTap: loading
                        ? null
                        : () async {
                            if (passCtrl.text != pass2Ctrl.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Пароли не совпадают"),
                                ),
                              );
                              return;
                            }

                            setState(() => loading = true);
                            try {
                              await AuthService.instance.register(
                                name: nameCtrl.text,
                                email: emailCtrl.text,
                                password: passCtrl.text,
                                role: role,
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
                    label: 'Назад',
                    outline: true,
                    onTap: () => Navigator.pop(context),
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
