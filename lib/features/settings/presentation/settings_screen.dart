import 'package:flutter/material.dart';

import '../../../app/routes/app_routes.dart';
import '../../../shared/widgets/feature_placeholder_card.dart';
import '../../../shared/widgets/kinjuu_app_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return KinjuuAppScaffold(
      currentRoute: AppRoutes.settings,
      title: 'Settings',
      child: ListView(
        children: const [
          FeaturePlaceholderCard(
            title: 'Notification preferences',
            description:
                'Global reminder defaults, privacy-safe notification content, and quiet-hours settings are reserved for later passes.',
            icon: Icons.notifications_none_outlined,
          ),
          SizedBox(height: 12),
          FeaturePlaceholderCard(
            title: 'Security surfaces',
            description:
                'App lock, biometric support, export, and deletion are intentionally represented as future settings surfaces only.',
            icon: Icons.lock_outline,
          ),
        ],
      ),
    );
  }
}

