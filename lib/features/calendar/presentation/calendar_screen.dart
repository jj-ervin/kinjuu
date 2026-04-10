import 'package:flutter/material.dart';

import '../../../app/routes/app_routes.dart';
import '../../../shared/widgets/feature_placeholder_card.dart';
import '../../../shared/widgets/kinjuu_app_scaffold.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return KinjuuAppScaffold(
      currentRoute: AppRoutes.calendar,
      title: 'Calendar / Upcoming',
      child: ListView(
        children: const [
          FeaturePlaceholderCard(
            title: 'Upcoming schedule view',
            description:
                'Calendar and upcoming obligation groupings will be wired here after the data foundation is in place.',
            icon: Icons.calendar_month_outlined,
          ),
          SizedBox(height: 12),
          FeaturePlaceholderCard(
            title: 'Reminder-friendly layout',
            description:
                'This screen will surface due soon, due today, and overdue perspectives without expanding into budgeting.',
            icon: Icons.notifications_active_outlined,
          ),
        ],
      ),
    );
  }
}

