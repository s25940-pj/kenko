import 'package:flutter/material.dart';

class KenkoNavBar extends StatelessWidget {
  const KenkoNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: const Color.fromARGB(191, 244, 67, 54),
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/medications');
                },
                icon: const Icon(
                  Icons.medication_outlined,
                  color: Colors.white,
                )),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
                icon: const Icon(
                  Icons.home_outlined,
                  color: Colors.white,
                )),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/account');
                },
                icon: const Icon(
                  Icons.account_circle_outlined,
                  color: Colors.white,
                )),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
                icon: const Icon(
                  Icons.settings_outlined,
                  color: Colors.white,
                )),
          ],
        ),
      ),
    );
  }
}
