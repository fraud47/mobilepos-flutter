import 'package:flutter/material.dart';

class ReceiptFilterButton extends StatelessWidget {
  const ReceiptFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {},
      icon: const Icon(Icons.filter_list,color: Colors.white,),
      label: const Text('FILTER : ALL',
      style: TextStyle(
        color: Colors.white
      ),),
    );
  }
}