import 'package:flutter/material.dart';

import 'routes/app_router.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

class KinjuuApp extends StatelessWidget {
  const KinjuuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kinjuu',
      theme: AppTheme.light(),
      initialRoute: AppRoutes.dashboard,
      onGenerateRoute: AppRouter.onGenerateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}

