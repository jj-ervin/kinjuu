import 'package:flutter/material.dart';

import 'kinjuu_app_controller.dart';

class KinjuuAppScope extends InheritedNotifier<KinjuuAppController> {
  const KinjuuAppScope({
    required KinjuuAppController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  static KinjuuAppController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<KinjuuAppScope>();
    assert(scope != null, 'KinjuuAppScope not found in widget tree.');
    return scope!.notifier!;
  }
}
