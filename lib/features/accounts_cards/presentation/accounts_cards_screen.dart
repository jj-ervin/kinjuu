import 'package:flutter/material.dart';

import '../../../app/routes/app_routes.dart';
import '../../../shared/widgets/feature_placeholder_card.dart';
import '../../../shared/widgets/kinjuu_app_scaffold.dart';

class AccountsCardsScreen extends StatelessWidget {
  const AccountsCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return KinjuuAppScaffold(
      currentRoute: AppRoutes.accountsCards,
      title: 'Accounts & Cards',
      child: ListView(
        children: const [
          FeaturePlaceholderCard(
            title: 'Manual references only',
            description:
                'Account and card reference management will be manual-only for the MVP, with masked references and no prohibited sensitive data.',
            icon: Icons.credit_card_outlined,
          ),
          SizedBox(height: 12),
          FeaturePlaceholderCard(
            title: 'Future CRUD location',
            description:
                'Create, edit, archive, and link account/card references here in a later pass.',
            icon: Icons.account_balance_wallet_outlined,
          ),
        ],
      ),
    );
  }
}

