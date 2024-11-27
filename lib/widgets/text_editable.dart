import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class NewEditable extends StatefulWidget {
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

  @override
  _NewEditableState createState() => _NewEditableState();
}

class _NewEditableState extends State<NewEditable> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: TextField(
          controller: widget.controller,
          obscureText: widget.isPass ? true : false,
          //condições para celular e data
          keyboardType: widget.isCell
              ? TextInputType.phone
              : widget.isDate
                  ? TextInputType.datetime
                  : TextInputType.text,
          inputFormatters: widget.isCell
              ? [
                  MaskTextInputFormatter(
                      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')})
                ]
              : widget.isDate
                  ? [
                      MaskTextInputFormatter(
                          mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')})
                    ]
                  : [],
          decoration: InputDecoration(
              suffixIcon: widget.isPass
                  ? IconButton(
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: Colors.grey,
                      ),
                      onPressed: () {},
                    )
                  : null,
              contentPadding: const EdgeInsets.only(bottom: 5),
              labelText: widget.LabelText,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: widget
                  .placeholder, //controller.text.isEmpty ? placeholder : null,
              hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              )),
        ));
  }
}
