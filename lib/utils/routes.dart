import 'package:flutter/material.dart';
import 'package:nepal_blood_nexus/auth/login/pages/login.dart';
import 'package:nepal_blood_nexus/auth/register/pages/register.dart';
import 'package:nepal_blood_nexus/homepage/pages/homepage.dart';
import 'package:nepal_blood_nexus/more/more_option.dart';
import 'package:nepal_blood_nexus/onboard/pages/onboard.dart';

class Routes {
  static const String welcome = 'welcome';
  static const String login = 'login';
  static const String home = 'home';
  static const String profile = 'profile';
  static const String register = 'register';
  static const String more = 'more';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcome:
        return MaterialPageRoute(
          builder: (context) => const OnboardPage(),
        );
      case register:
        return MaterialPageRoute(builder: (context) => RegisterPage());
      case login:
        return MaterialPageRoute(builder: (context) => LoginPage());
      // case verification:
      //   final Map args = settings.arguments as Map;
      //   return MaterialPageRoute(
      //       builder: (context) => VerificationPage(
      //             smsCodeId: args['smsCodeId'],
      //             phoneNumber: args['phoneNumber'],
      //           ));
      // case userinfo:
      //   final String profileImageUrl = settings.arguments as String;
      //   return MaterialPageRoute(
      //       builder: (context) => UserInfoPage(
      //             profileImageUrl: profileImageUrl,
      //           ));
      case home:
        final Map args = settings.arguments as Map;

        return MaterialPageRoute(
            builder: (context) =>
                HomePage(user: args['user'], token: args['token']));
      // case contact:
      //   return MaterialPageRoute(builder: (context) => const ContactPage());
      // case chat:
      //   UserModel user = settings.arguments as UserModel;builder
      //   return MaterialPageRoute(builder: (context) => ChatPage(user: user));
      // case profile:
      //   UserModel user = settings.arguments as UserModel;
      //   return PageTransition(
      //     child: ProfilePage(user: user),
      //     type: PageTransitionType.fade,
      //     duration: const Duration(milliseconds: 500),
      //   );

      case more:
        return MaterialPageRoute(builder: (context) => MoreOptionPage());

      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text("data"),
            ),
          ),
        );
    }
  }
}
