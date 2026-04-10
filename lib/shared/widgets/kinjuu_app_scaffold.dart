import 'package:flutter/material.dart';

import '../../app/routes/app_routes.dart';
import '../../core/constants/app_strings.dart';

class KinjuuAppScaffold extends StatelessWidget {
  const KinjuuAppScaffold({
    required this.currentRoute,
    required this.title,
    required this.child,
    super.key,
    this.actions,
  });

  final String currentRoute;
  final String title;
  final Widget child;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            Text(
              AppStrings.appTagline,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
        actions: actions,
      ),
      drawer: _AppDrawer(currentRoute: currentRoute),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: child,
        ),
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer({required this.currentRoute});

  final String currentRoute;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            ListTile(
              title: Text(
                AppStrings.appName,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              subtitle: const Text('Core MVP scaffold'),
            ),
            const Divider(),
            _DrawerDestination(
              label: 'Dashboard',
              icon: Icons.dashboard_outlined,
              routeName: AppRoutes.dashboard,
              currentRoute: currentRoute,
            ),
            _DrawerDestination(
              label: 'Obligations',
              icon: Icons.receipt_long_outlined,
              routeName: AppRoutes.obligations,
              currentRoute: currentRoute,
            ),
            _DrawerDestination(
              label: 'Add / Edit Obligation',
              icon: Icons.edit_note_outlined,
              routeName: AppRoutes.obligationEditor,
              currentRoute: currentRoute,
            ),
            _DrawerDestination(
              label: 'Accounts & Cards',
              icon: Icons.credit_card_outlined,
              routeName: AppRoutes.accountsCards,
              currentRoute: currentRoute,
            ),
            _DrawerDestination(
              label: 'Calendar / Upcoming',
              icon: Icons.calendar_month_outlined,
              routeName: AppRoutes.calendar,
              currentRoute: currentRoute,
            ),
            _DrawerDestination(
              label: 'History / Activity',
              icon: Icons.history_outlined,
              routeName: AppRoutes.history,
              currentRoute: currentRoute,
            ),
            _DrawerDestination(
              label: 'Settings',
              icon: Icons.settings_outlined,
              routeName: AppRoutes.settings,
              currentRoute: currentRoute,
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerDestination extends StatelessWidget {
  const _DrawerDestination({
    required this.label,
    required this.icon,
    required this.routeName,
    required this.currentRoute,
  });

  final String label;
  final IconData icon;
  final String routeName;
  final String currentRoute;

  @override
  Widget build(BuildContext context) {
    final selected = currentRoute == routeName;

    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected: selected,
      onTap: () {
        Navigator.of(context).pop();

        if (!selected) {
          Navigator.of(context).pushReplacementNamed(routeName);
        }
      },
    );
  }
}

