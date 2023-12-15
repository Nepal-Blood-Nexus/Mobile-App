import 'package:flutter/material.dart';
import 'package:nepal_blood_nexus/auth/register/pages/register.dart';
import 'package:nepal_blood_nexus/homepage/pages/homepage.dart';
import 'package:nepal_blood_nexus/onboard/pages/onboard.dart';
import 'package:nepal_blood_nexus/utils/models/user.dart';
import 'package:page_transition/page_transition.dart';

class Routes {
  static const String welcome = 'welcome';
  static const String login = 'login';
  static const String home = 'home';
  static const String profile = 'profile';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcome:
        return MaterialPageRoute(
          builder: (context) => const OnboardPage(),
        );
      case login:
        return MaterialPageRoute(builder: (context) => RegisterPage());
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
      //   UserModel user = settings.arguments as UserModel;
      //   return MaterialPageRoute(builder: (context) => ChatPage(user: user));
      // case profile:
      //   UserModel user = settings.arguments as UserModel;
      //   return PageTransition(
      //     child: ProfilePage(user: user),
      //     type: PageTransitionType.fade,
      //     duration: const Duration(milliseconds: 500),
      //   );

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
