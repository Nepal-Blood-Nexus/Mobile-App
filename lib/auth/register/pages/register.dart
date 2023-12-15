import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nepal_blood_nexus/utils/colours.dart';
import 'package:nepal_blood_nexus/utils/models/user.dart';
import 'package:nepal_blood_nexus/utils/routes.dart';
import 'package:nepal_blood_nexus/widgets/button_v1.dart';
import 'package:nepal_blood_nexus/widgets/text_input.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

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
          content: CircularProgressIndicator(
            color: Colours.mainColor,
          ),
        ),
      );

  final fullnameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final storage = const FlutterSecureStorage();

  Future attemptSignUp(
    String fullname,
    String email,
    String phone,
    String password,
  ) async {
    var url = Uri.https('nbn-server.onrender.com', 'api/auth');
    var res = await http.post(url, body: {
      "fullname": fullname,
      "email": email,
      "phone": phone,
      "password": password
    });
    return res.body;
  }

  Future _register() async {
    var fullname = fullnameController.text;
    var email = emailController.text;
    var password = passwordController.text;
    var phone = phoneController.text;
    var res = await attemptSignUp(fullname, email, phone, password);
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                "Register your account",
                style:
                    TextStyle(fontWeight: FontWeight.w600, letterSpacing: 1.5),
              ),
              const SizedBox(
                height: 10,
              ),
              // full name
              CustomTextInput(
                hintText: "Your Full Name",
                controller: fullnameController,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextInput(
                hintText: "email",
                controller: emailController,
                textInputType: TextInputType.emailAddress,
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
                height: 10,
              ),
              CustomTextInput(
                hintText: "password",
                obsureText: true,
                controller: passwordController,
              ),
              const SizedBox(
                height: 10,
              ),
              ButtonV1(
                onTap: () {
                  showLoading(context);
                  _register().then((value) {
                    var response = jsonDecode(value);
                    if (response["success"] == false) {
                      displayDialog(context, "Failed", response["error"]);
                    } else {
                      User user = User.fromJson(response["user"]);

                      storage.write(key: "token", value: response["token"]);
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

              const Text("Already Registerd? Login"),
              const SizedBox(
                height: 6,
              ),

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
    );
  }
}
