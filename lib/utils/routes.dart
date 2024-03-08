import 'package:flutter/material.dart';
import 'package:nepal_blood_nexus/auth/login/pages/login.dart';
import 'package:nepal_blood_nexus/auth/register/pages/register.dart';
import 'package:nepal_blood_nexus/bloodrequest/bloodrequest.dart';
import 'package:nepal_blood_nexus/bloodrequest/donateblood.dart';
import 'package:nepal_blood_nexus/chat/all_chats_screen.dart';
import 'package:nepal_blood_nexus/chat/chat_screen.dart';
import 'package:nepal_blood_nexus/chat/chat_screen_old.dart';
import 'package:nepal_blood_nexus/chat/contact_chat.dart';
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
  static const String dev = 'dev';
  static const String chat = 'chat';
  static const String allchats = 'allchats';
  static const String chatscontact = 'chatscontact';
  static const String oldchat = "oldchat";

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
        final BloodRequest bloodRequest_ = settings.arguments as BloodRequest;
        return PageTransition(
          child: DonateScreen(
            bloodRequest: bloodRequest_,
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

      case allchats:
        return PageTransition(
            child: const AllChatsScreen(),
            type: PageTransitionType.fade,
            duration: const Duration(milliseconds: 500));

      case chat:
        final String rid = settings.arguments as String;
        return MaterialPageRoute(
            builder: (context) => ChatScreen(requestid: rid));

      case oldchat:
        final String rid = settings.arguments as String;
        return MaterialPageRoute(
            builder: (context) => ChatScreenOld(chatid: rid));

      case chatscontact:
        return PageTransition(
            child: const ChatContactScreen(),
            type: PageTransitionType.fade,
            duration: const Duration(milliseconds: 500));

      case dev:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text("in progress"),
            ),
          ),
        );

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
