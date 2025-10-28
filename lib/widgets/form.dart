import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final int maxLines;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;

  const AppTextFormField({
    Key? key,
    required this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.obscureText = false,
    this.maxLines = 1,
    this.focusNode,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: maxLines,
        onChanged: onChanged,
        validator: validator,
        style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 23,
            color: Color(0xff9956A3)),
        decoration: InputDecoration(
          // hintText: hintText,
          hint: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                hintText,
                style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 23,
                    color: Color(0xff9956A3)),
              ),
            ],
          ),
          fillColor: Colors.white,
          border: const OutlineInputBorder(borderSide: BorderSide.none),

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
