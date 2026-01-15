import 'package:cuidado_infantil/Auth/ui/screens/forgot_password_screen.dart';
import 'package:cuidado_infantil/Auth/ui/screens/login_screen.dart';
import 'package:cuidado_infantil/Auth/ui/screens/server_screen.dart';
import 'package:cuidado_infantil/Child/ui/screens/child_form_screen.dart';
import 'package:cuidado_infantil/Child/ui/screens/child_options_screen.dart';
import 'package:cuidado_infantil/Child/ui/screens/child_identification_details_screen.dart';
import 'package:cuidado_infantil/Child/ui/screens/child_medical_details_screen.dart';
import 'package:cuidado_infantil/Child/ui/screens/child_social_details_screen.dart';
import 'package:cuidado_infantil/Child/ui/screens/child_enrollment_details_screen.dart';
import 'package:cuidado_infantil/Child/ui/screens/child_success_screen.dart';
import 'package:cuidado_infantil/Intro/ui/screens/about_screen.dart';
import 'package:cuidado_infantil/Intro/ui/screens/onboarding_screen.dart';
import 'package:cuidado_infantil/Intro/ui/screens/home_screen.dart';
import 'package:cuidado_infantil/Intro/ui/screens/splash_screen.dart';
import 'package:cuidado_infantil/Monitoring/ui/screens/attendance_screen.dart';
import 'package:cuidado_infantil/Monitoring/ui/screens/attendance_report_screen.dart';
import 'package:cuidado_infantil/Monitoring/ui/screens/monitoring_child_list_screen.dart';
import 'package:cuidado_infantil/Monitoring/ui/screens/monitoring_child_options_screen.dart';
import 'package:cuidado_infantil/Monitoring/ui/screens/monitoring_nutrition_details_screen.dart';
import 'package:cuidado_infantil/Monitoring/ui/screens/monitoring_nutrition_form_screen.dart';
import 'package:cuidado_infantil/Monitoring/ui/screens/monitoring_development_details_screen.dart';
import 'package:cuidado_infantil/Monitoring/ui/screens/monitoring_development_form_screen.dart';
import 'package:cuidado_infantil/Monitoring/ui/screens/monitoring_development_list_screen.dart';
import 'package:cuidado_infantil/Incident/ui/screens/incident_report_list_screen.dart';
import 'package:cuidado_infantil/Incident/ui/screens/incident_report_form_screen.dart';
import 'package:cuidado_infantil/Incident/ui/screens/incident_report_details_screen.dart';
import 'package:cuidado_infantil/Monitoring/ui/screens/monitoring_nutrition_list_screen.dart';
import 'package:cuidado_infantil/Monitoring/ui/screens/monitoring_vaccination_tracking_screen.dart';
import 'package:cuidado_infantil/User/ui/screens/preferences_screen.dart';
import 'package:cuidado_infantil/User/ui/screens/select_childcare_center.dart';
import 'package:cuidado_infantil/User/ui/screens/change_password_screen.dart';
import 'package:cuidado_infantil/User/ui/screens/educator_profile_screen.dart';
import 'package:cuidado_infantil/Child/ui/screens/child_list_screen.dart';


import 'package:get/get.dart';

class AppPages {
  static final routes = [
    GetPage(name: SplashScreen.routeName , page: () => SplashScreen()),
    GetPage(name: OnboardingScreen.routeName, page: () => OnboardingScreen()),
    GetPage(name: ServerScreen.routeName, page: () => ServerScreen()),
    GetPage(name: LoginScreen.routeName, page: () => LoginScreen()),
    GetPage(name: ForgotPasswordScreen.routeName, page: () => ForgotPasswordScreen()),
    GetPage(name: HomeScreen.routeName, page: () => HomeScreen()),
    GetPage(name: PreferencesScreen.routeName, page: () => PreferencesScreen()),
    GetPage(name: SelectChildcareCenterScreen.routeName, page: () => SelectChildcareCenterScreen()),
    GetPage(name: ChangePasswordScreen.routeName, page: () => ChangePasswordScreen()),
    GetPage(name: EducatorProfileScreen.routeName, page: () => EducatorProfileScreen()),
    GetPage(name: ChildFormScreen.routeName, page: () => ChildFormScreen()),
    GetPage(name: ChildListScreen.routeName, page: () => ChildListScreen()),
    GetPage(name: ChildOptionsScreen.routeName, page: () => ChildOptionsScreen()),
    GetPage(name: ChildIdentificationDetailsScreen.routeName, page: () => ChildIdentificationDetailsScreen()),
    GetPage(name: ChildMedicalDetailsScreen.routeName, page: () => ChildMedicalDetailsScreen()),
    GetPage(name: ChildSocialDetailsScreen.routeName, page: () => ChildSocialDetailsScreen()),
    GetPage(name: ChildEnrollmentDetailsScreen.routeName, page: () => ChildEnrollmentDetailsScreen()),
    GetPage(name: AttendanceScreen.routeName, page: () => AttendanceScreen()),
    GetPage(name: AttendanceReportScreen.routeName, page: () => AttendanceReportScreen()),
    GetPage(name: ChildSuccessScreen.routeName, page: () => ChildSuccessScreen()),
    GetPage(name: MonitoringChildListScreen.routeName, page: () => MonitoringChildListScreen()),
    GetPage(name: MonitoringChildOptionsScreen.routeName, page: () => MonitoringChildOptionsScreen()),
    GetPage(name: MonitoringNutritionListScreen.routeName, page: () => MonitoringNutritionListScreen()),
    GetPage(name: MonitoringNutritionFormScreen.routeName, page: () => MonitoringNutritionFormScreen()),
    GetPage(name: MonitoringNutritionDetailsScreen.routeName, page: () => MonitoringNutritionDetailsScreen()),
    GetPage(name: MonitoringDevelopmentListScreen.routeName, page: () => MonitoringDevelopmentListScreen()),
    GetPage(name: MonitoringDevelopmentFormScreen.routeName, page: () => MonitoringDevelopmentFormScreen()),
    GetPage(name: MonitoringDevelopmentDetailsScreen.routeName, page: () => MonitoringDevelopmentDetailsScreen()),
    GetPage(name: MonitoringVaccinationTrackingScreen.routeName, page: () => MonitoringVaccinationTrackingScreen()),
    GetPage(name: IncidentReportListScreen.routeName, page: () => IncidentReportListScreen()),
    GetPage(name: IncidentReportFormScreen.routeName, page: () => IncidentReportFormScreen()),
    GetPage(name: IncidentReportDetailsScreen.routeName, page: () => IncidentReportDetailsScreen()),
    GetPage(name: AboutScreen.routeName, page: () => AboutScreen()),
  ];
}
