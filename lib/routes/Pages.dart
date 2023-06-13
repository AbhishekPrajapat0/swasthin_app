import 'package:get/get_navigation/src/routes/get_route.dart';

import '../screens/Chat/ChatWithScreen.dart';
import '../screens/Consulting/AppoinmentDetailsScreen.dart';
import '../screens/Consulting/AppointmentList.dart';
import '../screens/Dashboard/DashboardScreen.dart';
import 'Routes.dart';

class Pages {
  static final routes = [
    GetPage(name: Routes.CHAT_SCREEN, page: () => ChatPage()),
    GetPage(name: Routes.DASHBOARD_SCREEN, page: () => DashboardScreen()),
    GetPage(
        name: Routes.APPOINTMENT_LIST_SCREEN,
        page: () => AppointmentListScreen()),
    GetPage(
        name: Routes.APPOINTMENT_DETAIL_SCREEN,
        page: () => AppointmentDetailsScreen()),
  ];
}
