import 'dart:convert';

import 'package:animated_icon/animated_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:nepal_blood_nexus/utils/colours.dart';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';
import 'package:nepal_blood_nexus/utils/models/user.dart';
import 'package:nepal_blood_nexus/utils/routes.dart';

const storage = FlutterSecureStorage();

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  // final _emailFieldKey = GlobalKey<FormBuilderFieldState>();
  late bool loading = false;
  late User user;
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

  Future saveAndNext(dynamic value) async {
    setState(() {
      loading = true;
    });
    String? token = await storage.read(key: "token");
    var url =
        Uri.https('nbn-server.onrender.com', 'api/auth/profile', {"step": "1"});

    var res = await http.post(url, body: {
      "gender": value["gender"],
      "bp": value["bp"],
      "blood_group": value["blood_group"],
      "weight": value["weight"],
      "age": value["age"]
    }, headers: {
      "authorization": "Bearer $token"
    });
    var response = jsonDecode(res.body);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          width: 350,
          child: FormBuilder(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FormBuilderRadioGroup(
                  name: "gender",
                  options: const [
                    FormBuilderChipOption(value: "Male"),
                    FormBuilderChipOption(value: "Female"),
                  ],
                  decoration: const InputDecoration(labelText: 'Gender'),
                ),
                FormBuilderDropdown(
                    name: "blood_group",
                    decoration: const InputDecoration(
                        labelText: 'Select your blood group'),
                    items: const [
                      DropdownMenuItem(
                        value: "AB +ve",
                        child: Text("AB +ve"),
                      ),
                      DropdownMenuItem(
                        value: "AB -ve",
                        child: Text("AB -ve"),
                      ),
                      DropdownMenuItem(
                        value: "A -ve",
                        child: Text("A -ve"),
                      ),
                      DropdownMenuItem(
                        value: "A +ve",
                        child: Text("A +ve"),
                      ),
                      DropdownMenuItem(
                        value: "B +ve",
                        child: Text("B +ve"),
                      ),
                      DropdownMenuItem(
                        value: "B -ve",
                        child: Text("B -ve"),
                      ),
                      DropdownMenuItem(
                        value: "O +ve",
                        child: Text("O +ve"),
                      ),
                      DropdownMenuItem(
                        value: "O -ve",
                        child: Text("O -ve"),
                      ),
                    ]),
                FormBuilderTextField(
                  name: 'age',
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Age'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                FormBuilderTextField(
                  name: 'weight',
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Weight'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                FormBuilderTextField(
                  name: 'bp',
                  keyboardType: TextInputType.text,
                  decoration:
                      const InputDecoration(labelText: 'Blood Pressure 80/120'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                // const SizedBox(height: 10),
                // FormBuilderTextField(
                //   name: 'confirm_password',
                //   autovalidateMode: AutovalidateMode.onUserInteraction,
                //   decoration: InputDecoration(
                //     labelText: 'Confirm Password',
                //     suffixIcon: (_formKey.currentState
                //                 ?.fields['confirm_password']?.hasError ??
                //             false)
                //         ? const Icon(Icons.error, color: Colors.red)
                //         : const Icon(Icons.check, color: Colors.green),
                //   ),
                //   obscureText: true,
                //   validator: (value) =>
                //       _formKey.currentState?.fields['password']?.value != value
                //           ? 'No coinciden'
                //           : null,
                // ),
                // const SizedBox(height: 10),
                FormBuilderFieldDecoration<bool>(
                  name: 'tos',
                  validator: FormBuilderValidators.compose([
                    // FormBuilderValidators.required(),
                    FormBuilderValidators.equal(true,
                        errorText: "Accept Terms to save & continue"),
                  ]),
                  initialValue: true,
                  decoration: const InputDecoration(labelText: 'Accept Terms?'),
                  builder: (FormFieldState<bool?> field) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        errorText: field.errorText,
                      ),
                      child: SwitchListTile(
                        title: const Text(
                            'I have read and accept the terms of service.'),
                        onChanged: field.didChange,
                        value: field.value ?? false,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                MaterialButton(
                  height: 50,
                  minWidth: 150,
                  color: Colours.mainColor,
                  disabledColor: Colors.black87,
                  onPressed: () {
                    if (_formKey.currentState?.saveAndValidate() ?? false) {
                      // if (true) {
                      //   // Either invalidate using Form Key
                      //   _formKey.currentState?.fields['email']
                      //       ?.invalidate('Email already taken.');
                      //   // OR invalidate using Field Key
                      //   // _emailFieldKey.currentState?.invalidate('Email already taken.');
                      // }
                    }
                    saveAndNext(_formKey.currentState?.value).then((response) {
                      if (response["success"] == false) {
                        displayDialog(context, "Failed", response["error"]);
                        setState(() {
                          loading = false;
                        });
                      } else {
                        User user = User.fromJson(response["user"]);

                        storage.write(key: "token", value: response["token"]);
                        storage.write(
                            key: "user", value: jsonEncode(response["user"]));
                        setState(() {
                          loading = false;
                        });
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.home,
                          (routes) => false,
                          arguments: {"token": response["token"], "user": user},
                        );
                      }
                    });
                  },
                  child: loading
                      ? AnimateIcon(
                          onTap: () {},
                          iconType: IconType.continueAnimation,
                          height: 16,
                          width: 16,
                          color: Colours.mainColor,
                          animateIcon: AnimateIcons.loading5,
                        )
                      : const Text('Save & Next',
                          style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ));
  }
}
