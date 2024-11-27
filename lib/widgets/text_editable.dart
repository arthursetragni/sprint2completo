import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class NewEditable extends StatelessWidget {
  final String LabelText;
  final String placeholder;
  final TextEditingController controller;
  final bool isPass;
  final bool isCell;
  final bool isDate;

  const NewEditable({
    super.key,
    required this.LabelText,
    required this.placeholder,
    required this.controller,
    required this.isPass,
    required this.isCell,
    required this.isDate,
  });
  //final TextEditingController controller;
  //final ValueChanged<String>? onChanged;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: TextField(
          controller: controller,
          obscureText: isPass ? true : false,
          //condições para celular e data
          keyboardType: isCell
              ? TextInputType.phone
              : isDate
                  ? TextInputType.datetime
                  : TextInputType.text,
          inputFormatters: isCell
              ? [
                  MaskTextInputFormatter(
                      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')})
                ]
              : isDate
                  ? [
                      MaskTextInputFormatter(
                          mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')})
                    ]
                  : [],
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
              hintText:
                  placeholder, //controller.text.isEmpty ? placeholder : null,
              hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              )),
        ));
  }
}
