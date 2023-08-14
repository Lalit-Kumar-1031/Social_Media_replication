import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final TextInputType textInputType;
  final String hintText;


   TextFieldInput(
      {Key? key,
      required this.textEditingController, this.isPass=false,
      required this.textInputType,
      required this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputborder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextFormField(
      controller: textEditingController,
      onTap: (){},
      decoration: InputDecoration(
        border: inputborder,
        focusedBorder: inputborder,
        enabledBorder: inputborder,
        contentPadding: EdgeInsets.all(8),

        hintText: hintText,
        filled: true,
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
