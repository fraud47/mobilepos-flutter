import 'package:flutter/material.dart';

class UsersAppBar extends StatelessWidget
    implements PreferredSizeWidget {

  const UsersAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const BackButton(),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.call),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}