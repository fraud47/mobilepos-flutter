import 'package:flutter/material.dart';

class UserTabItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;

  const UserTabItem({
    super.key,
    required this.icon,
    required this.title,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? Colors.blue : Colors.black54;

    return InkWell(
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Icon(icon, color: color),

          const SizedBox(height: 8),

          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight:
              selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 3,
            width: selected ? 48 : 0,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
            ),
          )
        ],
      ),
    );
  }
}