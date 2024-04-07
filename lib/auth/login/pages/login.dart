import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nepal_blood_nexus/utils/colours.dart';
import 'package:nepal_blood_nexus/utils/models/user.dart';
import 'package:nepal_blood_nexus/utils/routes.dart';
import 'package:nepal_blood_nexus/widgets/button_v1.dart';
import 'package:nepal_blood_nexus/widgets/text_input.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final fullnameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final storage = const FlutterSecureStorage();

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );

  void showLoading(context) => showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircularProgressIndicator(
                color: Colours.mainColor,
              ),
              Text("Loading...")
            ],
          ),
        ),
      );

  Future attemptSignUp(
    String email,
    String phone,
    String password,
  ) async {
    var url = Uri.https('nbn-server.onrender.com', 'api/auth/login');
    var res = await http.post(url,
        body: {"email": email, "phone": phone, "password": password});
    return res.body;
  }

  Future _register() async {
    try {
      var email = emailController.text;
      var password = passwordController.text;
      var phone = phoneController.text;
      var res = await attemptSignUp(email, phone, password);
      return res;
    } catch (e) {
      if (e.toString() != '') {
        debugPrint(e.toString());
      }
    }
  }

  late bool hide;

  @override
  void initState() {
    super.initState();
    hide = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                alignment: Alignment.center,
                fit: BoxFit.fill,
                opacity: 0.3,
                image: AssetImage(
                  "assets/images/register-bg.jpg",
                ),
              ),
              color: Color.fromARGB(255, 0, 0, 0),
              backgroundBlendMode: BlendMode.overlay),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logo
                Image.asset("assets/images/logo05x.png"),
                const SizedBox(
                  height: 7,
                ),
                const Text(
                  "Login",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, letterSpacing: 1.5),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextInput(
                  hintText: "phone",
                  controller: phoneController,
                  textInputType: TextInputType.phone,
                ),
                const SizedBox(
                  height: 7,
                ),
                CustomTextInput(
                  hintText: "password",
                  obsureText: hide,
                  controller: passwordController,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        hide = !hide;
                      });
                    },
                    child: Icon(
                      hide
                          ? Icons.remove_red_eye_rounded
                          : Icons.remove_red_eye_outlined,
                      color: Colours.mainColor,
                    ),
                  ),
                ),
                ButtonV1(
                  text: "Login",
                  onTap: () {
                    showLoading(context);
                    _register().then((value) {
                      debugPrint(value.toString());
                      var response = jsonDecode(value);
                      if (response["success"] == false) {
                        displayDialog(context, "Failed", response["error"]);
                      } else {
                        User user = User.fromJson(response["user"]);

                        storage.write(key: "token", value: response["token"]);
                        storage.write(
                            key: "user", value: jsonEncode(response["user"]));

                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.home,
                          (routes) => false,
                          arguments: {"token": response["token"], "user": user},
                        );
                      }
                    });
                  },
                ),
                const Text("Dont Have an account?"),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.register);
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(color: Colours.mainColor),
                    )),
                // google login
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text("or continue with"),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                      ),
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    "assets/images/google.png",
                    height: 30,
                  ),
                ),
                //already member login now
              ],
            ),
          ),
        ),
      ),
    );
  }
}
