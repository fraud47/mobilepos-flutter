import 'package:flutter/material.dart';


class FilterChipWidget extends StatelessWidget {
  final String title;
  final bool selected;

  const FilterChipWidget({
    super.key,
    required this.title,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      selectedColor: Colors.white,
      shadowColor: Colors.yellow,
      selected: selected,
      label: Text(title),
      onSelected: (_) {},
    );
  }
}