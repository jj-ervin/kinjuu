import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kinjuu/app/app.dart';
import 'package:kinjuu/core/constants/app_strings.dart';

void main() {
  testWidgets('Kinjuu app boots to dashboard scaffold', (tester) async {
    await tester.pumpWidget(const KinjuuApp());

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text(AppStrings.appTagline), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
