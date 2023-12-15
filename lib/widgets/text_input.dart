import 'package:flutter/material.dart';
import 'package:nepal_blood_nexus/utils/colours.dart';

class CustomTextInput extends StatelessWidget {
  const CustomTextInput(
      {super.key,
      this.controller,
      this.hintText,
      this.readOnly,
      this.textAlign,
      this.textInputType,
      this.prefix,
      this.onTap,
      this.suffixIcon,
      this.onChange,
      this.obsureText});

  final TextEditingController? controller;
  final String? hintText;
  final bool? readOnly;
  final TextAlign? textAlign;
  final TextInputType? textInputType;
  final String? prefix;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final Function(String)? onChange;
  final bool? obsureText;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          onTap: onTap,
          controller: controller,
          readOnly: readOnly ?? false,
          textAlign: textAlign ?? TextAlign.start,
          keyboardType: readOnly == null ? textInputType : null,
          onChanged: onChange,
          obscureText: obsureText ?? false,
          decoration: InputDecoration(
              filled: false,
              // fillColor: const Color.fromARGB(255, 213, 95, 95),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colours.mainColor)),
              focusedBorder: const OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 213, 95, 95))),
              isDense: true,
              prefixText: prefix,
              suffix: suffixIcon,
              hintText: hintText,
              hintStyle:
                  const TextStyle(color: Color.fromARGB(255, 191, 48, 48))),
        ));
  }
}
