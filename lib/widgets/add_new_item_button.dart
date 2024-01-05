import 'package:flutter/material.dart';

class AddNewItemButton extends StatelessWidget {
  final String routeName;

  const AddNewItemButton({
    super.key,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: const Color.fromARGB(255, 247, 34, 19),
      onPressed: () {
        Navigator.pushNamed(context, routeName);
      },
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}
