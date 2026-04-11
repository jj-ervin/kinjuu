import 'package:flutter/material.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/state/kinjuu_app_scope.dart';
import '../../../core/utils/display_formatters.dart';
import '../../../services/notifications/obligation_status_service_impl.dart';
import '../../../shared/widgets/kinjuu_app_scaffold.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = KinjuuAppScope.of(context);
    final statusService = ObligationStatusServiceImpl();

    return KinjuuAppScaffold(
      currentRoute: AppRoutes.dashboard,
      title: 'Dashboard',
      actions: [
        IconButton(
          tooltip: 'Add obligation',
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.obligationEditor);
          },
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
      child: ListView(
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _SummaryCard(label: 'Due today', value: controller.dueTodayCount),
              _SummaryCard(label: 'Overdue', value: controller.overdueCount),
              _SummaryCard(label: 'Upcoming', value: controller.upcomingCount),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Next obligations',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  if (controller.dashboardObligations.isEmpty)
                    const Text('No obligations created yet.')
                  else
                    for (final obligation
                        in controller.dashboardObligations) ...[
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(obligation.title),
                        subtitle: Text(
                          '${_formatDate(obligation.dueDate)} • ${_labelForStatus(statusService.deriveStatus(obligation))}',
                        ),
                      ),
                      if (obligation != controller.dashboardObligations.last)
                        const Divider(),
                    ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _QuickLink(
                label: 'Obligations',
                icon: Icons.receipt_long_outlined,
                routeName: AppRoutes.obligations,
              ),
              _QuickLink(
                label: 'Accounts & Cards',
                icon: Icons.credit_card_outlined,
                routeName: AppRoutes.accountsCards,
              ),
              _QuickLink(
                label: 'History',
                icon: Icons.history_outlined,
                routeName: AppRoutes.history,
              ),
              _QuickLink(
                label: 'Calendar',
                icon: Icons.calendar_month_outlined,
                routeName: AppRoutes.calendar,
              ),
              _QuickLink(
                label: 'Settings',
                icon: Icons.settings_outlined,
                routeName: AppRoutes.settings,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DisplayFormatters.formatDate(date);
  }

  String _labelForStatus(Enum status) =>
      status.name.replaceAll('_', ' ').replaceFirstMapped(
            RegExp(r'^[a-z]'),
            (match) => match.group(0)!.toUpperCase(),
          );
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label),
              const SizedBox(height: 8),
              Text(
                '$value',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickLink extends StatelessWidget {
  const _QuickLink({
    required this.label,
    required this.icon,
    required this.routeName,
  });

  final String label;
  final IconData icon;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 156,
      child: FilledButton.tonalIcon(
        onPressed: () => Navigator.of(context).pushNamed(routeName),
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}
