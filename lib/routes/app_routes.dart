import 'package:get/get.dart';
import '../views/login_view.dart';
import '../views/dashboard_view.dart';
import '../views/logs_view.dart';
import '../views/graph_view.dart';
import '../views/timer_view.dart';

class AppRoutes {
  static const login = '/login';
  static const dashboard = '/dashboard';
  static const logs = '/logs';
  static const graph = '/graph';
  static const timer = '/timer';

  static final routes = [
    GetPage(name: login, page: () => LoginView()),
    GetPage(name: dashboard, page: () => DashboardView()),
    GetPage(name: logs, page: () => LogsView()),
    GetPage(name: graph, page: () => GraphView()),
    GetPage(name: timer, page: () => TimerView()),
  ];
}
