import 'package:flutter/material.dart';

import '../../../app/routes/app_routes.dart';
import '../../../shared/widgets/feature_placeholder_card.dart';
import '../../../shared/widgets/kinjuu_app_scaffold.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return KinjuuAppScaffold(
      currentRoute: AppRoutes.history,
      title: 'History / Activity',
      child: ListView(
        children: const [
          FeaturePlaceholderCard(
            title: 'Activity trail',
            description:
                'Audit and payment-event history will be displayed here once repository and status flows arrive in later passes.',
            icon: Icons.history_outlined,
          ),
          SizedBox(height: 12),
          FeaturePlaceholderCard(
            title: 'Recent changes',
            description:
                'Expected entries include create, edit, archive, and paid/pending status changes for manual obligations.',
            icon: Icons.event_note_outlined,
          ),
        ],
      ),
    );
  }
}

