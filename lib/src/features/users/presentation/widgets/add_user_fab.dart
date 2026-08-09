import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:go_router/go_router.dart';

import '../../../../imports/core_imports.dart';

class AddUserFAB extends StatelessWidget {
  const AddUserFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () =>context.push(AppRoutes.addUser),
      child: const Icon(FlutterRemix.user_add_line,color: Colors.white,),
    );
  }
}