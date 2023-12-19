import 'package:flutter/material.dart';

class InputLabel extends StatefulWidget {
  final String text;
  final bool isRequired;

  const InputLabel({
    Key? key,
    required this.text,
    required this.isRequired,
  }) : super(key: key);

  @override
  State<InputLabel> createState() => _InputLabelState();
}

class _InputLabelState extends State<InputLabel> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Text.rich(TextSpan(children: <TextSpan>[
        TextSpan(
          text: widget.text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Avenir',
            fontWeight: FontWeight.bold,
          ),
        ),
        if (widget.isRequired)
          const TextSpan(
            text: ' *',
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 16,
              fontFamily: 'Avenir',
              fontWeight: FontWeight.bold,
            ),
          ),
      ])),
    );
  }
}
