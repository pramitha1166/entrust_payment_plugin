import 'package:flutter/material.dart';

class TextFiledWithLabel extends StatelessWidget {
  final String title;
  final TextEditingController? textController;

  const TextFiledWithLabel(
      {super.key, required this.textController, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          child: TextFormField(
            controller: textController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
            ),
          ),
        )
      ],
    );
  }
}
