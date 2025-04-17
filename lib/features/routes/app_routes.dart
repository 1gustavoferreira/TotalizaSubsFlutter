import 'package:flutter/material.dart';
import 'package:totaliza_subs/features/auth/login.dart';
import 'package:totaliza_subs/features/auth/signup.dart';
import 'package:totaliza_subs/features/welcome.dart';
import 'package:totaliza_subs/features/home/home.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String welcome = '/welcome';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginPage(),
    signup: (context) => const SignupPage(),
    home: (context) => const HomePage(),
    welcome: (context) => const WelcomePage(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (context) => const LoginPage());
      case signup:
        return MaterialPageRoute(builder: (context) => const SignupPage());
      case home:
        return MaterialPageRoute(builder: (context) => const HomePage());
      case welcome:
        return MaterialPageRoute(builder: (context) => const WelcomePage());
      default:
        return MaterialPageRoute(
          builder: (context) => const WelcomePage(),
        );
    }
  }
}
