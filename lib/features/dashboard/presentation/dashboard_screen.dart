import 'package:flutter/material.dart';

import '../../../app/routes/app_routes.dart';
import '../../../shared/widgets/feature_placeholder_card.dart';
import '../../../shared/widgets/kinjuu_app_scaffold.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          FeaturePlaceholderCard(
            title: 'Due soon',
            description:
                'Dashboard summary cards and upcoming obligation snapshots land here in a later pass.',
            icon: Icons.schedule_outlined,
          ),
          const SizedBox(height: 12),
          FeaturePlaceholderCard(
            title: 'Quick navigation',
            description:
                'Use the drawer to move between the required MVP sections while the scaffold is still placeholder-based.',
            icon: Icons.dashboard_customize_outlined,
          ),
          const SizedBox(height: 12),
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
                label: 'Calendar',
                icon: Icons.calendar_month_outlined,
                routeName: AppRoutes.calendar,
              ),
              _QuickLink(
                label: 'History',
                icon: Icons.history_outlined,
                routeName: AppRoutes.history,
              ),
            ],
          ),
        ],
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

