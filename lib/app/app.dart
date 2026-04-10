import 'package:flutter/material.dart';

import 'state/kinjuu_app_controller.dart';
import 'state/kinjuu_app_scope.dart';
import 'routes/app_router.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

class KinjuuApp extends StatefulWidget {
  const KinjuuApp({super.key});

  @override
  State<KinjuuApp> createState() => _KinjuuAppState();
}

class _KinjuuAppState extends State<KinjuuApp> {
  late final KinjuuAppController _controller;

  @override
  void initState() {
    super.initState();
    _controller = KinjuuAppController()..load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KinjuuAppScope(
      controller: _controller,
      child: MaterialApp(
        title: 'Kinjuu',
        theme: AppTheme.light(),
        initialRoute: AppRoutes.dashboard,
        onGenerateRoute: AppRouter.onGenerateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
