import 'package:flutter/material.dart';
import 'package:totaliza_subs/features/auth/login.dart';
import 'package:totaliza_subs/features/auth/signup.dart';
import 'package:totaliza_subs/features/welcome.dart';
import 'package:totaliza_subs/features/page/home.dart';
import 'package:totaliza_subs/features/page/settings.dart';
import 'package:totaliza_subs/features/page/insights.dart';
import 'package:totaliza_subs/features/page/reports.dart';
import 'package:totaliza_subs/features/page/add_subscription.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String welcome = '/welcome';
  static const String settings = '/settings';
  static const String insights = '/insights';
  static const String reports = '/reports';
  static const String addSubscription = '/add-subscription';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginPage(),
    signup: (context) => const SignupPage(),
    home: (context) => const HomePage(),
    welcome: (context) => const WelcomePage(),
    settings: (context) => const SettingsPage(),
    insights: (context) => const InsightsPage(),
    reports: (context) => const ReportsPage(),
    addSubscription: (context) => const AddSubscriptionPage(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (context) => const LoginPage());
      case '/signup':
        return MaterialPageRoute(builder: (context) => const SignupPage());
      case '/home':
        return MaterialPageRoute(builder: (context) => const HomePage());
      case '/welcome':
        return MaterialPageRoute(builder: (context) => const WelcomePage());
      case '/settings':
        return MaterialPageRoute(builder: (context) => const SettingsPage());
      case '/insights':
        return MaterialPageRoute(builder: (context) => const InsightsPage());
      case '/reports':
        return MaterialPageRoute(builder: (context) => const ReportsPage());
      case '/add-subscription':
        return MaterialPageRoute(builder: (context) => const AddSubscriptionPage());
      default:
        return MaterialPageRoute(builder: (context) => const WelcomePage());
    }
  }
}
