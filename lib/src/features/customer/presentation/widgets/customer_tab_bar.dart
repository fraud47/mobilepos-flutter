import 'package:flutter/material.dart';

class CustomerTabBar extends StatelessWidget {
  const CustomerTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabBar(
      indicatorWeight: 3,
      tabs: [
        Tab(text: "ALL CUSTOMERS"),
        Tab(text: "DUE CUSTOMERS"),
      ],
    );
  }
}