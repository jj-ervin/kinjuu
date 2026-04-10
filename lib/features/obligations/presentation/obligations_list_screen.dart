import 'package:flutter/material.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/state/kinjuu_app_scope.dart';
import '../../../app/state/obligation_editor_args.dart';
import '../../../domain/enums/obligation_status.dart';
import '../../../services/notifications/obligation_status_service_impl.dart';
import '../../../shared/widgets/kinjuu_app_scaffold.dart';

class ObligationsListScreen extends StatelessWidget {
  const ObligationsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = KinjuuAppScope.of(context);
    final obligations = controller.obligations;
    final statusService = ObligationStatusServiceImpl();

    return KinjuuAppScaffold(
      currentRoute: AppRoutes.obligations,
      title: 'Obligations',
      actions: [
        IconButton(
          tooltip: 'Add obligation',
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.obligationEditor);
          },
          icon: const Icon(Icons.add),
        ),
      ],
      child: obligations.isEmpty
          ? const Center(
              child: Text('No obligations yet. Create one to start the MVP loop.'),
            )
          : ListView.separated(
              itemCount: obligations.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final obligation = obligations[index];
                final derived = statusService.deriveStatus(obligation);
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    obligation.title,
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${obligation.obligationType.storageValue} • due ${_formatDate(obligation.dueDate)}',
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      Chip(label: Text(_labelForStatus(derived))),
                                      if (obligation.expectedAmount != null)
                                        Chip(
                                          label: Text(
                                            '${obligation.currencyCode} ${obligation.expectedAmount!.toStringAsFixed(2)}',
                                          ),
                                        ),
                                      if (obligation.category.isNotEmpty)
                                        Chip(label: Text(obligation.category)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) async {
                                if (value == 'edit') {
                                  Navigator.of(context).pushNamed(
                                    AppRoutes.obligationEditor,
                                    arguments: ObligationEditorArgs(
                                      obligationId: obligation.id,
                                    ),
                                  );
                                  return;
                                }

                                if (value == 'paid') {
                                  await controller.markObligationPaid(obligation.id);
                                  return;
                                }

                                if (value == 'pending') {
                                  await controller.markObligationPending(
                                    obligation.id,
                                  );
                                  return;
                                }

                                if (value == 'archive') {
                                  await controller.archiveObligation(obligation.id);
                                }
                              },
                              itemBuilder: (context) => const [
                                PopupMenuItem(value: 'edit', child: Text('Edit')),
                                PopupMenuItem(
                                  value: 'paid',
                                  child: Text('Mark paid'),
                                ),
                                PopupMenuItem(
                                  value: 'pending',
                                  child: Text('Mark pending'),
                                ),
                                PopupMenuItem(
                                  value: 'archive',
                                  child: Text('Archive'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (obligation.notes.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(obligation.notes),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  String _labelForStatus(ObligationStatus status) {
    switch (status) {
      case ObligationStatus.dueToday:
        return 'Due today';
      case ObligationStatus.overdue:
        return 'Overdue';
      case ObligationStatus.pending:
        return 'Pending';
      case ObligationStatus.paid:
        return 'Paid';
      case ObligationStatus.archived:
        return 'Archived';
      case ObligationStatus.upcoming:
        return 'Upcoming';
    }
  }
}
