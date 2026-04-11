import 'package:flutter/material.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/state/kinjuu_app_scope.dart';
import '../../../app/state/obligation_editor_args.dart';
import '../../../core/utils/display_formatters.dart';
import '../../../domain/entities/obligation.dart';
import '../../../domain/enums/obligation_status.dart';
import '../../../services/notifications/obligation_status_service_impl.dart';
import '../../../shared/widgets/kinjuu_app_scaffold.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = KinjuuAppScope.of(context);
    final obligations = controller.sortedObligations;
    final statusService = ObligationStatusServiceImpl();
    final sections = _buildSections(obligations, statusService);

    return KinjuuAppScaffold(
      currentRoute: AppRoutes.calendar,
      title: 'Calendar / Upcoming',
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
          ? _EmptyUpcomingState(onCreate: () {
              Navigator.of(context).pushNamed(AppRoutes.obligationEditor);
            })
          : ListView(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upcoming consistency',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'This view uses the same persisted obligation records and derived status logic as the dashboard, history, and reminder scheduling path.',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                for (final section in sections) ...[
                  _UpcomingSection(
                    title: section.title,
                    items: section.items,
                    onOpen: (obligation) {
                      Navigator.of(context).pushNamed(
                        AppRoutes.obligationEditor,
                        arguments:
                            ObligationEditorArgs(obligationId: obligation.id),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ],
            ),
    );
  }

  List<_UpcomingSectionData> _buildSections(
    List<Obligation> obligations,
    ObligationStatusServiceImpl statusService,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final nextWeek = today.add(const Duration(days: 7));

    final overdue = <Obligation>[];
    final dueToday = <Obligation>[];
    final nextSevenDays = <Obligation>[];
    final later = <Obligation>[];
    final settled = <Obligation>[];

    for (final obligation in obligations) {
      final status = statusService.deriveStatus(obligation, now: now);
      final dueDate = DateTime(
        obligation.dueDate.year,
        obligation.dueDate.month,
        obligation.dueDate.day,
      );

      switch (status) {
        case ObligationStatus.overdue:
          overdue.add(obligation);
          break;
        case ObligationStatus.dueToday:
          dueToday.add(obligation);
          break;
        case ObligationStatus.paid:
          settled.add(obligation);
          break;
        case ObligationStatus.pending:
        case ObligationStatus.upcoming:
          if (!dueDate.isAfter(nextWeek)) {
            nextSevenDays.add(obligation);
          } else {
            later.add(obligation);
          }
          break;
        case ObligationStatus.archived:
          break;
      }
    }

    return [
      if (overdue.isNotEmpty) _UpcomingSectionData('Overdue', overdue),
      if (dueToday.isNotEmpty) _UpcomingSectionData('Due today', dueToday),
      if (nextSevenDays.isNotEmpty)
        _UpcomingSectionData('Next 7 days', nextSevenDays),
      if (later.isNotEmpty) _UpcomingSectionData('Later upcoming', later),
      if (settled.isNotEmpty) _UpcomingSectionData('Settled', settled),
    ];
  }
}

class _EmptyUpcomingState extends StatelessWidget {
  const _EmptyUpcomingState({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_month_outlined,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                'No upcoming obligations yet.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              const Text(
                'Create an obligation to see due dates, overdue items, and upcoming reminders in one place.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onCreate,
                icon: const Icon(Icons.add),
                label: const Text('Create obligation'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UpcomingSection extends StatelessWidget {
  const _UpcomingSection({
    required this.title,
    required this.items,
    required this.onOpen,
  });

  final String title;
  final List<Obligation> items;
  final ValueChanged<Obligation> onOpen;

  @override
  Widget build(BuildContext context) {
    final statusService = ObligationStatusServiceImpl();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            for (final obligation in items) ...[
              ListTile(
                contentPadding: EdgeInsets.zero,
                onTap: () => onOpen(obligation),
                title: Text(obligation.title),
                subtitle: Text(
                  '${DisplayFormatters.titleCase(obligation.obligationType.storageValue)} • ${DisplayFormatters.formatDate(obligation.dueDate)}',
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(_statusLabel(statusService.deriveStatus(obligation))),
                    if (obligation.expectedAmount != null)
                      Text(
                        DisplayFormatters.formatAmount(
                          obligation.currencyCode,
                          obligation.expectedAmount!,
                        ),
                      ),
                  ],
                ),
              ),
              if (obligation != items.last) const Divider(height: 20),
            ],
          ],
        ),
      ),
    );
  }

  String _statusLabel(ObligationStatus status) {
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

class _UpcomingSectionData {
  const _UpcomingSectionData(this.title, this.items);

  final String title;
  final List<Obligation> items;
}
