// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/state/kinjuu_app_scope.dart';
import '../../../core/utils/display_formatters.dart';
import '../../../domain/entities/account.dart';
import '../../../domain/entities/tracked_card.dart';
import '../../../domain/enums/account_type.dart';
import '../../../domain/enums/card_type.dart';
import '../../../shared/widgets/kinjuu_app_scaffold.dart';

class AccountsCardsScreen extends StatelessWidget {
  const AccountsCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = KinjuuAppScope.of(context);

    return KinjuuAppScaffold(
      currentRoute: AppRoutes.accountsCards,
      title: 'Accounts & Cards',
      child: ListView(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Manual references only',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              FilledButton.tonalIcon(
                onPressed: () => _showAccountDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Account'),
              ),
              const SizedBox(width: 8),
              FilledButton.tonalIcon(
                onPressed: () => _showCardDialog(context),
                icon: const Icon(Icons.add_card),
                label: const Text('Card'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Accounts',
            child: controller.accounts.isEmpty
                ? const Text('No accounts created yet.')
                : Column(
                    children: [
                      for (final account in controller.accounts) ...[
                        _EntityRow(
                          title: account.name,
                          subtitle:
                              '${account.institutionName} • ${account.maskedReference}',
                          onEdit: () =>
                              _showAccountDialog(context, account: account),
                          onArchive: () => _archiveAccount(context, account),
                        ),
                        if (account != controller.accounts.last)
                          const Divider(height: 20),
                      ],
                    ],
                  ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Cards',
            child: controller.cards.isEmpty
                ? const Text('No cards created yet.')
                : Column(
                    children: [
                      for (final card in controller.cards) ...[
                        _EntityRow(
                          title: card.name,
                          subtitle:
                              '${card.issuer} • ${card.maskedReference}${card.dueDay == null ? '' : ' • due ${card.dueDay}'}',
                          onEdit: () => _showCardDialog(context, card: card),
                          onArchive: () => _archiveCard(context, card),
                        ),
                        if (card != controller.cards.last)
                          const Divider(height: 20),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  void _showAccountDialog(
    BuildContext context, {
    Account? account,
  }) {
    final parentMessenger = ScaffoldMessenger.of(context);
    final nameController = TextEditingController(text: account?.name ?? '');
    final institutionController =
        TextEditingController(text: account?.institutionName ?? '');
    final maskedController =
        TextEditingController(text: account?.maskedReference ?? '');
    final notesController = TextEditingController(text: account?.notes ?? '');
    var type = account?.accountType ?? AccountType.checking;
    final formKey = GlobalKey<FormState>();

    showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(account == null ? 'Add account' : 'Edit account'),
              content: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Required'
                                : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: institutionController,
                        decoration:
                            const InputDecoration(labelText: 'Institution'),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Required'
                                : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<AccountType>(
                        initialValue: type,
                        decoration: const InputDecoration(labelText: 'Type'),
                        items: [
                          for (final entry in AccountType.values)
                            DropdownMenuItem(
                              value: entry,
                              child: Text(_titleForEnum(entry.storageValue)),
                            ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => type = value);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: maskedController,
                        decoration: const InputDecoration(
                          labelText: 'Masked reference',
                          helperText: 'Use a masked label such as ...1234.',
                        ),
                        validator: (value) => _validateMaskedReference(value),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: notesController,
                        maxLines: 3,
                        decoration: const InputDecoration(labelText: 'Notes'),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }
                    try {
                      await KinjuuAppScope.of(context).saveAccount(
                        existingId: account?.id,
                        name: nameController.text,
                        institutionName: institutionController.text,
                        accountType: type,
                        maskedReference: maskedController.text,
                        notes: notesController.text,
                      );
                      if (context.mounted) {
                        Navigator.of(context).pop();
                        parentMessenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              account == null
                                  ? 'Account created.'
                                  : 'Account updated.',
                            ),
                          ),
                        );
                      }
                    } catch (error) {
                      if (context.mounted) {
                        parentMessenger.showSnackBar(
                            SnackBar(content: Text(error.toString())));
                      }
                    }
                  },
                  child: Text(account == null ? 'Create' : 'Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showCardDialog(
    BuildContext context, {
    TrackedCard? card,
  }) {
    final parentMessenger = ScaffoldMessenger.of(context);
    final nameController = TextEditingController(text: card?.name ?? '');
    final issuerController = TextEditingController(text: card?.issuer ?? '');
    final maskedController =
        TextEditingController(text: card?.maskedReference ?? '');
    final statementController =
        TextEditingController(text: card?.statementDay?.toString() ?? '');
    final dueController =
        TextEditingController(text: card?.dueDay?.toString() ?? '');
    final notesController = TextEditingController(text: card?.notes ?? '');
    var type = card?.cardType ?? CardType.credit;
    final formKey = GlobalKey<FormState>();

    showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(card == null ? 'Add card' : 'Edit card'),
              content: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Required'
                                : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: issuerController,
                        decoration: const InputDecoration(labelText: 'Issuer'),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Required'
                                : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<CardType>(
                        initialValue: type,
                        decoration: const InputDecoration(labelText: 'Type'),
                        items: [
                          for (final entry in CardType.values)
                            DropdownMenuItem(
                              value: entry,
                              child: Text(_titleForEnum(entry.storageValue)),
                            ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => type = value);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: maskedController,
                        decoration: const InputDecoration(
                          labelText: 'Masked reference',
                          helperText: 'Use a masked label such as ...4242.',
                        ),
                        validator: (value) => _validateMaskedReference(value),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: statementController,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(labelText: 'Statement day'),
                        validator: (value) => _validateOptionalDay(value),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: dueController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Due day'),
                        validator: (value) => _validateOptionalDay(value),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: notesController,
                        maxLines: 3,
                        decoration: const InputDecoration(labelText: 'Notes'),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }
                    try {
                      await KinjuuAppScope.of(context).saveCard(
                        existingId: card?.id,
                        name: nameController.text,
                        issuer: issuerController.text,
                        cardType: type,
                        maskedReference: maskedController.text,
                        statementDay: int.tryParse(statementController.text),
                        dueDay: int.tryParse(dueController.text),
                        notes: notesController.text,
                      );
                      if (context.mounted) {
                        Navigator.of(context).pop();
                        parentMessenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              card == null ? 'Card created.' : 'Card updated.',
                            ),
                          ),
                        );
                      }
                    } catch (error) {
                      if (context.mounted) {
                        parentMessenger.showSnackBar(
                            SnackBar(content: Text(error.toString())));
                      }
                    }
                  },
                  child: Text(card == null ? 'Create' : 'Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _archiveAccount(BuildContext context, Account account) async {
    final confirmed = await _confirmArchive(
      context,
      title: 'Archive account?',
      message:
          'Archive ${account.name} and remove it from active account pickers?',
    );
    if (!confirmed) {
      return;
    }

    await _runWithFeedback(
      context,
      successMessage: 'Archived ${account.name}.',
      action: () => KinjuuAppScope.of(context).archiveAccount(account.id),
    );
  }

  Future<void> _archiveCard(BuildContext context, TrackedCard card) async {
    final confirmed = await _confirmArchive(
      context,
      title: 'Archive card?',
      message: 'Archive ${card.name} and remove it from active card pickers?',
    );
    if (!confirmed) {
      return;
    }

    await _runWithFeedback(
      context,
      successMessage: 'Archived ${card.name}.',
      action: () => KinjuuAppScope.of(context).archiveCard(card.id),
    );
  }

  Future<void> _runWithFeedback(
    BuildContext context, {
    required Future<void> Function() action,
    required String successMessage,
  }) async {
    try {
      await action();
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(successMessage)),
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  Future<bool> _confirmArchive(
    BuildContext context, {
    required String title,
    required String message,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Archive'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  String _titleForEnum(String value) => DisplayFormatters.titleCase(value);

  String? _validateMaskedReference(String? value) {
    final trimmed = (value ?? '').trim();
    if (trimmed.isEmpty) {
      return null;
    }
    if (RegExp(r'^\d{12,19}$').hasMatch(trimmed)) {
      return 'Use a masked reference, not a full number';
    }
    return null;
  }

  String? _validateOptionalDay(String? value) {
    final trimmed = (value ?? '').trim();
    if (trimmed.isEmpty) {
      return null;
    }
    final parsed = int.tryParse(trimmed);
    if (parsed == null || parsed < 1 || parsed > 31) {
      return 'Use a day from 1 to 31';
    }
    return null;
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _EntityRow extends StatelessWidget {
  const _EntityRow({
    required this.title,
    required this.subtitle,
    required this.onEdit,
    required this.onArchive,
  });

  final String title;
  final String subtitle;
  final VoidCallback onEdit;
  final VoidCallback onArchive;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 4),
              Text(subtitle),
            ],
          ),
        ),
        IconButton(onPressed: onEdit, icon: const Icon(Icons.edit_outlined)),
        IconButton(
          onPressed: onArchive,
          icon: const Icon(Icons.archive_outlined),
        ),
      ],
    );
  }
}
