import 'package:flutter/material.dart';
import 'package:kenko/main.dart';

class KenkoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const KenkoAppBar({
    super.key,
    required this.widget,
  });

  final MyHomePage widget;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Center(
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(12.0), // Adjust the radius as needed
          child: Container(
            color: Colors.redAccent,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: 'Avenir',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}
