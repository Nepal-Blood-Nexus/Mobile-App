import 'package:flutter/material.dart';
import 'package:nepal_blood_nexus/auth/login/pages/login.dart';
import 'package:nepal_blood_nexus/auth/register/pages/register.dart';
import 'package:nepal_blood_nexus/bloodrequest/bloodrequest.dart';
import 'package:nepal_blood_nexus/bloodrequest/donateblood.dart';
import 'package:nepal_blood_nexus/homepage/pages/homepage.dart';
import 'package:nepal_blood_nexus/homepage/screens/setup.dart';
import 'package:nepal_blood_nexus/more/more_option.dart';
import 'package:nepal_blood_nexus/onboard/pages/onboard.dart';
import 'package:nepal_blood_nexus/utils/models/request.dart';
import 'package:page_transition/page_transition.dart';

class Routes {
  static const String welcome = 'welcome';
  static const String login = 'login';
  static const String home = 'home';
  static const String profile = 'profile';
  static const String register = 'register';
  static const String more = 'more';
  static const String bloodrequest = 'bloodrequest';
  static const String donateblood = 'donateblood';

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
      case profile:
        final Map user = settings.arguments as Map;
        return PageTransition(
          child: ProfileSetupScreen(user: user["user"]),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 500),
        );
      case donateblood:
        final BloodRequest _bloodRequest = settings.arguments as BloodRequest;
        return PageTransition(
          child: DonateScreen(
            bloodRequest: _bloodRequest,
          ),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 500),
        );
      case bloodrequest:
        return PageTransition(
          child: BloodRequestPage(
              values: settings.arguments as Map<String, dynamic>),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 500),
        );

      case more:
        return MaterialPageRoute(builder: (context) => const MoreOptionPage());

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
