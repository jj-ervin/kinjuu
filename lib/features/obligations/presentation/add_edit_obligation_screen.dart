import 'package:flutter/material.dart';

import '../../../app/routes/app_routes.dart';
import '../../../shared/widgets/kinjuu_app_scaffold.dart';

class AddEditObligationScreen extends StatelessWidget {
  const AddEditObligationScreen({super.key, this.titleOverride});

  final String? titleOverride;

  @override
  Widget build(BuildContext context) {
    return KinjuuAppScaffold(
      currentRoute: AppRoutes.obligationEditor,
      title: titleOverride ?? 'Add / Edit Obligation',
      child: ListView(
        children: [
          Text(
            'Placeholder form scaffold',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'This pass only creates the shell for the manual obligation form. Field models, validation, and persistence are deferred.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          const _DisabledField(label: 'Title'),
          const SizedBox(height: 12),
          const _DisabledField(label: 'Due date'),
          const SizedBox(height: 12),
          const _DisabledField(label: 'Recurrence'),
          const SizedBox(height: 12),
          const _DisabledField(label: 'Expected amount'),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: null,
            child: const Text('Save coming in a later pass'),
          ),
        ],
      ),
    );
  }
}

class _DisabledField extends StatelessWidget {
  const _DisabledField({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: false,
      decoration: InputDecoration(
        labelText: label,
        helperText: 'Scaffold-only field placeholder',
      ),
    );
  }
}

