import 'package:flutter/material.dart';

import '../../features/accounts_cards/presentation/accounts_cards_screen.dart';
import '../../features/calendar/presentation/calendar_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/history/presentation/history_screen.dart';
import '../../features/obligations/presentation/add_edit_obligation_screen.dart';
import '../../features/obligations/presentation/obligations_list_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import 'app_routes.dart';

abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.dashboard:
        return _page(const DashboardScreen(), settings);
      case AppRoutes.obligations:
        return _page(const ObligationsListScreen(), settings);
      case AppRoutes.obligationEditor:
        final title = settings.arguments as String?;
        return _page(AddEditObligationScreen(titleOverride: title), settings);
      case AppRoutes.accountsCards:
        return _page(const AccountsCardsScreen(), settings);
      case AppRoutes.calendar:
        return _page(const CalendarScreen(), settings);
      case AppRoutes.history:
        return _page(const HistoryScreen(), settings);
      case AppRoutes.settings:
        return _page(const SettingsScreen(), settings);
      default:
        return _page(const DashboardScreen(), settings);
    }
  }

  static MaterialPageRoute<dynamic> _page(
    Widget child,
    RouteSettings settings,
  ) {
    return MaterialPageRoute<void>(
      builder: (_) => child,
      settings: settings,
    );
  }
}
