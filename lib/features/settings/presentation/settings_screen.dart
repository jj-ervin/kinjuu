import 'package:flutter/material.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/state/kinjuu_app_scope.dart';
import '../../../core/utils/display_formatters.dart';
import '../../../domain/entities/notification_rule.dart';
import '../../../services/notifications/notification_defaults.dart';
import '../../../shared/widgets/kinjuu_app_scaffold.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const _availableDaysBefore = <int>[7, 3, 1];
  static const _availableOverdueIntervals = <int>[1, 3, 7];

  final Set<int> _selectedDaysBefore = <int>{};
  bool _triggerOnDueDate = true;
  bool _triggerIfOverdue = true;
  int _overdueIntervalDays = NotificationDefaults.defaultOverdueIntervalDays;
  String _quietHoursStart = '22:00';
  String _quietHoursEnd = '07:00';
  bool _initialized = false;
  bool _isSaving = false;
  bool _hasLocalEdits = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) {
      return;
    }

    _initialized = true;
    _hydrateFromRules(KinjuuAppScope.of(context).globalNotificationRules);
  }

  @override
  Widget build(BuildContext context) {
    final controller = KinjuuAppScope.of(context);
    final rules = controller.globalNotificationRules;
    if (rules.isNotEmpty && !_isSaving && !_hasLocalEdits) {
      _hydrateFromRules(rules);
    }

    return KinjuuAppScaffold(
      currentRoute: AppRoutes.settings,
      title: 'Settings',
      child: ListView(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reminder defaults',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'These defaults are persisted locally and are reused when the app reloads. Saving changes re-syncs reminders for existing eligible obligations.',
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final day in _availableDaysBefore)
                        FilterChip(
                          selected: _selectedDaysBefore.contains(day),
                          label: Text('$day days before'),
                          onSelected: (selected) {
                            setState(() {
                              _hasLocalEdits = true;
                              if (selected) {
                                _selectedDaysBefore.add(day);
                              } else {
                                _selectedDaysBefore.remove(day);
                              }
                            });
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Reminder on due date'),
                    subtitle: const Text(
                        'Schedule a same-day reminder at the current MVP default time.'),
                    value: _triggerOnDueDate,
                    onChanged: (value) => setState(() {
                      _hasLocalEdits = true;
                      _triggerOnDueDate = value;
                    }),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Reminder when overdue'),
                    subtitle: const Text(
                        'Keep one overdue reminder in the current MVP path.'),
                    value: _triggerIfOverdue,
                    onChanged: (value) => setState(() {
                      _hasLocalEdits = true;
                      _triggerIfOverdue = value;
                    }),
                  ),
                  if (_triggerIfOverdue) ...[
                    const SizedBox(height: 12),
                    DropdownButtonFormField<int>(
                      initialValue: _overdueIntervalDays,
                      decoration: const InputDecoration(
                        labelText: 'Overdue reminder interval',
                      ),
                      items: [
                        for (final interval in _availableOverdueIntervals)
                          DropdownMenuItem<int>(
                            value: interval,
                            child: Text(
                                '$interval day${interval == 1 ? '' : 's'} after due date'),
                          ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _hasLocalEdits = true;
                            _overdueIntervalDays = value;
                          });
                        }
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quiet hours',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Quiet hours are applied before reminder scheduling. If a reminder falls inside the window, it is moved to the next allowed time.',
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Quiet hours start'),
                    subtitle: Text(
                        DisplayFormatters.formatTimeText(_quietHoursStart)),
                    trailing: const Icon(Icons.access_time_outlined),
                    onTap: () => _pickTime(
                      context,
                      initialValue: _quietHoursStart,
                      onSelected: (value) => setState(() {
                        _hasLocalEdits = true;
                        _quietHoursStart = value;
                      }),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Quiet hours end'),
                    subtitle:
                        Text(DisplayFormatters.formatTimeText(_quietHoursEnd)),
                    trailing: const Icon(Icons.access_time_outlined),
                    onTap: () => _pickTime(
                      context,
                      initialValue: _quietHoursEnd,
                      onSelected: (value) => setState(() {
                        _hasLocalEdits = true;
                        _quietHoursEnd = value;
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current behavior',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _buildBehaviorSummary(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isSaving
                      ? null
                      : () async {
                          final messenger = ScaffoldMessenger.of(context);
                          final controller = KinjuuAppScope.of(context);
                          setState(() => _isSaving = true);
                          try {
                            await controller
                                .restoreGlobalNotificationDefaults();
                            if (!mounted) {
                              return;
                            }
                            setState(() {
                              _hydrateFromRules(
                                  controller.globalNotificationRules);
                            });
                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text('Reminder defaults restored.'),
                              ),
                            );
                          } catch (error) {
                            if (!mounted) {
                              return;
                            }
                            messenger.showSnackBar(
                              SnackBar(content: Text(error.toString())),
                            );
                          } finally {
                            if (mounted) {
                              setState(() => _isSaving = false);
                            }
                          }
                        },
                  child: const Text('Restore defaults'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: _isSaving
                      ? null
                      : () async {
                          final messenger = ScaffoldMessenger.of(context);
                          if (!_triggerOnDueDate &&
                              _selectedDaysBefore.isEmpty &&
                              !_triggerIfOverdue) {
                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Keep at least one reminder trigger enabled.'),
                              ),
                            );
                            return;
                          }

                          final controller = KinjuuAppScope.of(context);
                          setState(() => _isSaving = true);
                          try {
                            await controller.saveGlobalNotificationDefaults(
                              daysBefore:
                                  _selectedDaysBefore.toList(growable: false),
                              triggerOnDueDate: _triggerOnDueDate,
                              triggerIfOverdue: _triggerIfOverdue,
                              overdueIntervalDays: _overdueIntervalDays,
                              quietHoursStart: _quietHoursStart,
                              quietHoursEnd: _quietHoursEnd,
                            );
                            if (!mounted) {
                              return;
                            }
                            setState(() {
                              _hasLocalEdits = false;
                            });
                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text('Reminder defaults updated.'),
                              ),
                            );
                          } catch (error) {
                            if (!mounted) {
                              return;
                            }
                            messenger.showSnackBar(
                              SnackBar(content: Text(error.toString())),
                            );
                          } finally {
                            if (mounted) {
                              setState(() => _isSaving = false);
                            }
                          }
                        },
                  child: Text(_isSaving ? 'Saving...' : 'Save settings'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _hydrateFromRules(List<NotificationRule> rules) {
    if (rules.isEmpty) {
      return;
    }

    final daysBefore = rules
        .where((entry) => entry.daysBefore > 0 && entry.isEnabled)
        .map((entry) => entry.daysBefore)
        .toSet();
    final dueDateRule =
        rules.where((entry) => entry.triggerOnDueDate && entry.isEnabled);
    final overdueRule =
        rules.where((entry) => entry.triggerIfOverdue && entry.isEnabled);
    final quietHoursSource = rules.first;

    _selectedDaysBefore
      ..clear()
      ..addAll(daysBefore);
    _triggerOnDueDate = dueDateRule.isNotEmpty;
    _triggerIfOverdue = overdueRule.isNotEmpty;
    _overdueIntervalDays = overdueRule.isEmpty
        ? NotificationDefaults.defaultOverdueIntervalDays
        : overdueRule.first.overdueIntervalDays ??
            NotificationDefaults.defaultOverdueIntervalDays;
    _quietHoursStart = quietHoursSource.quietHoursStart ?? '22:00';
    _quietHoursEnd = quietHoursSource.quietHoursEnd ?? '07:00';
    _hasLocalEdits = false;
  }

  Future<void> _pickTime(
    BuildContext context, {
    required String initialValue,
    required ValueChanged<String> onSelected,
  }) async {
    final parts = initialValue.split(':');
    final initialTime = TimeOfDay(
      hour: int.tryParse(parts.first) ?? 22,
      minute: int.tryParse(parts.last) ?? 0,
    );
    final selected = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (selected == null) {
      return;
    }

    onSelected(
      '${selected.hour.toString().padLeft(2, '0')}:${selected.minute.toString().padLeft(2, '0')}',
    );
  }

  String _buildBehaviorSummary() {
    final orderedDays = _selectedDaysBefore.toList(growable: false)
      ..sort((left, right) => right.compareTo(left));
    final leadDaysText = orderedDays.isEmpty ? 'none' : orderedDays.join(', ');
    final overdueText = _triggerIfOverdue
        ? 'plus an overdue reminder $_overdueIntervalDays day${_overdueIntervalDays == 1 ? '' : 's'} later'
        : 'with no overdue reminder';
    return 'Days-before reminders: $leadDaysText. Due-date reminder: ${_triggerOnDueDate ? 'on' : 'off'}. Quiet hours: ${DisplayFormatters.formatTimeText(_quietHoursStart)} to ${DisplayFormatters.formatTimeText(_quietHoursEnd)}. Overdue behavior: $overdueText.';
  }
}
