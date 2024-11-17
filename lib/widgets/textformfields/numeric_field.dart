import 'package:flutter/material.dart';

class NumericField extends StatelessWidget {
  final String text;
  final Icon iconn;
  final TextEditingController controller;
  const NumericField({
    super.key,
    required this.controller, required this.text, required this.iconn,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 8.0,
      ),
      child: TextFormField(
        autofocus: false,
        controller: controller,
        keyboardType: TextInputType.number,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("$text cannot be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid $text");
          }
          return null;
        },
        onSaved: (value) {
          controller.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon:  iconn,
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: text,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
