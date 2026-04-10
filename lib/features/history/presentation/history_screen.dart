import 'package:flutter/material.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/state/kinjuu_app_scope.dart';
import '../../../shared/widgets/kinjuu_app_scaffold.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = KinjuuAppScope.of(context);

    return KinjuuAppScaffold(
      currentRoute: AppRoutes.history,
      title: 'History / Activity',
      child: controller.auditEntries.isEmpty
          ? const Center(child: Text('No activity yet.'))
          : ListView.separated(
              itemCount: controller.auditEntries.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final entry = controller.auditEntries[index];
                return Card(
                  child: ListTile(
                    title: Text(entry.summary),
                    subtitle: Text(
                      '${entry.entityType.storageValue} • ${entry.actionType.storageValue} • ${_formatDateTime(entry.createdAt)}',
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _formatDateTime(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '${date.year}-$month-$day $hour:$minute';
  }
}
