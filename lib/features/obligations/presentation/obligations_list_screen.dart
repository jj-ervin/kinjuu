import 'package:flutter/material.dart';

import '../../../app/routes/app_routes.dart';
import '../../../shared/widgets/feature_placeholder_card.dart';
import '../../../shared/widgets/kinjuu_app_scaffold.dart';

class ObligationsListScreen extends StatelessWidget {
  const ObligationsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      child: ListView(
        children: const [
          FeaturePlaceholderCard(
            title: 'Obligations list',
            description:
                'This screen is reserved for manual obligation browsing, filtering, and status actions in later passes.',
            icon: Icons.receipt_long_outlined,
          ),
          SizedBox(height: 12),
          FeaturePlaceholderCard(
            title: 'MVP boundary',
            description:
                'No bank connectivity, budgeting, or payment actions are included in this scaffold.',
            icon: Icons.rule_folder_outlined,
          ),
        ],
      ),
    );
  }
}

