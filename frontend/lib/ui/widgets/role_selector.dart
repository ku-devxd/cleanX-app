// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class RoleSelector extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;
  const RoleSelector({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final roles = <String, String>{
      'client': 'Клиент',
      'manager': 'Менеджер',
      'staff': 'Сотрудник',
      'driver': 'Водитель',
      'boss': 'Начальник',
    };
    return Row(
      children: [
        const Icon(Icons.group, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: value,
            items: roles.entries
                .map(
                  (e) => DropdownMenuItem(value: e.key, child: Text(e.value)),
                )
                .toList(),
            onChanged: onChanged,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
