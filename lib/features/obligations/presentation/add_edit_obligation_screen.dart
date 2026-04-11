import 'package:flutter/material.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/state/kinjuu_app_scope.dart';
import '../../../core/utils/display_formatters.dart';
import '../../../domain/entities/obligation.dart';
import '../../../domain/enums/obligation_type.dart';
import '../../../domain/enums/recurrence_rule_style.dart';
import '../../../shared/widgets/kinjuu_app_scaffold.dart';

class AddEditObligationScreen extends StatefulWidget {
  const AddEditObligationScreen({super.key, this.obligationId});

  final String? obligationId;

  @override
  State<AddEditObligationScreen> createState() =>
      _AddEditObligationScreenState();
}

class _AddEditObligationScreenState extends State<AddEditObligationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _expectedAmountController = TextEditingController();
  final _minimumAmountController = TextEditingController();
  final _currencyCodeController = TextEditingController(text: 'USD');
  final _categoryController = TextEditingController();
  final _notesController = TextEditingController();

  ObligationType _obligationType = ObligationType.bill;
  RecurrenceRuleStyle _recurrenceRule = RecurrenceRuleStyle.monthly;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
  DateTime? _statementDate;
  bool _autopayExpected = false;
  String? _linkedAccountId;
  String? _linkedCardId;
  bool _initialized = false;
  bool _isSaving = false;
  bool _missingObligation = false;

  bool get _isEditing => widget.obligationId != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) {
      return;
    }
    _initialized = true;
    final controller = KinjuuAppScope.of(context);
    final obligation = widget.obligationId == null
        ? null
        : controller.obligationById(widget.obligationId!);
    if (obligation != null) {
      _hydrate(obligation);
      return;
    }
    if (_isEditing) {
      _missingObligation = true;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _expectedAmountController.dispose();
    _minimumAmountController.dispose();
    _currencyCodeController.dispose();
    _categoryController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = KinjuuAppScope.of(context);
    final accounts = controller.accounts;
    final cards = controller.cards;

    if (_missingObligation) {
      return KinjuuAppScaffold(
        currentRoute: AppRoutes.obligationEditor,
        title: 'Edit Obligation',
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'This obligation is no longer available.',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'It may have been archived or removed from the active MVP list. Return to obligations and choose another item.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pushReplacementNamed(
                      AppRoutes.obligations,
                    ),
                    child: const Text('Back to obligations'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return KinjuuAppScaffold(
      currentRoute: AppRoutes.obligationEditor,
      title: _isEditing ? 'Edit Obligation' : 'Add Obligation',
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          children: [
            DropdownButtonFormField<ObligationType>(
              initialValue: _obligationType,
              decoration: const InputDecoration(labelText: 'Type'),
              items: [
                for (final type in ObligationType.values)
                  DropdownMenuItem(
                    value: type,
                    child: Text(_titleForEnum(type.storageValue)),
                  ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _obligationType = value);
                }
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter a title';
                }
                if (value.trim().length < 3) {
                  return 'Use at least 3 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Due date'),
              subtitle: Text(
                '${DisplayFormatters.formatDate(_dueDate)}${_dueDate.isBefore(DateTime.now()) ? ' • overdue tracking will start immediately' : ''}',
              ),
              trailing: const Icon(Icons.calendar_today_outlined),
              onTap: _pickDueDate,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<RecurrenceRuleStyle>(
              initialValue: _recurrenceRule,
              decoration: const InputDecoration(labelText: 'Recurrence'),
              items: [
                for (final recurrence in RecurrenceRuleStyle.values)
                  DropdownMenuItem(
                    value: recurrence,
                    child: Text(_titleForEnum(recurrence.storageValue)),
                  ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _recurrenceRule = value);
                }
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _expectedAmountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Expected amount'),
              validator: (value) => _validateAmount(value, allowEmpty: true),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _minimumAmountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Minimum amount'),
              validator: (value) {
                final amountValidation =
                    _validateAmount(value, allowEmpty: true);
                if (amountValidation != null) {
                  return amountValidation;
                }
                final expected = _toDouble(_expectedAmountController.text);
                final minimum = _toDouble(value ?? '');
                if (expected != null && minimum != null && minimum > expected) {
                  return 'Minimum amount cannot exceed expected amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _currencyCodeController,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(labelText: 'Currency code'),
              validator: (value) {
                if (value == null ||
                    !RegExp(r'^[A-Za-z]{3}$').hasMatch(value.trim())) {
                  return 'Use a 3-letter currency code';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Statement date'),
              subtitle: Text(
                _statementDate == null
                    ? 'Optional'
                    : DisplayFormatters.formatDate(_statementDate!),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_statementDate != null)
                    IconButton(
                      onPressed: () => setState(() => _statementDate = null),
                      icon: const Icon(Icons.clear),
                    ),
                  const Icon(Icons.calendar_month_outlined),
                ],
              ),
              onTap: _pickStatementDate,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String?>(
              initialValue: _linkedAccountId,
              decoration: const InputDecoration(labelText: 'Linked account'),
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('None'),
                ),
                for (final account in accounts)
                  DropdownMenuItem<String?>(
                    value: account.id,
                    child: Text(account.name),
                  ),
              ],
              onChanged: (value) => setState(() => _linkedAccountId = value),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String?>(
              initialValue: _linkedCardId,
              decoration: const InputDecoration(labelText: 'Linked card'),
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('None'),
                ),
                for (final card in cards)
                  DropdownMenuItem<String?>(
                    value: card.id,
                    child: Text(card.name),
                  ),
              ],
              onChanged: (value) => setState(() => _linkedCardId = value),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Category',
                helperText:
                    'Optional, but helpful for calendar and list scanning.',
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              value: _autopayExpected,
              contentPadding: EdgeInsets.zero,
              title: const Text('Autopay expected'),
              onChanged: (value) => setState(() => _autopayExpected = value),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
            const SizedBox(height: 12),
            const Text(
              'Saved obligations use the current Settings reminder defaults unless a narrower rule is added in a future pass.',
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isSaving
                        ? null
                        : () => Navigator.of(context).maybePop(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _isSaving ? null : _saveObligation,
                    child: Text(
                      _isSaving
                          ? 'Saving...'
                          : (_isEditing ? 'Save changes' : 'Create obligation'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _hydrate(Obligation obligation) {
    _titleController.text = obligation.title;
    _expectedAmountController.text =
        obligation.expectedAmount?.toString() ?? '';
    _minimumAmountController.text = obligation.minimumAmount?.toString() ?? '';
    _currencyCodeController.text = obligation.currencyCode;
    _categoryController.text = obligation.category;
    _notesController.text = obligation.notes;
    _obligationType = obligation.obligationType;
    _recurrenceRule = obligation.recurrenceRule;
    _dueDate = obligation.dueDate;
    _statementDate = obligation.statementDate;
    _autopayExpected = obligation.autopayExpected;
    _linkedAccountId = obligation.linkedAccountId;
    _linkedCardId = obligation.linkedCardId;
  }

  Future<void> _pickDueDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (selected != null) {
      setState(() => _dueDate = selected);
    }
  }

  Future<void> _pickStatementDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _statementDate ?? _dueDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (selected != null) {
      setState(() => _statementDate = selected);
    }
  }

  Future<void> _saveObligation() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_statementDate != null && _statementDate!.isAfter(_dueDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Statement date cannot be after the due date.'),
        ),
      );
      return;
    }

    final appController = KinjuuAppScope.of(context);
    final navigator = Navigator.of(context);
    setState(() => _isSaving = true);
    try {
      await appController.saveObligation(
        existingId: widget.obligationId,
        title: _titleController.text,
        obligationType: _obligationType,
        dueDate: _dueDate,
        recurrenceRule: _recurrenceRule,
        expectedAmount: _toDouble(_expectedAmountController.text),
        minimumAmount: _toDouble(_minimumAmountController.text),
        currencyCode: _currencyCodeController.text,
        autopayExpected: _autopayExpected,
        category: _categoryController.text,
        notes: _notesController.text,
        linkedAccountId: _linkedAccountId,
        linkedCardId: _linkedCardId,
        statementDate: _statementDate,
      );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing ? 'Obligation updated.' : 'Obligation created.',
          ),
        ),
      );
      navigator.pushReplacementNamed(AppRoutes.obligations);
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  String _titleForEnum(String value) => DisplayFormatters.titleCase(value);

  double? _toDouble(String value) =>
      value.trim().isEmpty ? null : double.tryParse(value.trim());

  String? _validateAmount(String? value, {required bool allowEmpty}) {
    final trimmed = (value ?? '').trim();
    if (trimmed.isEmpty) {
      return allowEmpty ? null : 'Required';
    }
    final parsed = double.tryParse(trimmed);
    if (parsed == null) {
      return 'Enter a valid number';
    }
    if (parsed < 0) {
      return 'Amount cannot be negative';
    }
    return null;
  }
}
