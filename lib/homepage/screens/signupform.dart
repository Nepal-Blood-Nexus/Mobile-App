import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:nepal_blood_nexus/utils/colours.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  // final _emailFieldKey = GlobalKey<FormBuilderFieldState>();
  late String gender;
  late int age;
  late String bloodGroup;
  late int weight;

  void saveAndNext(dynamic value) {
    debugPrint(value.toString());
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
                  onSaved: (value) {
                    setState(() {
                      gender = value.toString();
                    });
                  },
                ),
                FormBuilderDropdown(
                    name: "blood_group",
                    onSaved: (value) {
                      setState(() {
                        bloodGroup = value.toString();
                      });
                    },
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
                  color: Colours.mainColor,
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
                    saveAndNext(_formKey.currentState?.value);
                  },
                  child: const Text('Save & Next',
                      style: TextStyle(color: Colors.white)),
                )
              ],
            ),
          ),
        ));
  }
}
