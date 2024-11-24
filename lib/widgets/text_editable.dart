import 'package:flutter/material.dart';

class NewEditable extends StatelessWidget {
  final String LabelText;
  final String placeholder;
  final bool isPass;

  const NewEditable({
    super.key,
    required this.LabelText,
    required this.placeholder,
    required this.isPass,
  });
  //final TextEditingController controller;
  //final ValueChanged<String>? onChanged;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextField(
          obscureText: isPass ? true : false,
          decoration: InputDecoration(
              suffixIcon: isPass
                  ? IconButton(
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: Colors.grey,
                      ),
                      onPressed: () {},
                    )
                  : null,
              contentPadding: const EdgeInsets.only(bottom: 5),
              labelText: LabelText,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: placeholder,
              hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              )),
        ));
  }
}
