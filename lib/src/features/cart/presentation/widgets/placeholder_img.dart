import 'package:flutter/material.dart';

class PlaceholderImg extends StatelessWidget {
  const PlaceholderImg({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRect(

      child: ColoredBox(
          color: Colors.grey.shade100,
          child: const Center(
            child: Icon(
              Icons.image,
              size: 40,
              color: Colors.grey,
            ),
          ),
        ),
    );

  }
}
