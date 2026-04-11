import 'package:flutter/material.dart';

import 'state/kinjuu_app_controller.dart';
import 'state/kinjuu_app_scope.dart';
import 'routes/app_router.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

class KinjuuApp extends StatefulWidget {
  const KinjuuApp({super.key, this.controller});

  final KinjuuAppController? controller;

  @override
  State<KinjuuApp> createState() => _KinjuuAppState();
}

class _KinjuuAppState extends State<KinjuuApp> {
  late final KinjuuAppController _controller;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? KinjuuAppController();
    if (!_controller.isLoaded) {
      _controller.load();
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
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
