import 'package:flutter/material.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/state/kinjuu_app_scope.dart';
import '../../../core/utils/display_formatters.dart';
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
          ? const Center(
              child: Text(
                'No activity yet. Create or update an obligation to start the history trail.',
              ),
            )
          : ListView.separated(
              itemCount: controller.auditEntries.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final entry = controller.auditEntries[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(entry.summary),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Chip(
                              label: Text(
                                DisplayFormatters.titleCase(
                                  entry.entityType.storageValue,
                                ),
                              ),
                            ),
                            Chip(
                              label: Text(
                                DisplayFormatters.titleCase(
                                  entry.actionType.storageValue,
                                ),
                              ),
                            ),
                            Chip(
                              label: Text(
                                DisplayFormatters.formatDateTime(
                                    entry.createdAt),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
