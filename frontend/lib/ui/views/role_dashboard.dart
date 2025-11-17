import 'package:flutter/material.dart';
import 'package:frontend/core/services/auth_service.dart';

class RoleDashboard extends StatelessWidget {
  const RoleDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    final role = user?.role ?? 'guest';

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard — ${role.toUpperCase()}'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Привет, ${user?.name ?? 'User'}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text('Ваша роль: $role'),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () async {
                await AuthService.instance.logout();
                if (!context.mounted) return;
                Navigator.of(context).pushReplacementNamed('/');
              },
              child: const Text('Выйти'),
            ),
          ],
        ),
      ),
    );
  }
}
