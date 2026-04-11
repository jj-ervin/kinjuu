import 'package:flutter/material.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/state/kinjuu_app_scope.dart';
import '../../../app/state/obligation_editor_args.dart';
import '../../../core/utils/display_formatters.dart';
import '../../../domain/enums/obligation_status.dart';
import '../../../services/notifications/obligation_status_service_impl.dart';
import '../../../shared/widgets/kinjuu_app_scaffold.dart';

class ObligationsListScreen extends StatelessWidget {
  const ObligationsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = KinjuuAppScope.of(context);
    final obligations = controller.sortedObligations;
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
              child:
                  Text('No obligations yet. Create one to start the MVP loop.'),
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
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${DisplayFormatters.titleCase(obligation.obligationType.storageValue)} • due ${DisplayFormatters.formatDate(obligation.dueDate)}',
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      Chip(
                                          label:
                                              Text(_labelForStatus(derived))),
                                      if (obligation.expectedAmount != null)
                                        Chip(
                                          label: Text(
                                            DisplayFormatters.formatAmount(
                                              obligation.currencyCode,
                                              obligation.expectedAmount!,
                                            ),
                                          ),
                                        ),
                                      if (obligation.category.isNotEmpty)
                                        Chip(label: Text(obligation.category)),
                                      if (obligation.autopayExpected)
                                        const Chip(
                                            label: Text('Autopay expected')),
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
                                  await _runActionWithFeedback(
                                    context,
                                    successMessage:
                                        'Marked ${obligation.title} as paid.',
                                    action: () => controller.markObligationPaid(
                                      obligation.id,
                                    ),
                                  );
                                  return;
                                }

                                if (value == 'pending') {
                                  await _runActionWithFeedback(
                                    context,
                                    successMessage:
                                        'Marked ${obligation.title} as pending.',
                                    action: () =>
                                        controller.markObligationPending(
                                      obligation.id,
                                    ),
                                  );
                                  return;
                                }

                                if (value == 'archive') {
                                  final confirmed = await _confirmAction(
                                    context,
                                    title: 'Archive obligation?',
                                    message:
                                        'Archived obligations are removed from the active MVP views and reminder scheduling.',
                                  );
                                  if (!confirmed) {
                                    return;
                                  }
                                  if (!context.mounted) {
                                    return;
                                  }
                                  await _runActionWithFeedback(
                                    context,
                                    successMessage:
                                        'Archived ${obligation.title}.',
                                    action: () => controller.archiveObligation(
                                      obligation.id,
                                    ),
                                  );
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                if (derived != ObligationStatus.paid)
                                  const PopupMenuItem(
                                    value: 'paid',
                                    child: Text('Mark paid'),
                                  ),
                                if (derived != ObligationStatus.pending)
                                  const PopupMenuItem(
                                    value: 'pending',
                                    child: Text('Mark pending'),
                                  ),
                                const PopupMenuItem(
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

  Future<void> _runActionWithFeedback(
    BuildContext context, {
    required Future<void> Function() action,
    required String successMessage,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await action();
      if (!context.mounted) {
        return;
      }
      messenger.showSnackBar(SnackBar(content: Text(successMessage)));
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      messenger.showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Future<bool> _confirmAction(
    BuildContext context, {
    required String title,
    required String message,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
    return result ?? false;
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
